package FIFO_coverage_pkg;
    import FIFO_sequence_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_coverage extends uvm_component;
        `uvm_component_utils(FIFO_coverage)
        uvm_analysis_export #(FIFO_sequence_item) cov_export;
        uvm_tlm_analysis_fifo #(FIFO_sequence_item) cov_fifo;
        FIFO_sequence_item seq_item_cov;

        covergroup cg;

            write_cp : coverpoint seq_item_cov.wr_en;
            read_cp : coverpoint seq_item_cov.rd_en;
            write_ack_cp : coverpoint seq_item_cov.wr_ack;
            overflow_cp : coverpoint seq_item_cov.overflow;
            full_cp : coverpoint seq_item_cov.full;
            empty_cp : coverpoint seq_item_cov.empty;
            almostfull_cp : coverpoint seq_item_cov.almostfull;
            almostempty_cp : coverpoint seq_item_cov.almostempty;
            underflow_cp : coverpoint seq_item_cov.underflow;

            wr_rd_ack_cross : cross write_cp, read_cp, write_ack_cp {
                illegal_bins wr_rd_inactive = binsof(write_cp) intersect {0} && binsof(read_cp) intersect {0} && binsof(write_ack_cp) intersect {1};
                illegal_bins wr_inactive_rd_active = binsof(write_cp) intersect {0} && binsof(read_cp) intersect {1} && binsof(write_ack_cp) intersect {1};
            }

            wr_rd_overflow_cross : cross write_cp, read_cp, overflow_cp {
                illegal_bins wr_rd_inactive = binsof(write_cp) intersect {0} && binsof(read_cp) intersect {0} && binsof(overflow_cp) intersect {1};
                illegal_bins wr_inactive_wr_active = binsof(write_cp) intersect {0} && binsof(read_cp) intersect {1} && binsof(overflow_cp) intersect {1};
            }

            wr_rd_full_cross : cross write_cp, read_cp, full_cp {
                illegal_bins wr_rd_active_full = binsof(write_cp) intersect {1} && binsof(read_cp) intersect {1} && binsof(full_cp) intersect {1};
                illegal_bins wr_inactive_rd_active_full = binsof(write_cp) intersect {0} && binsof(read_cp) intersect {1} && binsof(full_cp) intersect {1};
            }

            wr_rd_empty_cross : cross write_cp, read_cp, empty_cp;

            wr_rd_almostfull_cross : cross write_cp, read_cp, almostfull_cp;

            wr_rd_almostempty_cross : cross write_cp, read_cp, almostempty_cp;

            wr_rd_underflow_cross : cross write_cp, read_cp, underflow_cp {
                illegal_bins wr_rd_inactive = binsof(write_cp) intersect {0} && binsof(read_cp) intersect {0} && binsof(underflow_cp) intersect {1};
                illegal_bins wr_active_rd_inactive = binsof(write_cp) intersect {1} && binsof(read_cp) intersect {0} && binsof(underflow_cp) intersect {1};
            }
        endgroup

        function new (string name = "FIFO_coverage", uvm_component parent = null);
            super.new (name, parent);
            cg = new();
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase (phase);
            cov_export = new ("cov_export", this);
            cov_fifo = new ("cov_fifo", this);
        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase (phase);
            cov_export.connect(cov_fifo.analysis_export);
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase (phase);

            forever begin
                cov_fifo.get(seq_item_cov);
                cg.sample();
            end
        endtask

    endclass
endpackage