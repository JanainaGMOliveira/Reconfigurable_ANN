`timescale 1ns/100ps

module neuron_TB;
	wire clk;
	reg start, enable;
	reg [(20 * 8)-1:0] ix;
	reg [(20 * 16)-1:0] iw;
	reg [15:0] iBias;
	reg enableBias;
	reg [4:0] iNumberInputs;
    reg [1:0] iCtrlAF;

    wire [7:0] oAF1, oAF2, oAF3, oAF4;
    wire [7:0] oNeuron;
	wire oReadyNeuron;

    clockGeneratorByPeriod #(20) clock(clk);

    // degrau_bipolar     b(oAF1, 32'b000000000000_10000000000000000000); // 001_00000
	// rampa              r(oAF2, 32'b000000000000_10000000000000000000); // 000_10000
	// sigm               l(oAF3, 32'b000000000000_10000000000000000000); // 000_10100
	// tanh               t(oAF4, 32'b000000000000_10000000000000000000); // 000_10000

    neuron #(20, 8) DUT(oNeuron,
                    oReadyNeuron,
                    clk,
                    enable,
                    start,
                    ix,
                    iw,
                    iBias,
                    enableBias,
                    iCtrlAF,
                    iNumberInputs);

    initial
    begin
        ix[1 *8 - 1: 0 *8] = 8'b000_10000; //0,5
        ix[2 *8 - 1: 1 *8] = 8'b111_10000; // -0,5

        iw[1 *16 - 1: 0 *16] = 16'b111111_0000000000; // -1
        iw[2 *16 - 1: 1 *16] = 16'b111110_0000000000; // -2

        enableBias = 1'b0;
        iNumberInputs = 5'd2;

        enable = 1'b0;
        start = 1'b0; #50

        start = 1'b1; #50
        start = 1'b0; #50

        iCtrlAF = 2'b00;
        enable = 1'b1;
        start = 1'b1; #50
        start = 1'b0; 
        #250;

        iCtrlAF = 2'b01;
        enable = 1'b1;
        start = 1'b1; #50
        start = 1'b0; 
        #250;

        iCtrlAF = 2'b10;
        enable = 1'b1;
        start = 1'b1; #50
        start = 1'b0; 
        #250;

        iCtrlAF = 2'b11;
        enable = 1'b1;
        start = 1'b1; #50
        start = 1'b0; 
        #250;
        $stop;

    end

endmodule

module clockGeneratorByPeriod #(parameter period = 5)(
    output clk
);
    reg outClk;

    initial outClk = 1'b0;                   // clk is initially 0

    always
    begin
        #(period/2) outClk = ~outClk;        // after a delay of period, the clk receives its inverse
    end

    assign clk = outClk;

endmodule