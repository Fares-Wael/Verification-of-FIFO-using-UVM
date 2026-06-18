package FIFO_sequence_item_pkg;
    import uvm_pkg::*;

    `include "uvm_macros.svh"

    class FIFO_sequence_item extends uvm_sequence_item;
        `uvm_object_utils(FIFO_sequence_item)

        parameter FIFO_WIDTH = 16;
        parameter FIFO_DEPTH = 8;

        rand logic [FIFO_WIDTH-1:0] data_in;
        rand logic rst_n, wr_en, rd_en;
        logic [FIFO_WIDTH-1:0] data_out;
        logic wr_ack, overflow;
        logic full, empty, almostfull, almostempty, underflow;
        int RD_EN_DIST, WR_EN_DIST;

        constraint c_reset {rst_n dist {1 := 98, 0 := 2};}
        constraint c_write {wr_en dist {1 := WR_EN_DIST, 0 := (100 - WR_EN_DIST)};}
        constraint c_read {rd_en dist {1 := RD_EN_DIST, 0 := (100 - RD_EN_DIST)};}
        constraint write_only { rd_en == 0 ; wr_en == 1 ;} 
        constraint read_only { rd_en == 1 ; wr_en == 0 ;} 

        function new (string name = "FIFO_sequence_item", int rd_en_Dist = 30, wr_en_Dist = 70);
            super.new (name);
            RD_EN_DIST = rd_en_Dist;
            WR_EN_DIST = wr_en_Dist;
        endfunction

        function string convert2string();
            return $sformatf ("%s rst_n = %0b , wr_en = %0b , rd_en = %0b , data_in = %0b , data_out = %0b, wr_ack = %0b, overflow = %0b,
                              full = %0b, empty = %0b, almostfull = %0b, almostempty = %0b, underflow = %0b", super.convert2string(), rst_n,
                              wr_en, rd_en, data_in, data_out, wr_ack, overflow, full, empty, almostfull, almostempty, underflow);
        endfunction

        function string convert2string_stimulus();
            return $sformatf ("%s rst_n = %0b , wr_en = %0b , rd_en = %0b , data_in = %0b", super.convert2string(), rst_n, wr_en, rd_en, data_in);
        endfunction
    endclass
endpackage