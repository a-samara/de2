`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display

module seg_7_decoder(SW, HEX0);
    input [3:0] SW;
    output [6:0] HEX0;
    wire connection_0, connection_1, connection_2, connection_3, connection_4, connection_5, connection_6;

    HEX0_module mod0(
	.c(SW), 
	.o(connection_0)
   	);
    HEX1_module mod1(
	.c(SW), 
	.o(connection_1)
   	);
    HEX2_module mod2(
	.c(SW), 
	.o(connection_2)
   	);
    HEX3_module mod3(
	.c(SW), 
	.o(connection_3)
   	);
    HEX4_module mod4(
	.c(SW), 
	.o(connection_4)
   	);
    HEX5_module mod5(
	.c(SW), 
	.o(connection_5)
  	);
    HEX6_module mod6(
	.c(SW), 
	.o(connection_6)
  	);
    assign HEX0[0] = connection_0; 
    assign HEX0[1] = connection_1; 
    assign HEX0[2] = connection_2; 
    assign HEX0[3] = connection_3; 
    assign HEX0[4] = connection_4; 
    assign HEX0[5] = connection_5; 
    assign HEX0[6] = connection_6; 
endmodule

module HEX0_module(c, o);
    input [3:0] c;
    output o;
    assign o = ~c[3] & ~c[2] & ~c[1] & c[0] | ~c[3] & c[2] & ~c[1] & ~c[0] | c[3] & c[2] & ~c[1] & c[0] | c[3] & ~c[2] & c[1] & c[0];
endmodule

module HEX1_module(c, o);
    input [3:0] c;
    output o;
    assign o = c[3] & c[2] & ~c[0] | ~c[3] & c[2] & ~c[1] & c[0] | c[3] & c[1] & c[0] | c[2] & c[1] & ~c[0]; 
endmodule

module HEX2_module(c, o);
    input [3:0] c;
    output o;
    assign o = c[3] & c[2] & ~c[0] | c[3] & c[2] & c[1] | ~c[3] & ~c[2] & c[1] & ~c[0]; 
endmodule

module HEX3_module(c, o);
    input [3:0] c;
    output o;
    assign o = ~c[3] & ~c[2] & ~c[1] & c[0] | ~c[3] & c[2] & ~c[1] & ~c[0] | c[3] & ~c[2] & c[1] & ~c[0] |c[2] & c[1] & c[0]; 
endmodule

module HEX4_module(c, o);
    input [3:0] c;
    output o;
    assign o = ~c[3] & c[2] & ~c[1] | ~c[2] & ~c[1] & c[0] | ~c[3] & c[0];
endmodule

module HEX5_module(c, o);
    input [3:0] c;
    output o;
    assign o = ~c[3] & ~c[2] & c[0] | ~c[3] & ~c[2] & c[1] | ~c[3] & c[1] & c[0] | c[3] & c[2] & ~c[1] & c[0];
endmodule

module HEX6_module(c, o);
    input [3:0] c;
    output o;
    assign o = ~c[3] & ~c[2] & ~c[1] | ~c[3] & c[2] & c[1] & c[0] | c[3] & c[2] & ~c[1] & ~c[0];
endmodule


