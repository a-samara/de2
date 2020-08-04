`timescale 1ns / 1ns // `timescale time_unit/time_precision


module mux_2_to_1(a, b, s, out);
	// 2-1 mux
	input a;
	input b;
	input s;
	
	output out;
	
	assign out = s & b | ~s & a;
endmodule

module full_adder(cin, a, b, sum, cout);
	input cin;
	input a;
	input b;
	
	output sum;
	output cout;
	
	wire AB;
	
	assign AB = a ^ b; // a XOR b
	
	mux_2_to_1 mux(.a(b), .b(cin), .s(AB), .out(cout)); // assigns cout to mux of b, cin, and wire AB
	
	assign sum = cin ^ AB; // cin XOR a XOR b

endmodule

module ripple_carry(A, B, cin, s, cout);
// logic of the ripple-carry adder
	input [3:0]A;
	input [3:0]B;
	input cin;
	output [3:0]s;
	output cout;
	wire [2:0]other_cin;
	
	full_adder adder_0(.cin(cin), .a(A[0]), .b(B[0]), .sum(s[0]), .cout(other_cin[0]));
	full_adder adder_1(.cin(other_cin[0]), .a(A[1]), .b(B[1]), .sum(s[1]), .cout(other_cin[1]));
	full_adder adder_2(.cin(other_cin[1]), .a(A[2]), .b(B[2]), .sum(s[2]), .cout(other_cin[2]));
	full_adder adder_3(.cin(other_cin[2]), .a(A[3]), .b(B[3]), .sum(s[3]), .cout(cout));
endmodule

module ripple_carry_display(SW, LEDR);
// display of the ripple-carry adder
	input [9:0]SW;
	output [9:0]LEDR;
	
	ripple_carry main_adder(.A(SW[7:4]), .B(SW[3:0]), .cin(SW[8]), .s(LEDR[3:0]), .cout(LEDR[9]));
endmodule
