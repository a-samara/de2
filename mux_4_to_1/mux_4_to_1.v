`timescale 1ns / 1ns // `timescale time_unit/time_precision

//SW[2:0] data inputs
//SW[9] select signal

//LEDR[0] output display

module mux_4_to_1(LEDR, SW);
    input [17:0] SW;
    output [9:0] LEDR;
    wire connection_AB, connection_CD;
    
    mux2to1 AB_mux(
        .x(SW[0]),
        .y(SW[1]),
        .s(SW[8]),
        .m(connection_AB)
        );
    mux2to1 CD_mux(
        .x(SW[2]),
        .y(SW[3]),
        .s(SW[8]),
        .m(connection_CD)
        );
    mux2to1 ABCD_mux(
        .x(connection_AB),
        .y(connection_CD),
        .s(SW[9]),
        .m(LEDR[0])
        );

endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s & y | ~s & x;
    // OR
    // assign m = s ? y : x;

endmodule
