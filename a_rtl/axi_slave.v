module axi_lite_slave
(
    input ACLK,
    input ARESETn,

    input [31:0] AWADDR,
    input AWVALID,
    output reg AWREADY,

    input [31:0] WDATA,
    input WVALID,
    output reg WREADY,

    output reg [1:0] BRESP,
    output reg BVALID,
    input BREADY,

    input [31:0] ARADDR,
    input ARVALID,
    output reg ARREADY,

    output reg [31:0] RDATA,
    output reg [1:0] RRESP,
    output reg RVALID,
    input RREADY
);

    reg [31:0] mem_reg;  

    always @(posedge ACLK) 
    begin
        if (!ARESETn) 
        begin
            AWREADY <= 0;
            WREADY  <= 0;
            BVALID  <= 0;
            ARREADY <= 0;
            RVALID  <= 0;
            mem_reg <= 32'h0;
        end
        
        else 
        begin

            if (AWVALID && !AWREADY)
                AWREADY <= 1;
            else
                AWREADY <= 0;

           
            if (WVALID && !WREADY) 
            begin
                WREADY <= 1;
                mem_reg <= WDATA; 
            end 
            
            
            if (WREADY && AWREADY) 
            begin
                BVALID <= 1;
                BRESP <= 2'b00;     
            end 
            
            else if (BREADY) 
            begin
                BVALID <= 0;
            end
            
            
            

            if (ARVALID && !ARREADY) 
            begin
                ARREADY <= 1;
                RDATA <= mem_reg;  
                RRESP <= 2'b00;
                RVALID <= 1;
            end 
            
            else begin
                ARREADY <= 0;
            end

            if (RVALID && RREADY)
                RVALID <= 0;

        end
    end
endmodule

