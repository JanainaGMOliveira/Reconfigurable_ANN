module outputLayerController #(parameter neurons = 20, N = 8)(
	output reg [(neurons * N)-1:0] oLayer, // layer outputs
	output reg oReady, 
	input [(neurons * N)-1:0] iN,          // neuron outputs
	input [neurons-1:0] iF,                // neuron ready flags
	input iEnableLayer
);
	always @(*)
	begin
		if(iEnableLayer)
		begin
			oLayer = iN;
			oReady = &iF;
		end
		else
		begin
			oReady = 1'b0;
		end
	end
endmodule
