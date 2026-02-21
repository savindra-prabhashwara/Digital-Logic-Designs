module alu_tb;
    reg [31:0] A, B;
    reg [3:0] opcode;
    wire [31:0] Result;
    wire Zero;

    // Instantiate the ALU [cite: 6]
    alu_32bit uut (
        .A(A), 
        .B(B), 
        .opcode(opcode), 
        .Result(Result), 
        .Zero(Zero)
    );

    // Task to run the required simulations [cite: 20]
    task run_test(input [31:0] a_val, input [31:0] b_val);
        integer i;
        reg [3:0] ops [0:6];
        begin
            A = a_val; B = b_val;
            ops[0]=4'b0000; ops[1]=4'b0010; ops[2]=4'b0100; 
            ops[3]=4'b0101; ops[4]=4'b0110; ops[5]=4'b1010; ops[6]=4'b1111;
            
            // All 7 functions [cite: 21]
            for (i = 0; i < 7; i = i + 1) begin
                opcode = ops[i];
                #10;
            end
            // Random 4-bit instruction [cite: 21]
            opcode = $random;
            #10;
        end
    endtask

    initial begin
        run_test(32'd10, 32'd5);               // Set 1 [cite: 23]
        run_test(32'd5673982, 32'd8436235);    // Set 2 [cite: 24]
        run_test(32'd934, 32'd934);            // Set 3 [cite: 25]
        $finish;
    end
endmodule
