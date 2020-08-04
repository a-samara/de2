`timescale 1ns / 1ns // `timescale time_unit/time_precision

module mux2to1(out, x, y, s);
	input x, y, s;
	output out;
	
	assign out = (x & ~s) | (y & s);
endmodule

module flipflop(Q, reset_n, D, clk);
	input D;
	input reset_n;
	input clk;
	output reg Q;
	always@(posedge clk)   	// Triggered every time clock rises
	begin
		if(reset_n == 1'b0) 	/*when reset_n is 0... (this is tested onevery rising clock edge)*/
			Q <= 1'b0;           	// ... q is set to 0 (note these assignments use 
		else				// when reset_n is not 0...
			Q <= D;           	// ...value of d passes through to output q
	end
endmodule

module shifterbit(out, load_val, in, shift, load_n, clk, reset_n);
	input load_val;
	input in;
	input shift;
	input load_n;
	input clk; 
	input reset_n;
	
	output out;
	wire outmux;
	wire loadmux;
	
	mux2to1 out_in_shift(
		.out(outmux),
		.x(out),
		.y(in),
		.s(shift)
	);
	
	mux2to1 load_val_mux_load_n(
		.out(loadmux),
		.x(load_val),
		.y(outmux),
		.s(load_n)
	);
	
	flipflop F0(
	.Q(out),
	.reset_n(reset_n),
	.D(loadmux),
	.clk(clk)
	);
endmodule

module shifter(SW, LEDR);
	input [17:0] SW;
	output [7:0] LEDR;
	
	wire [7:0] q;
	wire [7:0] load_val;
	wire reset_n;
	wire load_n;
	wire shift_r;
	wire ASR;
	wire clk;
	wire outmux;
	
	assign load_val = SW[7:0];
	assign reset_n = SW[9];
	assign clk = SW[14];
	assign ASR = SW[15];
	assign shift_r = SW[16];
	assign load_n = SW[17];
	assign LEDR[7:0] = q[7:0];

	mux2to1 ASR_mux(
	.out(outmux),
	.x(1'b0),
	.y(q[7]),
	.s(ASR)
	);
	
	shifterbit shifter_7(
	.out(q[7]), 
	.load_val(load_val[7]), 
	.in(outmux), 
	.shift(shift_r), 
	.load_n(load_n),
	.clk(clk), 
	.reset_n(reset_n)
	);

	shifterbit shifter_6(
	.out(q[6]), 
	.load_val(load_val[6]), 
	.in(q[7]), 
	.shift(shift_r), 
	.load_n(load_n),
	.clk(clk), 
	.reset_n(reset_n)
	);
	
	shifterbit shifter_5(
	.out(q[5]), 
	.load_val(load_val[5]), 
	.in(q[6]), 
	.shift(shift_r), 
	.load_n(load_n),
	.clk(clk), 
	.reset_n(reset_n)
	);	
	
	shifterbit shifter_4(
	.out(q[4]), 
	.load_val(load_val[4]), 
	.in(q[5]), 
	.shift(shift_r), 
	.load_n(load_n),
	.clk(clk), 
	.reset_n(reset_n)
	);
	
	shifterbit shifter_3(
	.out(q[3]), 
	.load_val(load_val[3]), 
	.in(q[4]), 
	.shift(shift_r), 
	.load_n(load_n),
	.clk(clk), 
	.reset_n(reset_n)
	);
	
	shifterbit shifter_2(
	.out(q[2]), 
	.load_val(load_val[2]), 
	.in(q[3]), 
	.shift(shift_r), 
	.load_n(load_n),
	.clk(clk), 
	.reset_n(reset_n)
	);
	
	shifterbit shifter_1(
	.out(q[1]), 
	.load_val(load_val[1]), 
	.in(q[2]), 
	.shift(shift_r), 
	.load_n(load_n),
	.clk(clk), 
	.reset_n(reset_n)
	);
	
	shifterbit shifter_0(
	.out(q[0]), 
	.load_val(load_val[0]), 
	.in(q[1]), 
	.shift(shift_r), 
	.load_n(load_n),
	.clk(clk), 
	.reset_n(reset_n)
	);
	
endmodule