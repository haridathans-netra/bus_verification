
IVERILOG = iverilog
VVP = vvp




axi:
	$(IVERILOG) -o axi.vvp a_rtl/axi_slave.v d_tb/axi_tb.v
	$(VVP) axi.vvp


clean:
	rm -f *.vvp

