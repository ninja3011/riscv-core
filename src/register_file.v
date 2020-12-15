//Verilog Code of Register File

module register_file ( 
    read1,              //5 Bit address of register 1
    read2,              //5 Bit address of register 2
    writereg,           //5 Bit Write Register Address 
    writedata,          //32 Bit data for write Register
    regwrite,           //Control Signal for regwrite
    data1,              //Data 1 from register 1 
    data2,              //Data 2 from register 2
    clock               //Clock for register 
);

    input[4:0] read1, read2, writereg;         //The register numbers to read or write
    input[31:0] writedata;                     //32 Bit write data for selected register
    input regwrite,clock;                      
    output [31:0] data1, data2;

    reg [31:0] RF [31:0];                       //32 Registers each 32 bits long

    assign data1 = RF[read1];
    assign data2 = RF[read2];

    always@(posedge clock)
    begin
        if(regwrite)
            RF[writereg] <= writedata;
    end              
    
endmodule