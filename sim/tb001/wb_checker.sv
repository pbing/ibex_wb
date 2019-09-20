/* Classic pipelined Wishbone B4 protocol checker */

module wb_checker (if_wb.monitor wb);

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
     #(.msg ("ADR must not be X or Z"))
   unkown_adr
     (.clk             (wb.clk),
      .reset_n         (~wb.rst),
      .antecedent_expr (wb.cyc && wb.stb),
      .consequent_expr (!$isunknown(wb.adr)));

   assert_implication
     #(.msg ("DAT_O from master must not be X or Z"))
   unkown_dat_m
     (.clk             (wb.clk),
      .reset_n         (~wb.rst),
      .antecedent_expr (wb.cyc && wb.stb),
      .consequent_expr (!$isunknown(wb.dat_m)));

   assert_implication
     #(.msg ("WE must not be X or Z"))
   unkown_we
     (.clk             (wb.clk),
      .reset_n         (~wb.rst),
      .antecedent_expr (wb.cyc && wb.stb),
      .consequent_expr (!$isunknown(wb.we)));

   assert_implication
     #(.msg ("DAT_I to master must not be X or Z"))
   unkown_dat_s
     (.clk             (wb.clk),
      .reset_n         (~wb.rst),
      .antecedent_expr (wb.cyc && !wb.we && wb.ack),
      .consequent_expr (!$isunknown(wb.dat_s)));

   /************************************************************************
    * There must be an ACK for each STB.
    ************************************************************************/
//  assert_next
//    #(.num_cks (1), // Is this true for classic pipeline mode?
//      .msg     ("Transaction is missing ACK after STB"))
//  transaction
//    (.clk         (wb.clk),
//     .reset_n     (~wb.rst),
//     .start_event (wb.cyc && wb.stb && !wb.stall),
//     .test_expr   (wb.ack));

   /************************************************************************
    * 3.3 BLOCK READ / WRITE Cycles
    ************************************************************************/
   assert_window
     #(.msg ("CYC must not change during STALL"))
   unchange_cyc
     (.clk         (wb.clk),
      .reset_n     (~wb.rst),
      .start_event (wb.cyc && wb.stb && wb.stall),
      .test_expr   (wb.cyc),
      .end_event   (!wb.stall));

   assert_window
     #(.msg ("STB must not change during STALL"))
   unchange_stb
     (.clk         (wb.clk),
      .reset_n     (~wb.rst),
      .start_event (wb.cyc && wb.stb && wb.stall),
      .test_expr   (wb.stb),
      .end_event   (!wb.stall));

   assert_win_unchange
     #(.width (wb.adr_width),
       .msg   ("ADR must not change during STALL"))
   unchange_adr
     (.clk         (wb.clk),
      .reset_n     (~wb.rst),
      .start_event (wb.cyc && wb.stb && wb.stall),
      .test_expr   (wb.adr),
      .end_event   (!wb.stall));

   assert_win_unchange
     #(.width (wb.dat_width),
       .msg   ("DAT_O must not change during STALL"))
   unchange_dat_m
     (.clk         (wb.clk),
      .reset_n     (~wb.rst),
      .start_event (wb.cyc && wb.stb && wb.we && wb.stall),
      .test_expr   (wb.dat_m),
      .end_event   (!wb.stall));
endmodule
