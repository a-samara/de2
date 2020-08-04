module new_rate(Enable, RateDivider, freq_selector, clk);
	input [1:0] freq_selector;
	input clk;
	output reg [27:0] RateDivider;
	output Enable;
	assign Enable = (RateDivider == 0) ? 1 : 0;

	always @(posedge clk)
	begin
	// find which freq is needed
	// 00: normal clock speed, 50m cycles/second
	// 01: 1 cycle/second
	// 10: 1 cycle/2 seconds
	// 11: 1 cycle/4 seconds
		case (freq_selector)
			2'b00:
			begin
				if(RateDivider == 28'd0) 
					RateDivider = 28'd1;
			end
			2'b01:
			begin
				if(RateDivider == 28'd0) 
					RateDivider = 28'd49999999;
			end
			2'b10: 
			begin
				if(RateDivider == 28'd0) 
					RateDivider = 28'd99999999;
			end
			2'b11: 
			begin
				if(RateDivider == 28'd0) 
					RateDivider = 28'd199999999;
			end
		endcase
		RateDivider = RateDivider - 28'd1;
	end
	
	
endmodule

module reg_counter(DisplayCounter, SW, HEX0, CLOCK_50);
	input CLOCK_50;
	input [17:15] SW; // 17 = clear_b, 16/15 = freq_selector
	output [6:0] HEX0;
	output reg [3:0] DisplayCounter;
	// max RateDivider should be is log2(200 000 000) = 28 bits rounded up (for .25Hz)
	wire [27:0] RateDivider;
	wire Enable;
	// Enable is the clock for changing hex display
	// RateDivider is the counter that counts from max to 0
	
	new_rate clk(.Enable(Enable), .RateDivider(RateDivider), .freq_selector(SW[16:15]), .clk(CLOCK_50));
	
	always @(posedge CLOCK_50, negedge SW[17])
	begin
		if (SW[17] == 1'b0) // reset display when clear is 0 or when display is maxed
			DisplayCounter <= 0;
		else if (DisplayCounter == 4'b1111)
			DisplayCounter <= 0;
		else if (Enable == 1'b1)
			DisplayCounter <= DisplayCounter + 1'b1; // increment when Enable is 1
	end
	
	hex_display hex(.IN(DisplayCounter), .OUT(HEX0));
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
