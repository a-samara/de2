`timescale 1ns / 1ns // `timescale time_unit/time_precision
`include "hex_display.v"
`include "ripple_carry.v"
`include "mux_7_to_1.v"

module ALU(SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input [17:0] SW;
	output reg [7:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX1;
	output [6:0] HEX2;
	output [6:0] HEX3;
	output [6:0] HEX4;
	output [6:0] HEX5;
	
	wire [3:0] A_plus_B;
	wire [3:0] verilog_a_plus_b;
	wire [7:0] ALUout;
	wire [3:0] cout;
	wire [2:0] KEY;

	assign KEY = SW[17:15];
	hex_display hex_0 (SW[3:0], HEX0);
	hex_display hex_1 (4'b0000, HEX1);
	hex_display hex_2 (SW[7:4], HEX2);
	hex_display hex_3 (4'b0000, HEX3);
	hex_display hex_4 (LEDR[3:0], HEX4);
	hex_display hex_5 (cout, HEX5);
	
	ripple_carry ripple_a_plus_b(.A(SW[7:4]),.B(SW[3:0]), .cin(1'b0), .s(A_plus_B), .cout(cout));
	
	assign verilog_a_plus_b = {{SW[7:4]} + {SW[3:0]}};
	assign ALUout = SW;
	always@(*)
	begin
		case(KEY)
		// case 0: adder from Part II
		3'b000: LEDR = A_plus_B;
		// case 1: adder using Verilog
		3'b001: LEDR = verilog_a_plus_b;
		// case 2: A OR B on the left 4 bits, A XOR B on the right 4 bits
		3'b010: LEDR = {|{ALUout[7], ALUout[3]}, |{ALUout[6], ALUout[2]}, |{ALUout[5], ALUout[1]}, |{ALUout[4], ALUout[0]}, ^{ALUout[7], ALUout[3]}, ^{ALUout[6], ALUout[2]}, ^{ALUout[5], ALUout[1]}, ^{ALUout[4], ALUout[0]}};
		// case 3: |(A, B);
		3'b011: LEDR = |{ALUout};
		// case 4: &(A, B);
		3'b100: LEDR = &{ALUout};
		// case 5: A and B displayed in output;
		3'b101: LEDR = ALUout;
		default:
			LEDR = 8'b00000000;
		endcase
	end

endmodule
