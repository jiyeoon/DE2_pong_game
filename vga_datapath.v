module vga_datapath(clk, reset, pixel,
	ovga_clk, ovga_r, ovga_g, ovga_b,
	ovga_hs, ovga_vs, ovga_sync_n, ovga_blank_n, px, py);
	
	input clk, reset;
	input [23:0] pixel;
	output reg ovga_clk;
	output reg [7:0] ovga_r, ovga_g, ovga_b;
	output reg ovga_hs, ovga_vs;
	output reg ovga_sync_n;
	output reg ovga_blank_n;
	output [9:0] px, py;
	
	wire [7:0] in_r, in_g, in_b;
	wire [7:0] vga_r, vga_g, vga_b;
	wire hsync, vsync, vga_sync, vga_blank, vga_clk;
	
	reg clk25;
	
	always @(posedge clk or posedge reset) begin
		if(reset) clk25 <= 0;
		else clk25 <= ~clk25;
	end
	
	vga_sync u1 (clk25, reset, in_r, in_g, in_b, px, py, vga_r, vga_g, vga_b, hsync, vsync, vga_sync, vga_blank, vga_clk);
	
	always @* begin
		ovga_clk = vga_clk;
		{ovga_r, ovga_g, ovga_b} = {vga_r, vga_g, vga_b};
		{ovga_hs, ovga_vs} = {hsync, vsync};
		ovga_sync_n = vga_sync;
		ovga_blank_n = vga_blank;
	end
	
	//px 0~640
	//py 0~480
	assign in_r = pixel[23:16];
	assign in_g = pixel[15:8];
	assign in_b = pixel[7:0];
	
endmodule
