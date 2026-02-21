`timescale 1ns / 1ps
module sobel_filter (
    input wire clk, input wire rst_n,
    input wire [7:0] p11, p12, p13, p21, p22, p23, p31, p32, p33,
    output reg [7:0] edge_out
);
    reg signed [10:0] Gx, Gy;
    reg [10:0] abs_G;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Gx <= 0; Gy <= 0; edge_out <= 0;
        end else begin
            Gx <= (p13 + (p23 << 1) + p33) - (p11 + (p21 << 1) + p31);
            Gy <= (p11 + (p12 << 1) + p13) - (p31 + (p32 << 1) + p33);
            abs_G <= (Gx[10] ? -Gx : Gx) + (Gy[10] ? -Gy : Gy);
            edge_out <= (abs_G > 255) ? 8'hFF : abs_G[7:0];
        end
    end
endmodule
