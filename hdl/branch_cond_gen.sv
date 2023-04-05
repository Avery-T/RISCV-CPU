`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CalPoly
// Engineer: Avery Taylor, Cayden Covarrubias
// 
// Create Date: 02/10/2023 12:07:14 PM
// Module Name: branchCondGen
// Project Name: MCU_Otter
// Target Devices: basys3 board
// Description: compares registors 1 and 2 and outputs the result
//////////////////////////////////////////////////////////////////////////////////


module  Branch_Cond_Gen(
input logic [31:0] rs1,rs2,
output logic br_eq, br_lt, br_ltu
);

always_comb begin

br_eq = 0; br_ltu = 0; br_lt = 0; //setting all to zero for less code in the if statements
if (rs1 == rs2) //br_eq (if the two inputs are equal)
    br_eq = 1;

else if(rs1< rs2) //br_ltu (if register 1 unsigned is less than registor 2)
    br_ltu = 1;
    
if($signed(rs1) < $signed(rs2)) //br_lt (if the fist signed registor is less than the other)
    br_lt = 1;   
    
end
endmodule