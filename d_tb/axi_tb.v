`timescale 1ns/1ps

module tb_axi;

    reg ACLK;
    reg ARESETn;

    
    reg [31:0] AWADDR;
    reg AWVALID;
    wire AWREADY;

    reg [31:0] WDATA;
    reg WVALID;
    wire WREADY;

    wire [1:0] BRESP;
    wire BVALID;
    reg  BREADY;

   
    reg [31:0] ARADDR;
    reg ARVALID;
    wire ARREADY;

    wire [31:0] RDATA;
    wire [1:0]  RRESP;
    wire RVALID;
    reg  RREADY;

    axi_lite_slave dut(
        .ACLK(ACLK), .ARESETn(ARESETn),
        .AWADDR(AWADDR), .AWVALID(AWVALID), .AWREADY(AWREADY),
        .WDATA(WDATA), .WVALID(WVALID), .WREADY(WREADY),
        .BRESP(BRESP), .BVALID(BVALID), .BREADY(BREADY),
        .ARADDR(ARADDR), .ARVALID(ARVALID), .ARREADY(ARREADY),
        .RDATA(RDATA), .RRESP(RRESP), .RVALID(RVALID), .RREADY(RREADY)
    );

    always #5 ACLK = ~ACLK;

    initial begin
        $dumpfile("axi.vcd");
        $dumpvars(0, tb_axi);

        ACLK = 0;
        ARESETn = 0;
        BREADY = 0;
        RREADY = 0;
        AWVALID = 0;
        WVALID = 0;
        ARVALID = 0;

        #20 ARESETn = 1;

        
        #10;
        AWADDR = 32'h00000000;
        AWVALID = 1;

        WDATA = 32'hAABBCCDD;
        WVALID = 1;

        #10;
        AWVALID = 0;
        WVALID = 0;

        BREADY = 1;
        #10 BREADY = 0;

        
        #20;
        ARADDR = 32'h00000000;
        ARVALID = 1;

        RREADY = 1;

        #10;

        if (RVALID)
            $display("AXI READ DATA = %h", RDATA);

        ARVALID = 0;
        RREADY = 0;

        #30;
        $finish;
    end

endmodule
