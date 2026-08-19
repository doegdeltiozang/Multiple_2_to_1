

`timescale 1ns/1ps
`default_nettype none

// Parameterizable 2-to-1 combinational multiplexer.
module Mux #(
    parameter WIDTH = 32
)(
    input  wire [WIDTH-1:0] a,
    input  wire [WIDTH-1:0] b,
    input  wire             s,
    output wire [WIDTH-1:0] c
);

    assign c = s ? b : a;

endmodule

`default_nettype wire
