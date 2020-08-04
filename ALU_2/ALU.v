`timescale 1ns / 1ns // `timescale time_unit/time_precision
`include "hex_display.v"
`include "ripple_carry.v"
`include "mux_7_to_1.v"

module ALU(SW, LEDR, HEX0, HEX4, HEX5);
	input [17:0] SW;
	reg [7:0] q;
	reg [7:0] ALUout;
	output [7:0] LEDR;
	output [6:0] HEX0;
	output [6:0] HEX4;
	output [6:0] HEX5;
	wire [3:0] A_plus_B;
	wire [3:0] verilog_a_plus_b;
	wire clk;
	wire reset_n;
	wire cout;
	ripple_carry ripple_a_plus_b(.A(SW[3:0]),.B(q[3:0]), .cin(0), .s(A_plus_B), .cout(cout));
	
	assign verilog_a_plus_b = {{SW[3:0]} + {q[3:0]}};
	assign reset_n = SW[9];
	
	always@(*)
	begin
		case(SW[17:15])
		// case 0: adder from Part II
		3'b000: ALUout = A_plus_B;
		// case 1: adder using Verilog
		3'b001: ALUout = verilog_a_plus_b;
		// case 2: A OR B on the left 4 bits, A XOR B on the right 4 bits
		3'b010: ALUout = {|{SW[3:0], q[3:0]}, ^{SW[3:0], q[3:0]}};
		// case 3: |(A, B);
		3'b011: ALUout = |{SW[3:0], q[3:0]};
		// case 4: &(A, B);
		3'b100: ALUout = &{SW[3:0], q[3:0]};
		// case 5: Left shift B by A bits using Verilog shift operator <<
		3'b101: ALUout = q[3:0] << SW[3:0];
		// case 6: Right shift B by A bits using Verilog shift operator >>
		3'b110: ALUout = q[3:0] >> SW[3:0];
		// case 7: A x B using Verilog operator *
		3'b111: ALUout = SW[3:0] * q[3:0];
		default:
			ALUout[7:0] = 8'b00000000;
		endcase
	end

	always@(posedge SW[14])
	begin
		if (reset_n == 1'b0)
			q[7:0] <= 8'b00000000;
		else
			q[7:0] <= ALUout[7:0];
	end
	
	assign LEDR[7:0] = q[7:0];
	hex_display hex_0 (SW[3:0], HEX0);
	hex_display hex_4 (q[3:0], HEX4);
	hex_display hex_5 (q[7:4], HEX5);

	
endmodule
