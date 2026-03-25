module mac #(parameter neurons = 20, N = 8)(
	output reg [4*N-1:0] oSum,
	output reg sumReady,
	input clk,
	input start,
	input [(neurons * N)-1:0] ix,  // mac inputs
	input [(neurons * N * 2)-1:0] iw, // weights
	input [2*N-1:0] iBias,           // bias
	input enableBias,              // 1: there is bias
	input [4:0] iNumberInputs
);
	// get the values for each input
	wire [N-1:0] auxX [0:neurons-1];
	genvar j;
	generate
		for (j = 0; j < neurons; j = j + 1)
		begin
			assign auxX[j] = ix[(j*N + N-1) -: N];
		end
	endgenerate

	wire [2*N-1:0] auxW [0:neurons-1];
	generate
		for (j = 0; j < neurons; j = j + 1)
		begin
			assign auxW[j] = iw[(j*2*N + 2*N-1) -:2*N];
		end
	endgenerate

	reg [4:0] i;
	
	(* syn_encoding = "safe" *) reg [1:0] currentState, nextState;
	parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
	
	reg [7:0] auxX1, auxX2;  // update x values
	reg [15:0] auxW1, auxW2; // update w values
	
	wire [31:0] auxProd1, auxPro2; // multiplier partial outputs
	wire [31:0] auxS;              // partial sum
	
	multiplier m1(auxX1, auxW1, auxProd1);
	multiplier m2(auxX2, auxW2, auxPro2);
	
	assign auxS = SumOverflow(auxProd1, auxPro2);
	
	function [4*N-1:0] SumOverflow;
		input [4*N-1:0] iA, iB;
		
		reg [4*N-1:0] aux;
		begin
			aux = iA + iB;
			if (iA[4*N-1] == 1'b1 & iB[4*N-1] == 1'b1 & aux[4*N-1] == 1'b0)
				aux = {1'b1, {4*N-1{1'b0}}};
			else if (iA[4*N-1] == 1'b0 & iB[4*N-1] == 1'b0 & aux[4*N-1] == 1'b1)
				aux = {1'b0, {4*N-1{1'b1}}};
				
			SumOverflow = aux;
		end
	endfunction
	
	always @(negedge clk, start)
	begin
		if(start)
		begin
			currentState <= S0;
		end
		else
		begin
			currentState <= nextState;
		end
	end

   	always @ (currentState, start, negedge clk)
	begin
		case (currentState)
			S0: // INITIAL PREPARATION MAC
			begin
				sumReady = 1'b0;
				i = 5'b0;
				auxX1 = 0;//auxX[i];
				auxW1 = 0;//auxW[i];
				auxX2 = 0;//auxX[i+1];
				auxW2 = 0;//auxW[i+1];
				
				if (enableBias)
					oSum = {{6{iBias[15]}}, iBias, {10{1'b0}}}; 
				else
					oSum = {4*N{1'b0}};
				
				if(start)
					nextState = S0;
				else
					nextState = S1;
			end
			S1: // MULTIPLICATION
			begin
				oSum = SumOverflow(oSum, auxS); // SUM PREVIOUS PRODUCT
				auxX1 = auxX[i];                // GET NEW VALUES
				auxW1 = auxW[i];
				auxX2 = auxX[i+1];
				auxW2 = auxW[i+1];
				
				if (iNumberInputs > i)
				begin
					i = i + 2; // INCREASE COUNTER - 2 multiplications each time
					nextState = S1;
				end
				else
				begin
					auxX1 = 0;
					auxW1 = 0;
					auxX2 = 0;
					auxW2 = 0;
					nextState = S2;
				end
			end
			S2: // END OF MULTIPLICATIONS
			begin
				sumReady = 1'b1;
				
				nextState <= S0;
			end
			default:
			begin
				sumReady = 1'b0;
				nextState = S0;
			end
		endcase
	end
endmodule