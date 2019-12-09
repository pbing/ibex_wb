/* Wishbone GPIO module
 *
 * FIXME
 * - only word access
 * - interrupts
 * - synchronize inputs
 */

`default_nettype none

module wb_gpio
  #(parameter width = 16)
   (input  wire  [width-1:0] gpio_i,
    output logic [width-1:0] gpio_o,
    output logic [width-1:0] gpio_oe,
    wb_if.slave              wb);

   logic valid;
   logic sel_data, sel_enable;

   always_comb
     begin
        sel_data   = wb.adr[11:2] == 10'h000;
        sel_enable = wb.adr[11:2] == 10'h001;
     end

   always @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       gpio_o <= '0;
     else
       if (valid && wb.we && sel_data)
         gpio_o <= wb.dat_i[width-1:0];

   always @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       gpio_oe <= '0;
     else
       if (valid && wb.we && sel_enable)
         gpio_oe <= wb.dat_i[width-1:0];


   assign wb.dat_o = ({width{sel_data}} & gpio_i) |
                     ({width{sel_enable}} & gpio_oe);

   /* Wishbone control */
   assign valid    = wb.cyc & wb.stb;
   assign wb.stall = 1'b0;
   assign wb.err   = 1'b0;

   always_ff @(posedge wb.clk or posedge wb.rst)
     if (wb.rst)
       wb.ack <= 1'b0;
     else
       wb.ack <= valid & ~wb.stall;
endmodule

`resetall
