module pongproject(clk, reset, 
	ready_button, 
	right, left,
	ovga_clk, ovga_r, ovga_g, ovga_b,
	ovga_hs, ovga_vs, ovga_sync_n, ovga_blank_n);
	
	input clk, reset;
	input ready_button;
	input right, left;
	output ovga_clk;
	output [7:0] ovga_r, ovga_g, ovga_b;
	output ovga_hs, ovga_vs;
	output ovga_sync_n;
	output ovga_blank_n;
	
	wire [9:0] px, py;
	wire [23:0] pixel;
	
	
	monitor_output u2 (clk, reset, pixel, ovga_clk, ovga_r, ovga_g,
		ovga_b, ovga_hs, ovga_vs, ovga_sync_n, ovga_blank_n, px, py);
	
	pong_main u1(clk, reset, right, left, ready_button, px, py, pixel);
	
	
endmodule