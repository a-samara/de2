`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display
module mux_7_to_1(MuxInput, MuxSelect, Out);
	input [6:0]MuxInput;
	input [2:0]MuxSelect;
	output reg Out;     // declare the output signal for the always block

	always @(*)  // declare always block with sensitivity*
	begin
		case(MuxSelect[2:0])  // start case statement
		3'b000: Out = MuxInput[0];  // handle MuxSelect equals 0
		3'b001: Out = MuxInput[1];  // handle MuxSelect equals 1
		3'b010: Out = MuxInput[2];  // handle case 2
		3'b011: Out = MuxInput[3];	// case 3
		3'b100: Out = MuxInput[4];	// case 4
		3'b101: Out = MuxInput[5];	// case 5
		3'b110: Out = MuxInput[6];    // case 6
		default: Out = 1'b0;        // default case (all other cases)
		endcase
	end
endmodule

module main(SW, LEDR);
	input [9:0]SW;
	output [9:0]LEDR;
	
	mux_7_to_1 mux(.MuxInput(SW[6:0]), .MuxSelect(SW[9:7]), .Out(LEDR[0]));
endmodule