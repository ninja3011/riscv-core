// BY NINAD JANGLE
`timescale 1ns/1ns
`include "alu_riscv.v"
module alu_riscv_tb();

    reg [31:0] in1, in2;
    reg [2:0] func3;
    reg opequal;
    wire [31:0] out;
    

    integer i,j ;
    alu_riscv uut(in1,in2 ,func3,opequal,out);

    initial begin
        $monitor("in1 = %b, in2 = %b, Out = %b, func3 = %b, opequal = %b",in1,in2,out,func3,opequal);
        $dumpfile("alu_riscv.vcd");
        $dumpvars(0,alu_riscv_tb);
        in1 = 32'h6;
        in2 = 32'h5;
        func3 = 3'h0;
        for( j = 0; j<2 ;j++)
            begin
                for(i=0;i<8;i++)
                    begin
                        opequal = j;
                        func3= func3 + 3'h1;
                        #10;
                    end
            end
    end
endmodule
