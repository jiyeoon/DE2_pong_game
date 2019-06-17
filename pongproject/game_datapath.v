module game_datapath(clk, game_clk, reset, px, py,
	ready_sig, start_sig, play_sig, pause_sig, left_sig, right_sig,
	pixel, sig_dead);
	
	input clk, game_clk, reset;
	input [9:0] px, py;
	input ready_sig, start_sig, play_sig, pause_sig, left_sig, right_sig;
	output reg [23:0] pixel;
	output reg sig_dead;
	
	reg [7:0] player_bar_size_x, player_bar_size_y;
	reg [9:0] player_bar_x, player_bar_y; //size 60*10 pixel
	reg [7:0] player_bar_vx;
	
	reg [7:0] ai_bar_size_x, ai_bar_size_y;
	reg [9:0] ai_bar_x, ai_bar_y; //60*60 pixel
	reg [7:0] ai_bar_vx;
	
	reg [7:0] ball_size;
	reg [9:0] ball_x, ball_y; //size 10*10 pixel
	reg [7:0] ball_vx, ball_vy; 
	reg ball_vxd, ball_vyd;	//0 left up, 1 right up
	
	
	//screen
	always @(posedge clk or posedge reset) begin
		if(reset) pixel <= 24'h000000;
		else if (pause_sig) pixel <= 24'h000000;
		else begin // else 1
			pixel <= 24'h000000;
			//px, py in player_bar sketch
			if ((px>=player_bar_x)&&(px<player_bar_x+player_bar_size_x)&&(py>=player_bar_y)&&(py<player_bar_y+player_bar_size_y)) begin
				if (!pause_sig && play_sig) pixel <= 24'h00ffff; //on game - coloring
			/// ai bar sketch
			end else if ((px>=ai_bar_x)&&(px<=ai_bar_x+ai_bar_size_x)&&(py>=ai_bar_y)&&(py<=ai_bar_y+ai_bar_size_y)) begin
				if (!pause_sig && play_sig) pixel <= 24'hf000ff;
			/// ball sketch
			end else if ((px>=ball_x)&&(px<ball_x+ball_size)&&(py>=ball_y)&&(py<ball_y+ball_size)) begin // else 2
				if((px-ball_x >= 3)&&(px-ball_x<7)&&(py-ball_y==0||py-ball_y==9)) begin
					if(!pause_sig && play_sig) pixel <= 24'hfff0ff; 
				end else if((px-ball_x>=1) && (px-ball_x<9) &&(py-ball_y>=1 && py-ball_y<3 || py-ball_y>=7 && py-ball_y<9)) begin
					if(!pause_sig && play_sig) pixel <= 24'hfff0ff;
				end else if(py-ball_y>=3 && py-ball_y<7) begin
					if(!pause_sig && play_sig) pixel<=24'hfff0ff;
				end else begin //else 3
						pixel<=24'h000000;
				end // end else 3
			end // end else 2
		end // end else 1
	end // end always

	
	always @(posedge clk or posedge reset) begin	//player_bar
		if(reset) begin
			player_bar_x<=290;
			player_bar_y<=450;
			player_bar_vx<=0;
			player_bar_size_x<=0;
			player_bar_size_y<=0;
		end else begin //else begin1
			if(ready_sig) begin
				player_bar_x<=290;
				player_bar_y<=450;
				player_bar_vx<=0;
				player_bar_size_x<=60;
				player_bar_size_y<=10;
			end else if(start_sig) begin
				player_bar_vx <= 10;
			end else begin //else begin2
				if(play_sig && !pause_sig) begin
					if(game_clk) begin	//posedge game-clk
						if(left_sig) begin //move to left
							if(player_bar_x-player_bar_vx <= 0 || player_bar_x-player_bar_vx > 640) player_bar_x <= 0;
							else player_bar_x<=player_bar_x-player_bar_vx;
						end
						else if(right_sig) begin //move to right
							if(player_bar_x+player_bar_vx+player_bar_size_x>=640||player_bar_x+player_bar_size_x+player_bar_vx < 0) 
								player_bar_x <= 640-player_bar_size_x;
							else player_bar_x <= player_bar_x+player_bar_vx;
						end //end right_sig
					end // end game_clk
				end //end play_sig & !pause_sig
			end //end else begin 2
		end //end else begin 1
	end //end always
	

	always @(posedge clk or posedge reset) begin //ai_bar
		if(reset) begin
			ai_bar_x <= 290;
			ai_bar_y <= 30;
			ai_bar_vx <= 0;
			ai_bar_size_x <= 0;
			ai_bar_size_y <= 0;
		end else begin //1
			if(ready_sig) begin
				ai_bar_x <= 290;
				ai_bar_y <= 30;
				ai_bar_vx <= 0;
				ai_bar_size_x <= 60;
				ai_bar_size_y <= 10;
			end else if (start_sig) begin
				ai_bar_vx <= 20;
				ai_bar_x <= 290;
			end else begin //2
				if(play_sig && !pause_sig)	begin
					if(ball_x+ball_size < ai_bar_x) ai_bar_x <= ball_x - 30;
					else if (ball_x > ai_bar_x+ai_bar_size_x) ai_bar_x <= ball_x + 30;
					else if(ai_bar_x-ai_bar_vx<=0 || ai_bar_x-ai_bar_vx>640) ai_bar_x <= 0;
					else if(ai_bar_x+ai_bar_vx+ai_bar_size_x>=640) ai_bar_x <= 640-ai_bar_size_x;
				end 
			end //end else begin 2
		end // end else gegin 1
	end // end always
	
	
	always @(posedge clk or posedge reset) begin //ball
		if(reset) begin //define ball x, y and ball size
			ball_y <= 430;
			ball_vy <= 0;
			ball_vyd <= 0;
			ball_x <= 315;
			ball_vx <= 0;
			ball_vxd <= 0;
			ball_size <= 0;
		end else begin //1
			sig_dead <= 0;
			if(ready_sig) begin // game ready
				ball_y <= 430;
				ball_vy <= 0;
				ball_x <= 315;
				ball_vx <= 0;
				ball_size <= 10;
			end else if(start_sig) begin // game_start;
				ball_vy <= 1; 
				ball_vyd <= 1; // y direction 1 : down
				ball_vx <=1; 
				ball_vxd <= 1; // x dierction 1 : right
			end else begin //2
				if(play_sig&&!pause_sig) begin //during game
					if(game_clk) begin
						if(ball_vyd) begin // vy direction : 1 => down
							if(ball_y+ball_vy+ball_size>=480) begin ball_vyd <= ~ball_vyd; sig_dead <= 1; end 	//if fin
							else if ( ball_x + ball_size > player_bar_x
									&& ball_x < player_bar_x + player_bar_size_x
									&& ball_y + ball_vy + ball_size >= player_bar_y
									&& ball_y + ball_vy <= player_bar_y + player_bar_size_y ) ball_vyd <= ~ball_vyd;
							else ball_y <= ball_y+ball_vy;
						end //end ball_vyd 
						else begin //ball_vyd =0 => up
							if(ball_y-ball_vy <= 0) begin sig_dead <= 1; ball_vyd <= ~ball_vyd; end
							else if (ball_x+ball_size > ai_bar_x
									&& ball_x < ai_bar_x + ai_bar_size_x
									&& ball_y - ball_vy <= ai_bar_y + ai_bar_size_y
									&& ball_y+ball_size-ball_vy > ai_bar_y) ball_vyd <= ~ball_vyd;
							else ball_y <= ball_y-ball_vy;
						end // end ball_vyd =0
						if(ball_vxd) begin // vxd = 1 => right
								if(ball_x>=479) ball_vxd <= ~ball_vxd;
								else ball_x <= ball_x + ball_vx;
						end // end vxd=1
						else begin //vxd = 0 => left
								if(ball_x<=1) ball_vxd <= ~ball_vxd;
								else ball_x <= ball_x - ball_vx;
						end // end vxc = 0
						end // end game_clk
					end // end play ~
				end // end else begin 2
			end // end else begin 1
		end // end always
		
endmodule	