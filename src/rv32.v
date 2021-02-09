///////////////////////////////////////////
// Module rv32.v   
//                                         
// Info:  Verilog Code for rv32I
//        For R type instructions
//  
///////////////////////////////////////////


`include "register_file.v"                  //32 General Purpose Registers
`include "compare.v"                        //Compare module for single bit output for branch instructions                             
`include "alu.v"                            //32 Bit ALU
`include "mini_decoder.v"                   //Mini Decoder for decoding R Type registers

module rv32
(
    input                    clk,  

    output  [31:0]      mem_addr,           //Address Bus
    output wire [31:0] mem_wdata,           //Data to be writtien
    input  wire [31:0] mem_rdata,           //Input lines for both data and instr
    
    input wire         mem_rbusy,           //asserted if memeory is busy reading value 
    input wire         mem_wbusy            //asserted if memory is busy writing values
);
    parameter ADDR_WIDTH = 32;              //width of the the address bus

    //The Program Counter 
    reg [ADDR_WIDTH - 1:0] PC;

    //The Latched Instruction
    reg [31:0] instr;

    //Program Counter in Normal Operation
    wire [ADDR_WIDTH - 1:0] PCplus4 = PC + 4;

    ///////////////////////////////////////////////////////////////////
    // Instruction Decoding
    ////////////////////////////////////////////////////////////////////
    
    wire          writeBackEn;          //Asserted when writing to a reg
    wire [4:0] writeBackRegId;          //The register to be written back
    wire [4:0]         RegId1;          //Register output 1
    wire [4:0]         RegId2;          //Register output 2
    

    wire [2:0] 	        func3;          // operation done by the ALU, tests, load/store mode
    wire 	         funcQual;          // 'qualifier' used by some operations (+/-, logic/arith shifts)
    wire [31:0] 	      imm;          // immediate value decoded from the instruction

    mini_decoder decoder
    (
        .instr(instr),                   //The instruction to be deocded 
   
        .writeBackEn(writeBackEn),      //Asserted when writing to a reg
        .writeBackRegId(writeBackRegId),//The register to be written back
        .inRegId1(RegId1),              //Register output 1
        .inRegId2(RegId2),              //Register output 2

        .func3(func3),                  //Operation done by ALU
        .funcQual(funcQual),            //Operation Qualifier
   
        .imm(imm)                       //Immediate Value decoded from the instruction
    );

    ///////////////////////////////////////////////////////////////////
    // Register File
    ////////////////////////////////////////////////////////////////////
    
    wire writeBack; // asserted if register write back is done.
    reg  [31:0] writeBackData;
    wire [31:0] regOut1;
    wire [31:0] regOut2;

    register_file regs
    (     
        .clock(clk),                       //Clock for register 
        .read1(RegId1),                    //5 Bit address of register 1
        .read2(RegId2),                    //5 Bit address of register 2
        .writereg(writeBackRegId),         //5 Bit Write Register Address 
        .writedata(writeBackData),         //32 Bit data for write Register
        .inEn(writeBack),                  //Control Signal for regwrite
        .data1(regOut1),                   //Data 1 from register 1 
        .data2(regOut2)                    //Data 2 from register 2
    );

endmodule 