/******************************************************************************
FILENAME     :  apb_clk_counter.sv
DESCRIPTION  :  The module provides frequency divider of /2,/4,/8,/16
********************************************************************************/

/*
I propose to design completely parameterized APB clock counter module. The module takes APB interface, 
provides registers to start and stop the clock counter, reads the status of the operation, reads the number of clocks
acquired from start to stop. The module provides error and overflow checks as well.
*/


module apb_clk_counter (
    input   logic            p_clk,
    input   logic            prst_n,

    input   logic   [31:0]   p_addr,
    input   logic            p_sel,
    input   logic            p_en,
    input   logic            p_write,            
    input   logic   [31:0]   p_wrdata,

    output  logic            p_ready,
    output  logic   [31:0]   p_rdata,
    output  logic            p_slverr

);

///logic           error;  error = ((read_addr == wr_addr) || (read_data == wr_data)) ? 0:1) rest info i will later
logic           start;
logic           stop;
logic           overflow;
logic           status;      /// 0: Read 1: Write
logic   [31:0]  clk_count;   ///// clk counter in between start to stop


assign p_slverr = 1'b0;
assign p_ready  = 1'b1;


always_ff @(posedge p_clk) begin 
        if ( clk_count == 32'h FFFF_FFFF ) begin 
             clk_count <= 0;
             overflow  <= 1'b1;
        end     
        else  begin
           clk_count <= clk_count +1;
           overflow  <= 1'b0;
        end
end            
        
always_ff @(posedge p_clk) begin
   clk_count  <= (start) ? clk_count + 1 : (stop) ? clk_count : 32'd0;

   if (~prst_n) begin
     // error      <= 0;
      status     <= 1'b1;
   end
   else begin 
    //  if (p_sel && p_en && p_write && p_ready) begin // Write operation
      if (p_sel && p_en ) begin  
         if ( p_write ) begin  /// Write operation
            status     <= 1'b1;
            case (p_addr)
               32'h0   : start <= p_wrdata[0];
               32'h4   : stop  <= p_wrdata[0];
               default : 
            endcase
         end
         else begin     /// Read operations
            status     <= 1'b0;
            case (p_addr)
               32'h8   : p_rdata  <= status;
               32'h8   : p_rdata  <= status;
               32'h8   : p_rdata  <= status;
               default :   
            endcase
         end
      end      
   end
end
endmodule    
