module sram_fd#(
   parameter  ADDR  = 4 ;    
   parameter  DATA  = 8 ;    
//    parameter  DEPTH = 16 ;   
)(
   input   logic               clk,
//    input   logic               wr_clk,
//   input   logic               rd_clk,
   input   logic               wrst_n,
   input   logic               rrst_n,
   input   logic               wr_en,
   input   logic               op_en,
   input   logic               chip_en,
   input   logic  [ADDR-1:0]   address,
   input   logic  [DATA-1:0]   write_data,
   output  logic  [DATA-1:0]   read_data
);

logic [DATA-1:0] memory [ADDR-1:0];



/*****************************RW Domain***********************/
always_ff @(posedge clk) begin
   if (~wrst_n) begin 
      memory  <= 'd0;
   end
   else 
      if ( chip_en && wr_en ) begin 
        memory[address] <= write_data;
      end
    //   else 
    //     if ( chip_en && op_en ) begin 
    //       read_data      <= memory[address];
    //     end
end    

/*****************************Reading Domain***********************/
always_ff @(posedge clk) begin
   if (~rrst_n) begin 
      memory  <= 'd0;
   end
   else 
      if ( chip_en && op_en ) begin 
        read_data      <= memory[address];
      end
end    
endmodule