`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal poly
// Engineer: Avery Taylor
// 
// Create Date: 02/24/2023 06:43:03 PM
// Module Name: CU_DCDR
// Project Name: Otter MCU
// Target Devices: basys3 board
// Description: Control Unit Decoder. Takes in an opcode and 
// determines selects for the muxes throughout the MCU.
//////////////////////////////////////////////////////////////////////////////////


module CU_DCDR(
 input logic [6:0] ir_opcode,
 input logic ir_bit30,
 input logic int_taken, 
 input logic [2:0] ir_func,
 input logic br_eq, br_lt, br_ltu, 
 output logic [3:0] alu_fun,
 output logic alu_srcA,
 output logic [1:0] alu_srcB,
 output logic [2:0] pcSource,
 output logic [1:0] rf_wr_sel 
 );
always_comb begin

// Set all outputs of CU DCDR to zero, if an output is not defined will create a latch
alu_fun =3'b0;
alu_srcA=1'b0;
alu_srcB=2'b0;
pcSource= 2'b0;   
rf_wr_sel = 2'b0; 
case (ir_opcode)
    7'b0110011: begin   //Rtypes the only thing that changes is the fun
       // pcSource = 0;
       //alu_srcA = 0;
       //alu_srcB = 0;
        rf_wr_sel = 3;
        alu_fun = {ir_bit30, ir_func}; 
     
        end
////ITYPES  
//bit 30 is part of the imedate for i types so cant do it like r type
    7'b0010011: begin   //I type immedate instructions ADDI SLTI SLTIU ORI XORI ANDI SLLI SRLI SRAI
        //pcSource = 0;
        //alu_srcA = 0;
        alu_srcB = 1; //so the alu can get the i-immediate instruciton 
        rf_wr_sel = 3;
        //alu_fun = 0; //its zero because add for everything but sra and sub so setting to zero  
        if(ir_func == 3'b101) alu_fun = {ir_bit30,ir_func}; //sra and sll has bit 30 avaliable
        else 
           alu_fun = {1'b0, ir_func}; 
        end   
        
//LOADS   //Itpes
    7'b0000011: begin 
       // pcSource = 0;
        //alu_srcA = 0;
        alu_srcB = 1; //so the alu can get the i-immediate instruciton 
        //alu_fun = 0; //all loads add an immedate
        rf_wr_sel = 2;
       end
       
      7'b1100011: begin   //Branches
      //alu_fun doesnt get used for branches //doesnt uses anything else besid pcSource because branch condition generator supplys the value and cu ducudor just tells pc to jump
     
      //depending on which instruction the pcSource will change dependings on the 3 inputs
         case(ir_func) // beq beu blu are either 1 and 0 so not using if statemets just addition for pc sourse since psource 
                    3'b000: begin //BEQ 
                         //if its a zero 0 + 0 is zero  and pc will be pc+4
                         pcSource = br_eq + br_eq; // branch is at pcSource 2 so if br_eq is euqal then its a 1 so pcSource = 2 when its added together
                        end
             
                    3'b001: begin
                         //BNE br_eq would be zero so negate the bits
                        pcSource = !br_eq + !br_eq;
                        end
                    3'b100: begin //BLT
                        pcSource = br_lt + br_lt;
                        end
                    3'b101: begin //BGE
                        pcSource = !br_lt + !br_lt;
                        end
                    3'b110: begin //BLTU
                        pcSource = br_ltu + br_ltu;
                        end
                    3'b111: begin  //BGEU
                        pcSource = !br_ltu + !br_ltu;
                        end
                    endcase 
      end  
      
      7'b0100011: begin   //Stores
       // pcSource = 0;
        //alu_srcA = 0; 
        alu_srcB = 2; //so the alu can get the i-immediate instruciton 
        //alu_fun = 0; //all loads add an immedate
        end 
        
       7'b0110111: begin // LUI
       // pcSource = 0;
        alu_srcA = 1; 
        alu_fun = 4'b1001; //all loads add an immedate
        rf_wr_sel = 3;
        end
         
        7'b0010111:begin //AUIPC
       // pcSource = 0;
        alu_srcA = 1;  //FOR U TYPE
        alu_srcB = 3;    //for pc 
        alu_fun = 4'b0000;
        rf_wr_sel = 3;
        end
        
        7'b1101111: begin//JAL
        pcSource =3'b011; // for jall 
        //rf_wr_sel=0; 
        end
        

       7'b1100111: begin //JALI 
        pcSource =3'b001; // for jalr 
        //rf_wr_sel=0;
        end
        
   endcase     


    
    
  end 
    
endmodule
