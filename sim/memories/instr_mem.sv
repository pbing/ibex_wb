`default_nettype none

module instr_mem
  #(parameter size = 'h400)
  (input  logic        clk,
   input  logic        rst,
   input  logic        req,
   output logic        gnt,
   output logic        rvalid,
   input  logic [31:0] addr,
   output logic [31:0] rdata,
   output logic        err);

   localparam addr_width = $clog2(size) - 2;

   logic [31:0]               mem[size];
   logic [addr_width - 1 : 0] waddr;     // word address

   assign waddr = addr[addr_width + 1 : 2];

   always_ff @(posedge clk or posedge rst)
     if (rst)
       rvalid <= 1'b0;
     else
       rvalid <= req;

   assign gnt = req;

   always @(posedge clk)
     if (req)
       rdata <= 32'h00000013;

   assign err = 0;
endmodule

`resetall
