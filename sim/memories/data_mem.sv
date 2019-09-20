`default_nettype none

module data_mem
  #(parameter size = 'h400)
   (if_wb.slave wb);

   localparam addr_width = $clog2(size) - 2;

   logic [31:0]             mem[size];
   logic [addr_width - 1:0] waddr;     // word address
   logic                    valid;
   logic [31:0]             ram_q;

   assign waddr = wb.adr[addr_width + 1 : 2];

   always @(posedge wb.clk)
     if (valid && wb.we)
       mem[waddr] <= wb.dat_i;

   always_ff @(posedge wb.clk)
     if (valid)
       ram_q <= mem[waddr];

   /* Wishbone control */
   assign valid    = wb.cyc & wb.stb;
   assign wb.stall = 1'b0;
   assign wb.err   = 1'b0;

   always_ff @(posedge wb.clk)
     if (wb.rst)
       wb.ack <= 1'b0;
     else
       wb.ack <= valid & ~wb.stall;

   always_comb
     if (wb.cyc && wb.ack && !wb.we)
       wb.dat_o = ram_q;
     else
       wb.dat_o = 'x; // pessimistic simulation
endmodule

`resetall
