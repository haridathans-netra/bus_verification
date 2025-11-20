`timescale 1ns/1ps

module apb_slave_tb;

    reg pclk;
    reg presetn;
    reg [31:0] paddr;
    reg [7:0] pwdata;
    reg psel;
    reg penable;
    reg pwrite;
    wire [7:0] prdata;
    wire pready;

    apb_slave dut (
        .pclk(pclk),
        .presetn(presetn),
        .paddr(paddr),
        .pwdata(pwdata),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .prdata(prdata),
        .pready(pready)
    );

    initial pclk = 0;
    always #5 pclk = ~pclk;

    initial begin
        presetn = 0;
        psel = 0;
        penable = 0;
        pwrite = 0;
        paddr = 0;
        pwdata = 0;
        #20 presetn = 1;
    end

    task apb_write;
        input [31:0] addr;
        input [7:0] data;
    begin
        paddr = addr;
        pwdata = data;
        pwrite = 1;
        psel = 1;
        penable = 0;
        @(posedge pclk);
        penable = 1;
        @(posedge pclk);
        penable = 0;
        psel = 0;
        pwrite = 0;
        @(posedge pclk);
    end
    endtask
    
    reg [7:0] rdata;
    task apb_read;
        input [31:0] addr;
    begin
        paddr = addr;
        pwrite = 0;
        psel = 1;
        penable = 0;
        @(posedge pclk);
        penable = 1;
        @(posedge pclk);
        rdata = prdata;
        penable = 0;
        psel = 0;
        @(posedge pclk);
    end
    endtask

    initial begin
        $dumpfile("apb_slave.vcd");
        $dumpvars(0, apb_slave_tb);

        wait(presetn == 1);

        apb_write(32'h02, 8'hAA);
        
        @(posedge pclk);
        
         apb_write(32'h05, 8'h55);
        @(posedge pclk);
        
        
        apb_read(32'h05);
        $display("Read value = 0x%h (should be 0x55)", rdata);

        
        apb_read(32'h02);
        $display("Read value = 0x%h (should be 0xaa)", rdata);

        #20 $finish;
    end

endmodule
