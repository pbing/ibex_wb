`default_nettype none

module dft_wrapper
   (input  wire         clk,
    input  wire         ext_rst_n,
    input  wire  [15:0] gpio_i,
    output logic [15:0] gpio_o,
    output logic [15:0] gpio_oe_n,
    input  wire         tck,
    input  wire         trst_n,
    input  wire         tms,
    input  wire         tdi,
    output wire         tdo,
    output wire         tdo_oe_n,
    input  wire         test_en);

   localparam num_scan_chains = 6;

   logic [15:0]                core_gpio_o, core_gpio_oe_n;
   logic                       scan_mode;
   logic                       scan_en;
   logic [num_scan_chains-1:0] sdo;

   core
     #(.num_scan_chains(num_scan_chains))
   core
     (.gpio_o    (core_gpio_o),
      .gpio_oe_n (core_gpio_oe_n),
      .*);

   assign scan_mode = test_en;
   assign scan_en   = scan_mode & gpio_i[6];

   always_comb
     begin
        gpio_o    = core_gpio_o;
        gpio_oe_n = core_gpio_oe_n;

        /* scan enable */
        if (scan_mode) gpio_oe_n[6] = 1'b1;

        if (scan_en)
          for (int i=0; i < num_scan_chains; i++)
            begin
               /* scan chain inputs */
               gpio_oe_n[i] = 1'b1;

               /* scan chain outputs */
               gpio_o[8 + i]    = sdo[i];
               gpio_oe_n[8 + i] = 1'b0;
            end
     end
endmodule

`resetall
