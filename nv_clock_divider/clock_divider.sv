/******************************************************************************
FILENAME     :  clock_divider.sv
DESCRIPTION  :  The module provides frequency divider of /2,/4,/8,/16
********************************************************************************/
module clock_divider(
    input   logic        clk,
    input   logic        rst,
    input   logic [1:0]  sel,
    output  logic        clk_out
);

 logic  [3:0]  count;

 always_ff @( posedge clk ) begin : increment count
    if (~rst) 
       count  <= 4'b0000;
    else 
      count   <= count + 1; 
    
 end

// always_comb begin
always @(*) begin
    case (sel) 
       2'h0 :  clk_out = count[0];     /// clk/2
       2'h1 :  clk_out = count[1];     /// clk/4
       2'h2 :  clk_out = count[2];     /// clk/8
       2'h3 :  clk_out = count[3];     /// clk/16
       default : clk_out = 'd0;   
    endcase    
end
endmodule