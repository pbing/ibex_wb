// SVA constraints

module fv_core2wb
  (core_if.monitor core,
   wb_if.monitor   wb);

   default clocking defclk @(posedge core.clk);
   endclocking

   default disable iff (!core.rst_n);

   // --------------------------------------------------------------------------
   // CORE
   // --------------------------------------------------------------------------

   ASM_core_addr_stable: assume property ((core.req && !core.gnt) |=> $stable(core.addr));

   ASM_core_we_stable: assume property ((core.req && !core.gnt) |=> $stable(core.we));

   ASM_core_be_stable: assume property ((core.req && !core.gnt && core.we) |=> $stable(core.be));

   ASM_core_wdata_stable: assume property ((core.req && !core.gnt && core.we) |=> $stable(core.wdata));

   ASM_core_req_stable: assume property ((core.req && !core.gnt) |=> core.req);

   // --------------------------------------------------------------------------
   // Wishbone
   // --------------------------------------------------------------------------

   AST_wb_adr_stable: assert property ((wb.cyc && wb.stb && wb.stall) |=> $stable(wb.adr));

   AST_wb_dat_o_stable: assert property ((wb.cyc && wb.stb && wb.stall && wb.we) |=> $stable(wb.dat_m));

   AST_wb_sel_stable: assert property ((wb.cyc && wb.stb && wb.stall && wb.we) |=> $stable(wb.sel));

   AST_wb_stb_stable: assert property ((wb.cyc && wb.stb && wb.stall) |=> wb.stb);

   AST_wb_we_stable: assert property ((wb.cyc && wb.stb && wb.stall) |=> $stable(wb.we));

   AST_wb_cyc_stable: assert property ((wb.cyc && wb.stb && wb.stall) |=> wb.cyc);

   AST_wb_no_stb: assert property (!wb.cyc |-> !wb.stb);

   ASM_wb_no_ack: assume property (!wb.cyc |-> !wb.ack);

   ASM_wb_no_err: assume property (!wb.cyc |-> !wb.err);

   ASM_wb_ack_no_err: assume property ((wb.cyc && wb.ack) |-> !wb.err);

   ASM_wb_err_no_ack: assume property ((wb.cyc && wb.err) |-> !wb.ack);

   // --------------------------------------------------------------------------
   // Covers
   // --------------------------------------------------------------------------

   COV_read: cover property (core.rvalid);

   COV_write: cover property (core.rvalid);

   COV_burst: cover property (core.rvalid[->5]);
endmodule

bind core2wb fv_core2wb fv(.*);
