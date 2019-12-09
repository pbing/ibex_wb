`default_nettype none

module ibex_soc
  (input  wire        xi,
   inout  wire        xo,
   input  wire        ext_rst_n,
   inout  wire [15:0] gpio,
   input  wire        tck,
   input  wire        trst_n,
   input  wire        tms,
   input  wire        tdi,
   output wire        tdo,
   input  wire        test_en,
   input  wire        vpd);

   wire        xi_buf;
   wire        clk;
   wire        ext_rst_n_i;
   wire [15:0] gpio_i, gpio_o, gpio_oe_n;
   wire        tck_i, trst_n_i, tms_i, tdi_i, tdo_o, tdo_oe_n;
   wire        test_en_i;
   wire        PC;

   dft_wrapper dft_wrapper
     (.clk,
      .ext_rst_n (ext_rst_n_i),
      .gpio_i,
      .gpio_o,
      .gpio_oe_n,
      .tck       (tck_i),
      .trst_n    (trst_n_i),
      .tms       (tms_i),
      .tdi       (tdi_i),
      .tdo       (tdo_o),
      .tdo_oe_n,
      .test_en   (test_en_i));

   IOCAXLIINNA00 pad_xi(.EA(xi), .X(xi_buf));
   IOCAXLBHFRA00 pad_xo(.EB(xo), .C(1'b0), .A(xi_buf), .X(clk));

   IOCB2EITSHMXA02 pad_ext_rst_n(.EA(ext_rst_n), .X(ext_rst_n_i), .PC);

   IOCB2EBTSN2LA02 pad_gpio0 (.EB(gpio[0]),  .X(gpio_i[0]),  .A(gpio_o[0]),  .C(gpio_oe_n[0]));
   IOCB2EBTSN2LA02 pad_gpio1 (.EB(gpio[1]),  .X(gpio_i[1]),  .A(gpio_o[1]),  .C(gpio_oe_n[1]));
   IOCB2EBTSN2LA02 pad_gpio2 (.EB(gpio[2]),  .X(gpio_i[2]),  .A(gpio_o[2]),  .C(gpio_oe_n[2]));
   IOCB2EBTSN2LA02 pad_gpio3 (.EB(gpio[3]),  .X(gpio_i[3]),  .A(gpio_o[3]),  .C(gpio_oe_n[3]));
   IOCB2EBTSN2LA02 pad_gpio4 (.EB(gpio[4]),  .X(gpio_i[4]),  .A(gpio_o[4]),  .C(gpio_oe_n[4]));
   IOCB2EBTSN2LA02 pad_gpio5 (.EB(gpio[5]),  .X(gpio_i[5]),  .A(gpio_o[5]),  .C(gpio_oe_n[5]));
   IOCB2EBTSN2LA02 pad_gpio6 (.EB(gpio[6]),  .X(gpio_i[6]),  .A(gpio_o[6]),  .C(gpio_oe_n[6]));
   IOCB2EBTSN2LA02 pad_gpio7 (.EB(gpio[7]),  .X(gpio_i[7]),  .A(gpio_o[7]),  .C(gpio_oe_n[7]));
   IOCB2EBTSN2LA02 pad_gpio8 (.EB(gpio[8]),  .X(gpio_i[8]),  .A(gpio_o[8]),  .C(gpio_oe_n[8]));
   IOCB2EBTSN2LA02 pad_gpio9 (.EB(gpio[9]),  .X(gpio_i[9]),  .A(gpio_o[9]),  .C(gpio_oe_n[9]));
   IOCB2EBTSN2LA02 pad_gpio10(.EB(gpio[10]), .X(gpio_i[10]), .A(gpio_o[10]), .C(gpio_oe_n[10]));
   IOCB2EBTSN2LA02 pad_gpio11(.EB(gpio[11]), .X(gpio_i[11]), .A(gpio_o[11]), .C(gpio_oe_n[11]));
   IOCB2EBTSN2LA02 pad_gpio12(.EB(gpio[12]), .X(gpio_i[12]), .A(gpio_o[12]), .C(gpio_oe_n[12]));
   IOCB2EBTSN2LA02 pad_gpio13(.EB(gpio[13]), .X(gpio_i[13]), .A(gpio_o[13]), .C(gpio_oe_n[13]));
   IOCB2EBTSN2LA02 pad_gpio14(.EB(gpio[14]), .X(gpio_i[14]), .A(gpio_o[14]), .C(gpio_oe_n[14]));
   IOCB2EBTSN2LA02 pad_gpio15(.EB(gpio[15]), .X(gpio_i[15]), .A(gpio_o[15]), .C(gpio_oe_n[15]));

   IOCB2EITSHMXA02 pad_tck(.EA(tck), .X(tck_i), .PC);
   IOCB2EITSHMXA02 pad_trst_n(.EA(trst_n), .X(trst_n_i), .PC);
   IOCB2EITSHMXA02 pad_tms(.EA(tms), .X(tms_i), .PC);
   IOCB2EITSHMXA02 pad_tdi(.EA(tdi), .X(tdi_i), .PC);
   IOCB2EOT3X6HA02 pad_tdo(.EX(tdo), .A(tdo_o), .C(tdo_oe_n));

   IOCB2EITSLMXA02 pad_test_en(.EA(test_en), .X(test_en_i), .PC);
   IOCB2EITPDMXA02 pad_vpd(.EA(vpd), .PC);
endmodule

`resetall
