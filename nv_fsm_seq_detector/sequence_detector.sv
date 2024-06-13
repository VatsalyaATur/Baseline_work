module sequence_detector(
   input   logic   clk,
   input   logic   rst_n,
   input   logic   seq_in,

   output  logic   seq_detected
);
    logic detect, detect_ff ;
    // - Parameters
    // ----------------------------------------

    typedef enum logic [6:0] 
    {S0 = 'b000_0000,
     S1 = 'b000_0001,
     S2 = 'b000_0010,
     S3 = 'b000_0101,
     S4 = 'b000_1011,
     S5 = 'b001_0110,
     S6 = 'b010_1100,
     S7 = 'b101_1000} state_seq;
     
state_seq state,next_state;

assign seq_detected = detect_ff | detect;

    always_ff @ (posedge clk or negedge rst_n)  begin
        if (~rst_n)  
             state        <= S0;   
            //  seq_detected <= 0;
             detect_ff    <= 0;
        else
            state        <= next_state;
            // seq_detected <= seq_detected | detect;
            detect_ff    <= detect;
    end

 always_comb begin
   // seq_detected = 0;
    detect = 0;
    case (state)
       S0 :
          if (seq_in) begin next_state = S1;  end
          else        begin next_state = S0;  end
       S1   :    
          if (seq_in) begin next_state = S1;  end
          else        begin next_state = S2;  end
       S2  : 
          if (seq_in) begin next_state = S3;  end
          else        begin next_state = S0;  end
       S3  : 
          if (seq_in) begin next_state = S4;  end
          else        begin next_state = S2;  end
       S4  : 
          if (seq_in) begin next_state = S1;  end
          else        begin next_state = S5;  end      
       S5  : 
          if (seq_in) begin next_state = S3;  end
          else        begin next_state = S6;  end  
       S6  : 
          if (seq_in) begin next_state = S1;  end
          else        begin next_state = S7;  end  
       S7  : 
          if (seq_in) begin next_state = S1; detect = 1 end
          else        begin next_state = S0;  end                                              

       default : next_state = IDLE;
    endcase  
 end        
 endmodule