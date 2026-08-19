

`timescale 1ns/1ps
`default_nettype none

// Self-checking directed testbench for the parameterized 2-to-1 multiplexer.
module Mux_tb;

    reg  [31:0] a;
    reg  [31:0] b;
    reg         s;
    wire [31:0] c;

    integer error_count;

    Mux dut (
        .a (a),
        .b (b),
        .s (s),
        .c (c)
    );

`ifdef DUMP_VCD
    initial begin
        $dumpfile("mux.vcd");
        $dumpvars(0, Mux_tb);
    end
`endif

    // Compare the combinational output after a short propagation delay.
    task check_output;
        input [31:0] expected;
        begin
            #1;
            if (c !== expected) begin
                $display("FAIL: s=%b actual=%h expected=%h", s, c, expected);
                error_count = error_count + 1;
            end
            else begin
                $display("PASS: s=%b output=%h", s, c);
            end
        end
    endtask

    initial begin
        error_count = 0;
        a = 32'h12345678;
        b = 32'hA5A5A5A5;

        s = 1'b0;
        check_output(a);

        s = 1'b1;
        check_output(b);

        // Return to input a to verify both selection transitions.
        s = 1'b0;
        check_output(a);

        if (error_count == 0) begin
            $display("TEST MUX PASSED");
            $finish;
        end
        else begin
            $fatal(1, "TEST MUX FAILED: %0d error(s)", error_count);
        end
    end

endmodule

`default_nettype wire
