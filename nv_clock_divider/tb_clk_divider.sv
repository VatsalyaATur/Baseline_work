module clock_divider_tb;
//////////////////////////// AS PER EDA PLAYGROUND
    // Inputs
    logic clk;
    logic rst;
    logic [1:0] sel;

    // Outputs
    logic clk_out;

    // Instantiate the Unit Under Test (UUT)
    clock_divider dut (
        .clk(clk),
        .rst(rst),
        .sel(sel),
        .clk_out(clk_out)
    );

    // Clock generation
    always begin
        clk = 0;
        #5;
        clk = 1;
        #5;
    end

    // Reset assertion
    initial begin
        rst = 1;
        #10;
        rst = 0;
    end

    // Stimulus
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, clock_divider_tb);

        sel = 2'b00; // clk/2
        #30;
        sel = 2'b01; // clk/4
        #30;
        sel = 2'b10; // clk/8
        #30;
        sel = 2'b11; // clk/16
        #30;
        
        $finish;
    end

endmodule
