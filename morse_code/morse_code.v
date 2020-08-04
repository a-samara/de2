module new_rate(RateDivider, Enable, freq_selector, clk);
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

module shifter(CB, ENABLE, D, OUT, CLOCK_50);
    input ENABLE, CB, CLOCK_50;
    input[11:0] D;
    output OUT;
    reg[11:0] s;

    always @(posedge CLOCK_50)
    begin
        if (CB == 1'b0)
            s = D;
        else if (ENABLE == 1'b1)
            s = s  << 1;
    end
    assign out = s[11];
endmodule

module morse_code(LEDR, SW, CLOCK_50, KEY);
	input CLOCK_50;
	input [0:0] KEY;
	input [17:15] SW;
	output [0:0] LEDR; // LED
	reg [11:0] signal;
	wire [2:0] letter;
	wire [1:0] freq_selector = 2'b10;
	wire [27:0] RateDivider;
	wire Enable;
	reg out;
	
	assign letter = SW;
	always @(*)
	begin
		if (KEY == 1'b0)
		begin
			case (letter)
			3'b000: // A
				signal <= 12'b101110000000;
			3'b001: // B
				signal <= 12'b111010101000;
			3'b010: // C
				signal <= 12'b111010111010;
			3'b011: // D
				signal <= 12'b111010100000;
			3'b100: // E
				signal <= 12'b100000000000;
			3'b101: // F
				signal <= 12'b101011101000;
			3'b110: // G
				signal <= 12'b111011101000;
			3'b111: // H
				signal <= 12'b101010100000;
			endcase
		end
//	else if (Enable == 1'b1)
//		begin
//			out = signal[11];
//			signal <= signal << 1'b1;
//		end
	end
   shifter s(.ENABLE(Enable),
				 .CB(KEY[0]),
				 .D(signal),
				 .OUT(LEDR[0]),
				 .CLOCK_50(CLOCK_50));

	new_rate half_clk(RateDivider, Enable, freq_selector, CLOCK_50);
endmodule