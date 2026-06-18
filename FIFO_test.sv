package FIFO_test_pkg;
    import FIFO_env_pkg::*;
    import FIFO_config_obj_pkg::*;
    import FIFO_sequence_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    class FIFO_test extends uvm_test;
        `uvm_component_utils(FIFO_test)

        FIFO_env env;
        virtual FIFO_if fifo_vif;
        FIFO_config_obj fifo_cfg;
        FIFO_reset_sequence rst_seq;
        FIFO_write_sequence wr_seq;
        FIFO_read_sequence rd_seq;
        FIFO_wr_rd_sequence wr_rd_seq;

    function new (string name = "FIFO_test", uvm_component parent = null);
            super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            env = FIFO_env::type_id::create("env", this);
            fifo_cfg = FIFO_config_obj::type_id::create("fifo_cfg", this);
            rst_seq = FIFO_reset_sequence::type_id::create("rst_seq", this);
            wr_seq = FIFO_write_sequence::type_id::create("wr_seq", this);
            rd_seq = FIFO_read_sequence::type_id::create("rd_seq", this);
            wr_rd_seq = FIFO_wr_rd_sequence::type_id::create("mx_seq", this);

            if (! uvm_config_db #(virtual FIFO_if)::get(this, "", "FIFO_IF", fifo_cfg.fifo_vif)) begin
                `uvm_fatal ("build_phase", "Test cant get Virtual Interface from Top");
            end

            uvm_config_db #(FIFO_config_obj)::set(this, "*", "CFG", fifo_cfg);
    endfunction

       task run_phase (uvm_phase phase);
            super.run_phase(phase);
            
            phase.raise_objection(this);

            `uvm_info("run_phase", "Welcome to the UVM env.", UVM_MEDIUM);

            //reset sequence
            `uvm_info("run_phase","reset asserted", UVM_LOW); 
            rst_seq.start(env.agt.sqr); 
            `uvm_info("run_phase","reset deasserted", UVM_LOW);

            //write sequence
            `uvm_info("run_phase","write stimulus generated started", UVM_LOW); 
            wr_seq.start(env.agt.sqr); 
            `uvm_info("run_phase","write stimulus generated ended", UVM_LOW);

             //read sequence
            `uvm_info("run_phase","read stimulus generated started", UVM_LOW); 
            rd_seq.start(env.agt.sqr); 
            `uvm_info("run_phase","read stimulus generated ended", UVM_LOW);

             //write_read sequence
            `uvm_info("run_phase","write_read stimulus generated started", UVM_LOW); 
            wr_rd_seq.start(env.agt.sqr); 
            `uvm_info("run_phase","wrire_read stimulus generated ended", UVM_LOW);

            phase.drop_objection(this);

        endtask
    endclass
endpackage
