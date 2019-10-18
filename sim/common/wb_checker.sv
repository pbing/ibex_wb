/* Classic pipelined Wishbone B4 protocol checker */

`default_nettype none

module wb_checker (wb_if.monitor wb);
   import wb_pkg::*;

   localparam MAXWAITS = 16; // max. cycles after which ACK or ERR must be valid

   /************************************************************************
    * Check if every bus signal is valid driven.
    ************************************************************************/
   assert_driven
     #(.bw  (1),
       .msg ("CYC must not be X or Z"))
   unkown_cyc
     (.clk     (wb.clk),
      .reset_n (~wb.rst),
      .exp     (wb.cyc));

   assert_implication
     #(.msg ("STB must not be X or Z"))
   unkown_stb
     (.clk             (wb.clk),
      .reset_n         (~wb.rst),
      .antecedent_expr (wb.cyc),
      .consequent_expr (!$isunknown(wb.stb)));

   assert_implication
     #(.msg ("STALL must not be X or Z"))
   unkown_stall
     (.clk             (wb.clk),
      .reset_n         (~wb.rst),
      .antecedent_expr (wb.cyc),
      .consequent_expr (!$isunknown(wb.stall)));

   assert_implication
     #(.msg ("ACK must not be X or Z"))
   unkown_ack
     (.clk             (wb.clk),
      .reset_n         (~wb.rst),
      .antecedent_expr (wb.cyc),
      .consequent_expr (!$isunknown(wb.ack)));

   assert_implication
     #(.msg ("ERR must not be X or Z"))
   unkown_err
     (.clk             (wb.clk),
      .reset_n         (~wb.rst),
      .antecedent_expr (wb.cyc),
      .consequent_expr (!$isunknown(wb.err)));

   assert_implication
     #(.msg ("ADR must not be X or Z"))
   unkown_adr
     (.clk             (wb.clk),
      .reset_n         (~wb.rst),
      .antecedent_expr (wb.cyc && wb.stb),
      .consequent_expr (!$isunknown(wb.adr)));

   assert_implication
     #(.msg ("SEL must not be X or Z"))
   unkown_sel
     (.clk             (wb.clk),
      .reset_n         (~wb.rst),
      .antecedent_expr (wb.cyc && wb.stb),
      .consequent_expr (!$isunknown(wb.sel)));

   assert_implication
     #(.msg ("WE must not be X or Z"))
   unkown_we
     (.clk             (wb.clk),
      .reset_n         (~wb.rst),
      .antecedent_expr (wb.cyc && wb.stb),
      .consequent_expr (!$isunknown(wb.we)));

   assert_implication
     #(.msg ("DAT_O from master must not be X or Z"))
   unkown_dat_m
     (.clk             (wb.clk),
      .reset_n         (~wb.rst),
      .antecedent_expr (wb.cyc && wb.we && wb.stb),
      .consequent_expr (!$isunknown(wb.dat_m)));

   assert_implication
     #(.msg ("DAT_I to master must not be X or Z"))
   unkown_dat_s
     (.clk             (wb.clk),
      .reset_n         (~wb.rst),
      .antecedent_expr (wb.cyc && !wb.we && (wb.ack || wb.err)),
      .consequent_expr (!$isunknown(wb.dat_s)));

   /************************************************************************
    * There must be exactly one ACK or ERR for each STB.
    ************************************************************************/
   assert_req_ack_unique
     #(.min_time       (1),
       .max_time       (MAXWAITS),
       .max_time_log_2 ($clog2(MAXWAITS)),
       .msg            ("ACK or ERR hast not been triggered after MAXWAITS cycles."))
   handshake
     (.clk     (wb.clk),
      .reset_n (~wb.rst),
      .req     (wb.cyc && wb.stb && !wb.stall),
      .ack     (wb.ack || wb.err));

   /************************************************************************
    * 3.3 BLOCK READ / WRITE Cycles
    ************************************************************************/
   assert_window
     #(.msg ("CYC must not change during STALL"))
   unchange_stall_cyc
     (.clk         (wb.clk),
      .reset_n     (~wb.rst),
      .start_event (wb.cyc && wb.stb && wb.stall),
      .test_expr   (wb.cyc),
      .end_event   (!wb.stall));

   assert_window
     #(.msg ("STB must not change during STALL"))
   unchange_stall_stb
     (.clk         (wb.clk),
      .reset_n     (~wb.rst),
      .start_event (wb.cyc && wb.stb && wb.stall),
      .test_expr   (wb.stb),
      .end_event   (!wb.stall));

   assert_win_unchange
     #(.width ($bits(adr_t)),
       .msg   ("ADR must not change during STALL"))
   unchange_stall_adr
     (.clk         (wb.clk),
      .reset_n     (~wb.rst),
      .start_event (wb.cyc && wb.stb && wb.stall),
      .test_expr   (wb.adr),
      .end_event   (!wb.stall));

   assert_win_unchange
     #(.width ($bits(dat_t)),
       .msg   ("Master DAT_O must not change during STALL"))
   unchange_stall_dat_m
     (.clk         (wb.clk),
      .reset_n     (~wb.rst),
      .start_event (wb.cyc && wb.stb && wb.we && wb.stall),
      .test_expr   (wb.dat_m),
      .end_event   (!wb.stall));

   assert_win_unchange
     #(.width ($bits(sel_t)),
       .msg   ("SEL must not change during STALL"))
   unchange_stall_sel
     (.clk         (wb.clk),
      .reset_n     (~wb.rst),
      .start_event (wb.cyc && wb.stb && wb.we && wb.stall),
      .test_expr   (wb.sel),
      .end_event   (!wb.stall));
endmodule

`resetall
