module counter8bit(SW, KEY, HEX0, HEX1); 
	input [17:16] SW; 
	input [0:0] KEY;
	output [6:0] HEX0;
	output [6:0] HEX1; 
	wire [7:0] u;
	wire w0, w1, w2, w3, w4, w5, w6; 
	
	assign w0 = SW[17] & u[0];
	assign w1 = w0 & u[1];
	assign w2 = w1 & u[2];
	assign w3 = w2 & u[3];
	assign w4 = w3 & u[4];
	assign w5 = w4 & u[5];
	assign w6 = w5 & u[6];
	
	tflipflop tff0(.CLK(KEY), 
						.T(SW[17]), 
						.CB(SW[16]), 
						.Q(u[0]));
	tflipflop tff1(.CLK(KEY), 
						.T(w0), 
						.CB(SW[16]), 
						.Q(u[1]));
	tflipflop tff2(.CLK(KEY), 
						.T(w1), 
						.CB(SW[16]), 
						.Q(u[2]));
	tflipflop tff3(.CLK(KEY), 
						.T(w2), 
						.CB(SW[16]), 
						.Q(u[3]));
	tflipflop tff4(.CLK(KEY), 
						.T(w3), 
						.CB(SW[16]), 
						.Q(u[4]));
	tflipflop tff5(.CLK(KEY), 
						.T(w4), 
						.CB(SW[16]), 
						.Q(u[5]));
	tflipflop tff6(.CLK(KEY), 
						.T(w5), 
						.CB(SW[16]), 
						.Q(u[6]));
	tflipflop tff7(.CLK(KEY), 
						.T(w6), 
						.CB(SW[16]), 
						.Q(u[7]));
	
	hex_display hex0(.IN(u[3:0]), .OUT(HEX0));
	hex_display hex1(.IN(u[7:4]), .OUT(HEX1));
endmodule 

module tflipflop(CLK, T, CB, Q);
	input CLK, T, CB;
	output reg Q;
	
	always @(posedge CLK, negedge CB)
	begin
		if(CB == 1'b0)
			Q <= 1'b0;
		else
			Q <= Q ^ T;
		//else if(T)
			//Q <= ~Q;
	end
endmodule 
	
module hex_display(IN, OUT);
    input [3:0] IN;
	 output reg [6:0] OUT;
	 
	 always @(*)
	 begin
		case(IN[3:0])
			4'b0000: OUT = 7'b1000000;
			4'b0001: OUT = 7'b1111001;
			4'b0010: OUT = 7'b0100100;
			4'b0011: OUT = 7'b0110000;
			4'b0100: OUT = 7'b0011001;
			4'b0101: OUT = 7'b0010010;
			4'b0110: OUT = 7'b0000010;
			4'b0111: OUT = 7'b1111000;
			4'b1000: OUT = 7'b0000000;
			4'b1001: OUT = 7'b0011000;
			4'b1010: OUT = 7'b0001000;
			4'b1011: OUT = 7'b0000011;
			4'b1100: OUT = 7'b1000110;
			4'b1101: OUT = 7'b0100001;
			4'b1110: OUT = 7'b0000110;
			4'b1111: OUT = 7'b0001110;
			
			default: OUT = 7'b0111111;
		endcase

	end
endmodule
	