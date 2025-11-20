`timescale 1ns/1ps

module apb_slave(
    input pclk,
    input presetn,
    input [31:0] paddr,
    input psel,
    input penable,
    input [7:0] pwdata,
    input pwrite,
    output reg [7:0] prdata,
    output reg pready
);

    reg [7:0] mem [0:15];

    always @(posedge pclk or negedge presetn) 
    begin
        if(!presetn) 
        begin
            pready <= 0;
            prdata <= 8'h00;
        end 
        
        else 
        begin
            pready <= 0;
            if(psel && penable) 
            begin
                pready <= 1;
                if(pwrite)
                    mem[paddr] <= pwdata;
                else
                    prdata <= mem[paddr];
            end
        end
    end

endmodule


