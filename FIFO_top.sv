import FIFO_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module FIFO_top ();
    bit clk;

    initial begin
        clk = 0;
        forever begin
            #1 clk = ~ clk;
        end
    end

    FIFO_if fifo_if (clk);

    FIFO dut (fifo_if);

    bind FIFO FIFO_sva fifo_sva (fifo_if);

    initial begin
        uvm_config_db #(virtual FIFO_if)::set(null, "uvm_test_top", "FIFO_IF", fifo_if);
        run_test("FIFO_test");
    end
endmodule 
