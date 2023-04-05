`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal poly
// Engineer: Avery Taylor
// 
// Create Date: 02/08/2023 07:16:26 PM
// Module Name: Immediate_Generator
// Project Name: Otter MCU
// Target Devices: basys3 board
// Description: Immediate Generator
// generates different types of immediates depending on the scenario
//////////////////////////////////////////////////////////////////////////////////


module Immediate_Generator(
    input logic [24:0] ir,
    output logic [31:0] i_immed, s_immed, b_immed, u_immed, j_immed
    );
   
    assign i_immed = $signed ({ {21{ir[24]}}, ir[23:18], ir[17:13]}); // used in immediate instructions
    assign s_immed = {{21{ir[24]}}, ir[23:18], ir[4:0]};  // used in store type instructions
    assign b_immed = {{20{ir[24]}},ir[0], ir[23:18], ir[4:1],1'b0};  // Used in branch type instructions
    assign j_immed = {{12{ir[24]}}, ir[12:5], ir[13], ir[23:14], 1'b0}; //Used in jal instructions
    assign u_immed = {ir[24:5], {12{1'b0}} }; // for load upper immediates and auipc instructions
   
endmodule
