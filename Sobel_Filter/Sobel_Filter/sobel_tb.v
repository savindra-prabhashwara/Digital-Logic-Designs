`timescale 1ns / 1ps

module tb_sobel();
    // Dimensions for your 740x415 image
    parameter WIDTH  = 740;
    parameter HEIGHT = 415;
    parameter TOTAL_PIXELS = WIDTH * HEIGHT;

    reg clk;
    reg rst_n;
    reg [7:0] img_mem [0:TOTAL_PIXELS-1];
    reg [7:0] p11, p12, p13, p21, p22, p23, p31, p32, p33;
    wire [7:0] edge_out;
    
    integer i, j, out_file, in_file, status;

    sobel_filter uut (
        .clk(clk), .rst_n(rst_n),
        .p11(p11), .p12(p12), .p13(p13),
        .p21(p21), .p22(p22), .p23(p23),
        .p31(p31), .p32(p32), .p33(p33),
        .edge_out(edge_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; rst_n = 0;
        
        // Open the matrix-formatted input
        in_file = $fopen("input_matrix.txt", "r");
        if (in_file == 0) begin
            $display("ERROR: Could not open image_matrix.txt");
            $finish;
        end

        for (i = 0; i < TOTAL_PIXELS; i = i + 1) begin
            status = $fscanf(in_file, "%h", img_mem[i]);
        end
        $fclose(in_file);

        out_file = $fopen("output_hex.txt", "w");
        
        #20 rst_n = 1;
        @(posedge clk);

        // --- UPDATED MATRIX WRITING LOGIC ---
        for (i = 1; i < HEIGHT-1; i = i + 1) begin
            for (j = 1; j < WIDTH-1; j = j + 1) begin
                @(posedge clk);
                p11 <= img_mem[(i-1)*WIDTH + (j-1)];
                p12 <= img_mem[(i-1)*WIDTH + (j)];
                p13 <= img_mem[(i-1)*WIDTH + (j+1)];
                p21 <= img_mem[(i)*WIDTH   + (j-1)];
                p22 <= img_mem[(i)*WIDTH   + (j)];
                p23 <= img_mem[(i)*WIDTH   + (j+1)];
                p31 <= img_mem[(i+1)*WIDTH + (j-1)];
                p32 <= img_mem[(i+1)*WIDTH + (j)];
                p33 <= img_mem[(i+1)*WIDTH + (j+1)];
                
                #1; 
                if (edge_out !== 8'hxx) begin
                    // Write pixel followed by a space
                    $fwrite(out_file, "%h ", edge_out);
                end
            end
            // After finishing one row, write a newline
            $fwrite(out_file, "\n");
        end
        
        $fclose(out_file);
        $display("Simulation Finished at %t", $time);
        $finish;
    end
endmodule
