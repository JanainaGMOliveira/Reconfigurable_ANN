module neuron #(parameter neurons = 20, N = 8)(
	output [N-1:0] oNeuron,
	output oReadyNeuron,
	input clk,
	input iEnable, // sets if neuron is activated
	input iStart, // starts neuron
	input [(neurons * N)-1:0] ix,
	input [(neurons * N * 2)-1:0] iw,
	input [2*N-1:0] iBias,
	input enableBias,
	input [1:0] iCtrlAF, // AF control: 00 bipolar, 01 rampa, 10 sig, 11 tanh.
	input [4:0] iNumberInputs
);
	wire [4*N-1:0] sum;
	wire sumReady; 
	wire [N-1:0] oAF1, oAF2, oAF3, oAF4;
	
	mac #(.neurons(20), .N(8)) m(sum,
								 sumReady,
								 clk,
								 iStart,
								 ix,
								 iw,
								 iBias,
								 enableBias,
								 iNumberInputs);

	degrau_bipolar     b(oAF1, sum);
	rampa              r(oAF2, sum);
	sigm               l(oAF3, sum);
	tanh               t(oAF4, sum);
	
	outputNeuronController #(.N(8)) n(oNeuron,
									oReadyNeuron,
									oAF1,
									oAF2,
									oAF3,
									oAF4,
									iCtrlAF,
									sumReady);
endmodule
