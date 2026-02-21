`timescale 1ns / 1ps
module alu_32bit (
    input [31:0] A,          // 32-bit input A
    input [31:0] B,          // 32-bit input B
    input [3:0] opcode,      // 4-bit opcode
    output reg [31:0] Result, // 32-bit Result
    output reg Zero          // Single bit Zero flag
);

    always @(*) begin
        // ALU Operation Logic based on Table 1
        case (opcode)
            4'b0000: Result = A + B;          // Addition
            4'b0010: Result = A - B;          // Subtraction
            4'b0100: Result = A & B;          // Bitwise AND
            4'b0101: Result = A | B;          // Bitwise OR
            4'b0110: Result = ~(A | B);       // Bitwise NOR
            4'b1010: Result = A ^ B;          // Bitwise XOR
            4'b1111: Result = (A < B) ? 32'd1 : 32'd0; // slt
            default: Result = 32'bx;          // Don't care
        endcase

        // Zero Flag Logic: Only 1 if slt is true (Opcode 1111)
        if (opcode == 4'b1111) begin
            Zero = (A < B) ? 1'b1 : 1'b0;     // Set if A < B
        end else begin
            Zero = 1'b0;                      // Keep 0 for all other operations
        end
    end
endmodule
