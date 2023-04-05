`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Avery Taylor
// 
// Create Date: 01/25/2023 05:13:05 PM
// Module Name: ProgRom
// Project Name: MCU_Otter
// Target Devices: basys3 board
// Description: TOP level that connects the mux and the program counter.
// adds 4 to the output of the PC address
//////////////////////////////////////////////////////////////////////////////////
module ProgRom( 
 input logic [31:0] JALR, 
 input logic [31:0] BRANCH, 
 input logic [31:0] JAL, 
 input logic [31:0] MTVEC, 
 input logic [31:0] MEPC,  
 input logic [2:0] PC_SOURCE, 
 output logic [31:0] PC_ADDRESS, 
 output logic [31:0] PC_PLUS_4,  
 input logic RESET = 0, 
 input logic CLK, 
 input logic PC_WRITE 
 ); 
   
 logic [31:0] MUX_OUT;  
 assign PC_PLUS_4 = PC_ADDRESS + 4; //increases the program counter to the next instruction
 
 PCMux mux1(.word(PC_PLUS_4), .jalr(JALR), .branch(BRANCH), .jal(JAL), .mtvec(MTVEC), .mepc(MEPC), .pc_source(PC_SOURCE), .mux_out(MUX_OUT)); 
 PCReg pc_reg( .new_instruct(MUX_OUT), .pc_address(PC_ADDRESS), .ein(PC_WRITE), .reset(RESET), .clk(CLK) ); 
 
endmodule