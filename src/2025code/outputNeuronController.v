module outputNeuronController #(parameter N = 8)(
	output reg [N-1:0] oNeuron,
	output reg oReady, 
	input [N-1:0] iFA1, iFA2, iFA3, iFA4,          // AF outputs
	input [1:0] iCtrlFA,                // AF choice
	input iSumReady
);
	always @(*)
	begin
		if(iSumReady)
		begin
			oReady = 1'b1;
			case (iCtrlFA)
				2'b00:   oNeuron <= iFA1;
				2'b01:   oNeuron <= iFA2;
				2'b10:   oNeuron <= iFA3;
				2'b11:   oNeuron <= iFA4;
				default: oNeuron <= {N{1'b0}};
			endcase
		end
		else
		begin
			oReady = 1'b0;
		end
	end
endmodule
