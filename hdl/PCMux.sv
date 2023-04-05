`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Avery Taylor
// 
// Create Date: 01/25/2023 05:13:05 PM
// Module Name: PCMux
// Project Name: Otter MCU
// Target Devices: basys3 board 
// Description: The Mux that selects which instruction the PCReg gives
//////////////////////////////////////////////////////////////////////////////////

module PCMux( 
    input logic [31:0] word, //the next instruction 
    input logic [31:0] jalr,   
    input logic [31:0] branch, 
    input logic [31:0] jal, 
    input logic [31:0] mtvec, 
    input logic [31:0] mepc,  
    input logic [2:0] pc_source, 
    output logic [31:0] mux_out 
    ); 
      
    always_comb  
    begin  
 
    case(pc_source)   
        3'd0: mux_out = word;  //the next instruction 
        3'd1: mux_out = jalr; 
        3'd2: mux_out = branch; //for jumping
        3'd3: mux_out = jal; 
        3'd4: mux_out = mtvec; // not using these instructions but have them to add in later for the CSR
        3'd5: mux_out = mepc; // not using these instructions but have them to add in later for the CSR
        default: mux_out = 0;  
    endcase 
    end  
endmodule 