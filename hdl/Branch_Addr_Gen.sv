`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Avery Taylor
// 
// Create Date: 02/11/2023 03:20:24 PM
// Module Name: Branch_Addr_Gen
// Project Name: MCU_Otter
// Target Devices: basys3 board
// Description: Branch address generator
// used in branch type instructions to change the location of the PC.
// 
//////////////////////////////////////////////////////////////////////////////////

module Branch_Addr_Gen( 
    input logic [31:0] PC, J_Type, B_Type, I_Type, rs1, 
    output logic [31:0] jal, jalr, branch 
    ); 
    
    assign jal = J_Type + PC; 
     
    assign jalr = rs1 + I_Type;   

    assign branch = PC + B_Type; 
    
endmodule 
