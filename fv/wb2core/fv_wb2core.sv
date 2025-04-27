// SVA constraints

module fv_wb2core
  (core_if.monitor core,
   wb_if.monitor   wb);

   default clocking defclk @(posedge wb.clk);
   endclocking

   //default disable iff (wb.rst);

   // --------------------------------------------------------------------------
   // CORE
   // --------------------------------------------------------------------------

   AST_core_addr_stable: assert property ((core.req && !core.gnt) |=> $stable(core.addr));

   AST_core_we_stable: assert property ((core.req && !core.gnt) |=> $stable(core.we));

   AST_core_be_stable: assert property ((core.req && !core.gnt && core.we) |=> $stable(core.be));

   AST_core_wdata_stable: assert property ((core.req && !core.gnt && core.we) |=> $stable(core.wdata));

   AST_core_req_stable: assert property ((core.req && !core.gnt) |=> core.req);

   // --------------------------------------------------------------------------
   // Wishbone
   // --------------------------------------------------------------------------

   ASM_wb_adr_stable: assume property ((wb.cyc && wb.stb && wb.stall) |=> $stable(wb.adr));

   ASM_wb_dat_o_stable: assume property ((wb.cyc && wb.stb && wb.stall && wb.we) |=> $stable(wb.dat_m));

   ASM_wb_sel_stable: assume property ((wb.cyc && wb.stb && wb.stall && wb.we) |=> $stable(wb.sel));

   ASM_wb_stb_stable: assume property ((wb.cyc && wb.stb && wb.stall) |=> wb.stb);

   ASM_wb_we_stable: assume property ((wb.cyc && wb.stb && wb.stall) |=> $stable(wb.we));

   ASM_wb_cyc_stable: assume property ((wb.cyc && wb.stb && wb.stall) |=> wb.cyc);

   ASM_wb_no_stb: assume property (!wb.cyc |-> !wb.stb);

   AST_wb_no_ack: assert property (!wb.cyc |-> !wb.ack);

   AST_wb_no_err: assert property (!wb.cyc |-> !wb.err);

   AST_wb_ack_no_err: assert property ((wb.cyc && wb.ack) |-> !wb.err);

   AST_wb_err_no_ack: assert property ((wb.cyc && wb.err) |-> !wb.ack);

   // --------------------------------------------------------------------------
   // Covers
   // --------------------------------------------------------------------------

   COV_read: cover property (wb.cyc && wb.ack);

   COV_write: cover property (wb.cyc && wb.ack);

   COV_burst: cover property ((wb.cyc && wb.ack)[->5]);
endmodule

bind wb2core fv_wb2core fv(.*);
