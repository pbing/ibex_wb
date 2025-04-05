module spram16384x32
  #(parameter MEMSIZE = 16384,
    localparam AWIDTH = $clog2(MEMSIZE))
   (input  logic              clock,
    input  logic              rden,
    input  logic              wren,
    input  logic [AWIDTH-1:0] address,
    input  logic [3:0]        byteena,
    input  logic [31:0]       data,
    output logic [31:0]       q);

   (* ram_style = "M10K" *) logic [3:0][7:0] ram[MEMSIZE]; 

   initial
     $readmemh("spram16384x32.vmem", ram);

   always @(posedge clock) begin
      if (wren) begin
            if (byteena[0]) ram[address][0] <= data[7:0];
            if (byteena[1]) ram[address][1] <= data[15:8];
            if (byteena[2]) ram[address][2] <= data[23:16];
            if (byteena[3]) ram[address][3] <= data[31:24];
      end
      if (rden)
        q <= ram[address];
   end
endmodule
