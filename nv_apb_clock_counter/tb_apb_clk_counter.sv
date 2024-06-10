

module apb_clk_counter_tb;
//////////////////////////// AS PER EDA PLAYGROUND
    // Signals
    logic           p_clk = 0;
    logic           prst_n = 1;
    logic [31:0]    p_addr = 0;
    logic           p_sel = 0;
    logic           p_en = 0;
    logic           p_write = 0;
    logic [31:0]    p_wrdata = 0;

    logic           p_ready;
    logic [31:0]    p_rdata;
    logic           p_slverr;

    // Instantiate the module under test
    apb_clk_counter dut (
        .p_clk   (p_clk    ),
        .prst_n  (prst_n   ),
        .p_addr  (p_addr   ),
        .p_sel   (p_sel    ),
        .p_en    (p_en     ),
        .p_write (p_write  ),
        .p_wrdata(p_wrdata ),
        .p_ready (p_ready  ),
        .p_rdata (p_rdata  ),
        .p_slverr(p_slverr )
    );

    // Clock generation
    always #5 p_clk = ~p_clk;

    initial begin
        // Reset assertion
        prst_n = 0;
        #50; 
        prst_n = 1;
        #50; 

        // Open VCD file
        $dumpfile("waveform.vcd");
        $dumpvars(0, apb_clk_counter_tb);        

        // Test scenarios

        // TT1. Basic Write and Read Test
        p_sel = 1;
        p_en = 1;
        p_write = 1;
        p_addr = 32'h0;
        p_wrdata = 32'h1;
        #100;
        p_addr = 32'h4;
        p_wrdata = 32'h100; 
        #100;
        p_write = 0;
        p_addr = 32'h8;
        #100;

        // TT2. Overflow 
        p_sel = 1;
        p_en = 1;
        p_write = 1;
        p_addr = 32'h0;
        p_wrdata = 32'hFFFFFFFF;  // START TO MAX
        #100;
        p_addr = 32'h4;
        p_wrdata = 32'h1; 
        #100;
        p_write = 0;
        p_addr = 32'h8;
        #100;


        // TT3. Multiple Write and Read 
        p_sel = 1;
        p_en = 1;
        p_write = 1;
        p_addr = 32'h0;
        p_wrdata = 32'h1; 
        #100;
        p_addr = 32'h4;
        p_wrdata = 32'h100; 
        #100;
        p_write = 0;
        p_addr = 32'h8;
        #100;

        p_sel = 1;
        p_en = 1;
        p_write = 1;
        p_addr = 32'h0;
        p_wrdata = 32'h10;
        #100;
        p_addr = 32'h4;
        p_wrdata = 32'h200; 
        #100;
        p_write = 0;
        p_addr = 32'h8;
        #100;

        // TT4. Read Only 
        p_sel = 1;
        p_en = 1;
        p_write = 0;
        p_addr = 32'h0;
        p_wrdata = 32'h1; 
        #100;
        p_addr = 32'h4;
        p_wrdata = 32'h100; 
        #100;
        p_write = 0;
        p_addr = 32'h8;
        #100;

        // TT5. Toggle Start/Stop 
        p_sel = 1;
        p_en = 1;
        p_write = 1;
        p_addr = 32'h0;
        p_wrdata = 32'h1; 
        #100;
        p_write = 0;
        p_addr = 32'h8;
        #100;

        p_write = 1;
        p_addr = 32'h4;
        p_wrdata = 32'h100; 
        #100;
        p_write = 0;
        p_addr = 32'h8;
        #100;

        $finish; // End simulation after tests are done
    end

endmodule
