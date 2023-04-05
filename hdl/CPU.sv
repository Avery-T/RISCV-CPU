`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Cal Poly
// Engineer: Avery Taylor, Cayden Covarrubias
// Create Date: 03/01/2023 11:38:04 AM
// Module Name: CPU
// Project Name: MCU_Otter
// Target Devices: basys3 board
// Description: the central processing unit for the otter. The top level module. 
//////////////////////////////////////////////////////////////////////////////////


module CPU(
    input logic [31:0] IOBUS_IN,
    input logic RST, //reset
    input logic CLK, //clock
    output logic [31:0] IOBUS_OUT, IOBUS_ADDR, //Address
    output logic IOBUS_WR //Write
);


    logic PCWrite, memWE2, memRDEN1, memRDEN2, csr_WE, int_taken,br_eq, br_lt,regWrite, br_ltu;
    logic [3:0] alu_fun;
    logic [2:0] pcSource;
    
    logic alu_srcA;
    logic [1:0] alu_srcB,rf_wr_sel;  
    logic [31:0] ir, rs1, rs2,srcA,srcB, alu_result,wd, DOUT2, PC_PLUS_4,PC, RD, U_Type, I_Type, S_Type,J_Type, B_Type,jal,jalr, branch,mepc,mtvec;
    
    //Control Unit FSM (finite state machine)
   CU_FSM CU_FSM(.rst(RST),.ir_opcode(ir[6:0]),
                     .clk(CLK), .PcWrite(PCWrite), .regWrite(regWrite), .memWE2(memWE2),
                    .memRDEN1(memRDEN1), .memRDEN2(memRDEN2), .reset(reset));
    //Control Unit Decoder
    CU_DCDR CU_DCDR(.ir_opcode(ir[6:0]),.ir_bit30(ir[30]) ,.int_taken(int_taken),.ir_func(ir[14:12]),
                     .br_eq(br_eq), .br_lt(br_lt), .br_ltu(br_ltu), .alu_fun(alu_fun), .alu_srcA(alu_srcA),
                     .alu_srcB(alu_srcB), .pcSource(pcSource), .rf_wr_sel(rf_wr_sel)); 
    
    
    Branch_Cond_Gen BRANCH_COND_GEN(.rs1(rs1),.rs2(rs2),.br_eq(br_eq), .br_lt(br_lt), .br_ltu(br_ltu));
    
    // Arithmatic Logic Unit
    ALU ALU(.alu_fun(alu_fun), 
    .srcA(srcA), .srcB(srcB),
    .result(alu_result)); 
    
   
    //Register File
    RegFile REGFILE( .en(regWrite), 
    .adr1(ir[19:15]), .adr2(ir[24:20]), .wa(ir[11:7]),
    .wd(wd), .clk(CLK), .rs1(rs1), .rs2(rs2)); 
    
    
    Immediate_Generator IMM_GEN(.ir(ir[31:7]), .i_immed(I_Type), .s_immed(S_Type), .b_immed(B_Type), .u_immed(U_Type), .j_immed(J_Type)); 
    
    //Branch Address Generator
    Branch_Addr_Gen BRANCH_ADDR_GEN(.PC(PC), .J_Type(J_Type), .B_Type(B_Type), .I_Type(I_Type), .rs1(rs1), 
    .jal(jal),.jalr(jalr) ,.branch(branch)); 
    
    Memory MEM(.MEM_CLK(CLK),.MEM_RDEN1(memRDEN1), .MEM_RDEN2(memRDEN2),.MEM_WE2(memWE2),.MEM_ADDR1(PC[15:2]),.MEM_ADDR2(alu_result), // Data Memory Addr
   .MEM_DIN2(rs2),  
    .MEM_SIZE(ir[13:12]), .MEM_SIGN(ir[14]),.IO_IN(IOBUS_IN),.IO_WR(IOBUS_WR),.MEM_DOUT1(ir), .MEM_DOUT2(DOUT2));    // Data from IO);
    
   ProgRom PROG_ROM(.JALR(jalr), 
    .BRANCH(branch), 
    .JAL(jal), .MTVEC(mtvec), 
    .MEPC(mepc), .PC_SOURCE(pcSource),
    .PC_ADDRESS(PC),.RESET(reset), 
    .PC_PLUS_4(PC_PLUS_4), 
    .CLK(CLK), 
    .PC_WRITE(PCWrite)); 

assign IOBUS_ADDR = alu_result;
assign IOBUS_OUT = rs2; 


always_comb begin 
    //mux for REG_FILE
    case(rf_wr_sel)
        2'b00: wd = PC_PLUS_4; 
        2'b01: wd = RD; 
        2'b10: wd = DOUT2;
        2'b11: wd = alu_result; 
        default: wd = 0; 
    endcase 
    //alu case source a 
    case(alu_srcA) 
        1'b0: srcA = rs1;
        1'b1: srcA = U_Type;
        default: srcA = 0; 
    endcase 
    //alu case source b
    case(alu_srcB)
        2'b00: srcB = rs2; 
        2'b01: srcB = I_Type; 
        2'b10: srcB = S_Type; 
        2'b11: srcB = PC; 
        default: srcB = 0; 
    endcase 
    end 

endmodule