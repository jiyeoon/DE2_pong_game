module pong_main(clk, reset, right, left, ready_button,
	px, py, pixel );
	
	input clk, reset;
	input [9:0] px, py;
	input right, left;
	input ready_button;
	output [23:0] pixel;
	
	reg [19:0] game_clk_counter; //50000000/60frame=833333
	reg game_clk;
	
	wire sig_dead;
	wire ready_sig, start_sig, play_sig, pause_sig, left_sig, right_sig;
	
	always @(posedge clk or posedge reset) begin
		if(reset) begin
			game_clk_counter<=20'h00000;
		end else begin
			game_clk<=0;
			if(game_clk_counter<20'h65B9A) begin
				game_clk_counter<=game_clk_counter+1;
			end else begin
				game_clk_counter<=20'h00000;
				game_clk<=1;
			end
		end
	end
	
	game_controller u1 (clk, reset, ready_button, right, left, sig_dead,
		ready_sig, start_sig, play_sig, pause_sig, left_sig, right_sig);
	
	game_datapath u2 (clk, game_clk, reset, px, py, ready_sig, start_sig,
		play_sig, pause_sig, left_sig, right_sig, pixel, sig_dead);
	
	
endmodule
