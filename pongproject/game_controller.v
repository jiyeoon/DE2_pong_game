module game_controller(clk, reset, ready_button, right, left,
		sig_dead,  ready_sig, start_sig,  play_sig,  pause_sig, left_sig, right_sig);
		
	input clk, reset, ready_button;
	input right, left;
	input sig_dead;
	output reg ready_sig, start_sig, play_sig, pause_sig, left_sig, right_sig;
	
	parameter S0=0, S1=1, S2=2, S3=3, S4=4;
	reg [3:0] state;
	
	always @(posedge clk or posedge reset) begin
		if(reset) begin	//reset
			state <= S0;
			play_sig <= 0;
			pause_sig <= 0;
			end
		else begin
			ready_sig <= 0;
			start_sig <= 0;
			left_sig <= 0;
			right_sig <= 0;
			case(state)
			S0 : if(ready_button) begin //ready sig gen
					ready_sig <= 1;
					play_sig <= 0;
					pause_sig <= 0;
					state <= S1;
					end
			S1 : begin
					start_sig <= 1;
					play_sig <= 1;
					state <= S2;
				  end
			S2 : if (sig_dead) begin state <= S3; play_sig <= 0; end
				  else if (left) left_sig <= 1;
				  else if (right) right_sig <= 1;
			S3 : begin
					ready_sig <= 0;
					play_sig <= 0;
					start_sig <= 0;
					pause_sig <= 1;
					state <= S0;
					end
			default : state <= S0;
			endcase
		end //end else
	end //end always
endmodule
			