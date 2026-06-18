package FIFO_agent_pkg;
    import FIFO_monitor_pkg::*;
    import FIFO_driver_pkg::*;
    import FIFO_sequencer_pkg::*;
    import FIFO_config_obj_pkg::*;
    import FIFO_sequence_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_agent extends uvm_agent;
        `uvm_component_utils(FIFO_agent)

        FIFO_monitor mon;
        FIFO_driver drv;
        FIFO_sequencer sqr;
        FIFO_config_obj fifo_cfg;
        uvm_analysis_port #(FIFO_sequence_item) agt_ap;

        function new (string name = "FIFO_agent", uvm_component parent = null);
            super.new (name, parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            sqr = FIFO_sequencer::type_id::create("sqr", this);
            drv = FIFO_driver::type_id::create("drv", this);
            mon = FIFO_monitor::type_id::create("mon", this);
            agt_ap = new("agt_ap", this);
            if (! uvm_config_db #(FIFO_config_obj)::get(this, "", "CFG", fifo_cfg)) begin
                `uvm_fatal ("build_phase", "[Agent] - Can't get Virtual Interface from Test");
            end
        endfunction

        function void connect_phase (uvm_phase phase);
            super.connect_phase(phase);
            drv.fifo_vif = fifo_cfg.fifo_vif;
            mon.fifo_vif = fifo_cfg.fifo_vif;
            drv.seq_item_port.connect(sqr.seq_item_export);
            mon.mon_ap.connect(agt_ap);
        endfunction

    endclass
endpackage
