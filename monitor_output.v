module monitor_output(clk, reset, pixel, ovga_clk, ovga_r, ovga_g, ovga_b,
	ovga_hs, ovga_vs, ovga_sync_n, ovga_blank_n, px, py);
	
	input clk, reset;
	input [23:0] pixel;
	output ovga_clk;
	output [7:0] ovga_r, ovga_g, ovga_b;
	output ovga_hs, ovga_vs;
	output ovga_sync_n;
	output ovga_blank_n;
	output [9:0] px, py;
	
	vga_datapath u1 (clk, reset, pixel, ovga_clk, ovga_r, ovga_g, ovga_b,
		ovga_hs, ovga_vs, ovga_sync_n, ovga_blank_n, px, py);
		
endmodule
