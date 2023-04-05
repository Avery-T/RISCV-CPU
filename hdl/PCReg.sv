`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Avery Taylor, Cayden Covarrubias
// 
// Create Date: 01/25/2023 05:13:05 PM
// Module Name: PCMux
// Project Name: MCU_Otter
// Target Devices: basys3 board 
// Description: Program Counter
// keeps track of what program the MCU is at.
// takes input from a mux to determine what the next program to run is.
//////////////////////////////////////////////////////////////////////////////////

module PCReg( 
    input logic [31:0] new_instruct,  
    input logic ein, 
    input logic reset,  
    input logic clk, 
    output logic [31:0] pc_address 
 ); 
  
 always_ff @(posedge clk)
    begin  
    if(reset) pc_address <= 0;  //sync reset
    else if (ein) pc_address <= new_instruct; //every posedge increase the instruction
    end  
endmodule 