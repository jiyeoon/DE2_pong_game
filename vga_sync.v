module vga_sync(CLK25, reset, in_r, in_g, in_b,
	px, py, vga_r, vga_g, vga_b, hsync, vsync, vga_sync, vga_blank, vga_clk);
	
	input CLK25;
	input reset;
	input [9:0] in_r, in_g, in_b;
	output reg [9:0] px, py; //pixel x, pixel y location
	output [9:0] vga_r, vga_b, vga_g;
	output reg hsync, vsync;
	output vga_sync, vga_blank;
	output vga_clk;
	
	reg video_on;
	reg [9:0] hcount, vcount;
	
	//horizontal sync
	//hcount : mod800 counter
	always @(posedge CLK25 or posedge reset) begin
		if(reset) hcount<=0;
		else begin
			if(hcount==799) hcount<=0;
			else hcount <= hcount+1;
		end
	end
	
	always @(posedge CLK25) begin
		if((hcount>=659)&&(hcount<=755)) hsync <= 0;
		else hsync <= 1;
	end
	
	//vertical sync
	//vcount : mod525 counter
	always @(posedge CLK25 or posedge reset) begin
		if(reset)
			vcount <= 0;
		else if (hcount==799) begin
			if(vcount == 524) vcount <= 0;
			else vcount <= vcount +1;
		end
	end
	
	always @(posedge CLK25) begin
		if((vcount >= 493)&&(vcount <= 494)) vsync <= 0;
		else vsync <= 1;
	end
	
	//video_on_h
	always @(posedge CLK25) begin
		video_on <= (hcount <=639) && (vcount <= 479);
		px <= hcount;
		py <= vcount;
	end
	
	assign vga_clk = ~CLK25;
	assign vga_blank = hsync & vsync;
	assign vga_sync = 1'b0;
	
	assign vga_r = video_on ? in_r : 10'h000;
	assign vga_g = video_on ? in_g : 10'h000;
	assign vga_b = video_on ? in_b : 10'h000;
	
endmodule
	
	
	
	