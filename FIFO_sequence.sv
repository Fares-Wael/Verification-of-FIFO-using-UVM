package FIFO_sequence_pkg;
    import FIFO_sequence_item_pkg::*;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

// RESET SEQUENCE 

class FIFO_reset_sequence extends uvm_sequence #(FIFO_sequence_item);
    `uvm_object_utils(FIFO_reset_sequence)

     FIFO_sequence_item reset_seq_item;

    function new (string name = "FIFO_reset_sequence");
         super.new (name);
    endfunction

    task body;
        reset_seq_item = FIFO_sequence_item::type_id::create("reset_seq_item");
        start_item(reset_seq_item);
            reset_seq_item.rst_n = 0;
            reset_seq_item.rd_en = 0; 
            reset_seq_item.wr_en = 0; 
            reset_seq_item.data_in = 16'hFFFF; 
        finish_item(reset_seq_item);
    endtask
endclass

// WRITE SEQUENCE 

class FIFO_write_sequence extends uvm_sequence #(FIFO_sequence_item);
    `uvm_object_utils(FIFO_write_sequence)

     FIFO_sequence_item wr_seq_item;

    function new (string name = "FIFO_write_sequence");
         super.new (name);
    endfunction

    task body;
        repeat (2000) begin
                wr_seq_item = FIFO_sequence_item::type_id::create("wr_seq_item");
                wr_seq_item.c_write.constraint_mode(0);
                wr_seq_item.c_read.constraint_mode(0);
                wr_seq_item.read_only.constraint_mode(0);
                wr_seq_item.c_reset.constraint_mode(1);
                wr_seq_item.write_only.constraint_mode(1);
        start_item(wr_seq_item);
        assert(wr_seq_item.randomize());
        finish_item(wr_seq_item);
        end
    endtask
endclass

// READ SEQUENCE

class FIFO_read_sequence extends uvm_sequence #(FIFO_sequence_item);
    `uvm_object_utils(FIFO_read_sequence)

     FIFO_sequence_item rd_seq_item;

    function new (string name = "FIFO_read_sequence");
         super.new (name);
    endfunction

    task body;
        repeat (2000) begin
                rd_seq_item = FIFO_sequence_item::type_id::create("rd_seq_item");
                rd_seq_item.c_write.constraint_mode(0);
                rd_seq_item.c_read.constraint_mode(0);
                rd_seq_item.c_reset.constraint_mode(0);
                rd_seq_item.write_only.constraint_mode(0);
                rd_seq_item.read_only.constraint_mode(1);
        start_item(rd_seq_item);
        assert(rd_seq_item.randomize());
        finish_item(rd_seq_item);
        end
    endtask
endclass

// WRITE - READ SEQUENCE

    class FIFO_wr_rd_sequence extends uvm_sequence #(FIFO_sequence_item);
        `uvm_object_utils(FIFO_wr_rd_sequence)

        FIFO_sequence_item wr_rd_seq_item;

        function new (string name = "FIFO_wr_rd_sequence");
            super.new (name);
        endfunction

        task body;
            repeat (2000) begin
                wr_rd_seq_item = FIFO_sequence_item::type_id::create("wr_rd_seq_item");
                wr_rd_seq_item.write_only.constraint_mode(0);
                wr_rd_seq_item.read_only.constraint_mode(0);
                wr_rd_seq_item.c_reset.constraint_mode(1);
                wr_rd_seq_item.c_write.constraint_mode(1);
                wr_rd_seq_item.c_read.constraint_mode(1);
                start_item(wr_rd_seq_item);
                assert(wr_rd_seq_item.randomize());
                finish_item(wr_rd_seq_item);
            end
        endtask
    endclass
endpackage