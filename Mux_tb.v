/**
 * Copyright 2026 Doeg Tiozang
 * Project: Nexvantis
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

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
