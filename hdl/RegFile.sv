`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Avery Taylor
// 
// Create Date: 01/31/2023 11:02:34 PM
// Module Name: RegFile
// Project Name: MCU_Otter
// Target Devices: basys3 board
// Description: Register file. Enables reading and writeing data to the temporary registers
//////////////////////////////////////////////////////////////////////////////////


module RegFile(
    input logic en, //enables writing of data onto ram
    input logic [4:0] adr1, adr2 , wa, //address 1, address 2, and write address
    input logic [31:0] wd, //data to be written
    input logic clk,
    output logic [31:0] rs1, rs2
    );
    
    logic [31:0]ram[0:31]; 
    //async reading
    assign rs1 = ram[adr1]; 
    assign rs2 = ram[adr2]; 
     
    initial begin
    for(int i =0; i<32; i++) //initalize the contents of ram to zero 
        ram[i] = 0;
    end 
    
    always_ff @(posedge clk) 
    begin 
        if(en && wa!=0) //if enable is on and the write address is not zero then write
        begin        //makes sure nothing is written to the zero registor
            ram[wa] <= wd;
        end       
    end
  
endmodule
    