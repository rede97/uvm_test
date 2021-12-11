`include "uvm_pkg.sv"

module e1_tb;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    parameter CYCLE = 20;
    logic rst_h;
    logic q, q_l, d, clk, rst_i;

    initial begin
        #0 rst_h = 1;
        #50 rst_h = 0;
    end

    initial begin
        clk = 0;
        forever
            # (CYCLE/2) clk = ~clk;
    end

    initial begin
        repeat(40) @(posedge clk);
        `uvm_info("UVM", "d flip-flop", UVM_DEBUG);

        $finish;
    end

    assign rst_i = rst_h;
    not n1(q_l, q);
    example exam1(clk, rst_i, d, q);

endmodule
