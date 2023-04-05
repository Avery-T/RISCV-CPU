`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Avery Taylor
// 
// Create Date: 02/19/2023 10:03:53 AM
// Design Name: 
// Module Name: CU_FSM
// Project Name: Otter MCU
// Target Devices: basys3 board
// Tool Versions: 
// Description: Serves as the finite state machine. 
// Takes in Op-Codes and determines whether to enable writes
// and reads and resets to other part of the MCU
//////////////////////////////////////////////////////////////////////////////////
module CU_FSM( 
    input logic rst, 
    input logic [6:0] ir_opcode, //op code that the always_comb uses
    input logic [2:0] ir_func, 
    input logic clk, 
    output logic PcWrite, 
    output logic regWrite, 
    output logic memWE2, 
    output logic memRDEN1, 
    output logic memRDEN2, 
    output logic reset //resets the fsm
    
); 
 
    typedef enum {ST_INIT, ST_FETCH, ST_EXEC, ST_WRITE_BACK} STATES; // typedef defines a specific type of signal, enum is shorthad for enumerate - assigns an unique value to all in list, list contains labels for the states, // STATES is the name of the signal type defined. 
 
    STATES PS, NS; // create signals for present state, next state 
 
    // FSM State Register 
    always_ff @ (posedge clk) begin 
        if (rst == 1'b1) 
            PS <= ST_INIT; 
        else 
            PS <= NS; 
    end 
    // always_ff is only block that changes PS 
    // logic for setting all outputs and NS 
    always_comb begin 
 
        PcWrite = 1'b0; 
        regWrite =1'b0; 
        reset = 1'b0; 
        memWE2 =1'b0; 
        memRDEN1 =1'b0; 
        memRDEN2 = 1'b0; 
 
        // Set all outputs of CU FSM to zero 
        case (PS) 
            ST_INIT: begin 
                NS = ST_FETCH; 
                reset = 1'b1; 
            end 
            ST_FETCH: begin 
                NS = ST_EXEC; 
                memRDEN1 = 1'b1; 
            end 
            ST_WRITE_BACK: begin 
                PcWrite = 1'b1;
                regWrite =1'b1;
                NS = ST_FETCH; 
            end 
            ST_EXEC: begin 
                NS = ST_FETCH; 
                case (ir_opcode) 
                    7'b0000011: begin // loads require an extra state, so set pc to zero
                        PcWrite = 1'b0; 
                        memRDEN2 = 1'b1; 
                        NS=ST_WRITE_BACK; 
 
                    end 
 
                    7'b0110111: begin // LUI 
                        PcWrite =1'b1; 
                        memRDEN1 =1'b1; 
                        regWrite = 1'b1; 
                        NS = ST_FETCH; 
                    end 
 
                    7'b0010111:begin //AUIPC 
                        memRDEN1 = 1'b1; 
                        PcWrite = 1'b1; 
                        regWrite = 1'b1; 
                        NS = ST_FETCH; 
                    end 
                    7'b1101111: begin //JAL 
                        memRDEN1=1'b1; 
                        PcWrite=1'b1; 
                        regWrite=1'b1; 
                        NS = ST_FETCH; 
                    end 
                    7'b1100111: begin //JALr 
                        memRDEN1=1'b1; 
                        PcWrite=1'b1; 
                        regWrite=1'b1; 
                        NS = ST_FETCH; 
                    end 
                    7'b0010011: begin //I type immedate instructions ADDI SLTI SLTIU    
                        //ORI XORI ANDI SLLI SRLI SRAI 
                        PcWrite=1'b1; 
                        regWrite=1'b1; 
 
                        NS = ST_FETCH; 
                    end 
 
                    7'b1100011: begin //Branches 
                        PcWrite=1'b1; 
                        NS = ST_FETCH; 
                    end 
 
                    7'b0100011: begin //Stores 
                        memWE2 =1'b1;
                        PcWrite = 1'b1; 
                        NS = ST_FETCH; 
                    end 
 
                    7'b0110011: begin // adds shifts sub bitwise (Rtypes)
                        PcWrite=1'b1; 
                        regWrite=1'b1; 
                        NS = ST_FETCH; 
 
                    end 
                endcase 
            end 
        
            default: NS=ST_INIT; 
        endcase 
   end 
   endmodule   