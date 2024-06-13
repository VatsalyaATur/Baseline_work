module fifo #(
   parameter  PTR   = 4 ;    
   parameter  DATA  = 8 ;    
   parameter  DEPTH = 16 ;    
)(
   input   logic               wr_clk,
   input   logic               rd_clk,
   input   logic               wrst_n,
   input   logic               rrst_n,
   input   logic               wr_en,
   input   logic               rd_en,   
   input   logic  [DATA-1:0]   write_data,
   output  logic  [DATA-1:0]   read_data,
   output  logic               full,
   output  logic               empty
);

//logic   [DEPTH-1:0]    wr_ptr, rd_ptr;
logic   [PTR-1:0]    wr_ptr, rd_ptr;
logic   [DATA-1:0]   memory   [DEPTH-1:0];

assign empty = (wr_ptr == rd_ptr) ? 1 : 0;
//assign full  = ({!wr_ptr[DEPTH-1],wr_ptr[DEPTH-2:0]} == rd_ptr) ? 1 : 0;
assign full  = ({!wr_ptr[PTR-1],wr_ptr[PTR-2:0]} == rd_ptr) ? 1 : 0;


/*****************************Writing Domain***********************/
always_ff @(posedge wr_clk) begin
   if (~wrst_n) begin 
      wr_ptr <= 0; 
      rd_ptr <= 0; 
   end
   else 
      if (~full && wr_en ) begin 
        memory[wr_ptr] <= write_data;
        wr_ptr         <= wr_ptr +1;
      end
end    

/*****************************Reading Domain***********************/
always_ff @(posedge rd_clk) begin
   if (~rrst_n) begin 
      wr_ptr <= 0; 
      rd_ptr <= 0; 
   end
   else 
      if (~empty && rd_en ) begin 
        read_data      <= memory[rd_ptr];
        rd_ptr         <= rd_ptr +1;
      end
end    
endmodule                 