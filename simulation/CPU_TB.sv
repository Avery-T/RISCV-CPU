`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2023 11:42:00 AM
// Design Name: 
// Module Name: CPU_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CPU_TB( );

logic [31:0] IOBUS_IN, IOBUS_OUT, IOBUS_ADDR;
logic RST,CLK,IOBUS_WR; 

CPU UUT(.RST(RST),.CLK(CLK),.IOBUS_ADDR(IOBUS_ADDR),.IOBUS_IN(IOBUS_IN),.IOBUS_WR(IOBUS_WR),.IOBUS_OUT); 

always begin 
#10
CLK=~CLK; 
end

always begin 
#60 
RST = 1'b0;
IOBUS_IN = 32'h0; 
end 

initial begin 
CLK=1'b0;
end

endmodule

