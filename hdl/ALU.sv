`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Avery Taylor
// 
// Create Date: 02/11/2023 11:13:09 AM
// Module Name: ALU
// Project Name: MCU_Otter 
// Target Devices: basys3
// Description: Arithmatic logic unit. 
// A mux that performs a function based on input from ALU_FUN
// and the source inputs
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU(
    input logic [3:0] alu_fun, //selector for mux (chooses the alu operation)
    input logic [31:0] srcA, srcB, //sources for mux
    output logic [31:0] result 
    );
    
    always_comb begin 
    
    case(alu_fun)
    
    4'b0000: result = srcA + srcB; //add
    4'b1000: result = srcA - srcB; //sub
    4'b0110: result = srcA | srcB; //or
    4'b0111: result = srcA & srcB; //and
    4'b0100: result = srcA ^ srcB; //xor
    4'b0101: result = srcA >> srcB[4:0]; //srl
    4'b0001: result = srcA << srcB[4:0]; //sll
    4'b1101: result = $signed(srcA) >>> srcB[4:0]; //sra 
    4'b0010: result = $signed(srcA) < $signed(srcB);//slt          
    4'b0011: result = srcA < srcB; //sltu
    4'b1001: result  = srcA; //lui
    default: result = 32'hdead;

    endcase
    end
endmodule