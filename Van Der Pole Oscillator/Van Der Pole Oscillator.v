module VanDerPol_Engine (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] t_start,
    input  wire [31:0] y_start,
    input  wire [31:0] u_start,
    input  wire [31:0] delta_t,
    input  wire [31:0] limit_a,
    output reg  [31:0] y_final,
    output reg         is_done
);

    // State Encoding for the Controller
    localparam START     = 3'b000,
               CALC_STEP = 3'b001,
               UPDATE_Y  = 3'b010,
               UPDATE_U1 = 3'b011,
               UPDATE_U2 = 3'b100;

    reg [2:0]  current_state;
    reg [31:0] val_y, val_u, val_t;
    reg [31:0] step_y, step_u;
    reg        continue_loop;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= START;
            is_done       <= 1'b0;
        end else begin
            case (current_state)

                // Initialization: Load start parameters
                START: begin
                    val_u    <= u_start;
                    val_y    <= y_start;
                    val_t    <= t_start;
                    is_done  <= 1'b0;
                    current_state <= CALC_STEP;
                end

                // Step 1: Calculate basic increments and check bounds
                CALC_STEP: begin
                    step_u        <= val_u * delta_t;      // V1
                    step_y        <= val_y * delta_t;      // V3
                    val_t         <= val_t + delta_t;      // V8
                    continue_loop <= (val_t + delta_t < limit_a); 
                    current_state <= UPDATE_Y;
                end

                // Step 2: Scale increments and apply to Y
                UPDATE_Y: begin
                    step_u        <= 32'd3 * step_u;       // V2
                    step_y        <= 32'd3 * step_y;       // V4
                    val_y         <= val_y + step_u;       // V7 (Note: using V1 from previous state)
                    current_state <= UPDATE_U1;
                end

                // Step 3: First stage of U update
                UPDATE_U1: begin
                    step_u        <= val_u - step_u;       // V5
                    current_state <= UPDATE_U2;
                end

                // Step 4: Final U update and Branching
                UPDATE_U2: begin
                    val_u <= step_u - step_y;              // V6
                    
                    if (continue_loop) begin
                        current_state <= CALC_STEP;
                    end else begin
                        y_final       <= val_y;
                        is_done       <= 1'b1;
                        current_state <= START; // Reset to IDLE/START
                    end
                end

                default: current_state <= START;
            endcase
        end
    end

endmodule
