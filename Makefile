
IVERILOG = iverilog
VVP = vvp



axi:
	$(IVERILOG) -o axi.vvp a_rtl/axi_slave.v d_tb/axi_tb.v
	$(VVP) axi.vvp
	
apb:
	$(IVERILOG) -o apb.vvp a_rtl/apb_slave.v d_tb/apb_tb.v
	$(VVP) apb.vvp

clean:
	rm -f *.vvp

