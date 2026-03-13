module mac #(parameter neuros = 20)(
	output reg [31:0] oSoma, // SOMA FINAL
	output reg oSomaOK, // FLAG QUE INDICA QUE A SOMA FINALIZOU
	input clkMAC,
	input start,
	input [(neuros * 8)-1:0] ix, // ENTRADAS DO MAC
	input [(neuros * 16)-1:0] iw, // PESOS
	input [15:0] iBias, // BIAS
	input iFlagBias, // FLAG QUE INDICA SE HA BIAS
	input [4:0] iQtdEntradas // QUANTIDADE DE ENTRADAS DA CAMADA
);
	// get the values for each input
	wire [7:0] auxX [0:neuros-1];
	genvar j;
	generate
		for (j = 0; j < neuros; j = j + 1)
		begin
			assign auxX[j] = ix[(j*8 + 7) -: 8];
		end
	endgenerate

	wire [15:0] auxW [0:neuros-1];
	generate
		for (j = 0; j < neuros; j = j + 1)
		begin
			assign auxW[j] = iw[(j*16 + 15) -: 16];
		end
	endgenerate

	reg [4:0] i;
	
	(* syn_encoding = "safe" *) reg [1:0] currentState, nextState;
	parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
	
	reg [7:0] auxX1, auxX2; //auxiliares para a entrada x
	reg [15:0] auxW1, auxW2; //auxiliares para a entrada w
	
	wire [31:0] aux1, aux2; // AUXILIARES SAÍDAS MULTIPLICADORES
	wire [31:0] auxS; // AUXILIAR SAÍDA SOMA
	reg [31:0] auxOut1; // AUXILIARES SAÍDAS MULTIPLICADORES
	
	multiplier m1(auxX1, auxW1, aux1);
	multiplier m2(auxX2, auxW2, aux2);
	
	assign auxS = SomaOverflow(aux1, aux2);
	
	// Função para controle de flag
	function [31:0] SomaOverflow;
		input [31:0] iA, iB;
		
		reg [31:0] aux;
		begin
			aux = iA + iB;
			if (iA[31] == 1'b1 & iB[31] == 1'b1 & aux[31] == 1'b0)
				aux = 32'b10000000000000000000000000000000;
			else if (iA[31] == 1'b0 & iB[31] == 1'b0 & aux[31] == 1'b1)
				aux = 32'b01111111111111111111111111111111;
				
			SomaOverflow = aux;
		end
	endfunction
	
	always @(negedge clkMAC, posedge start)
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

   	always @ (currentState, start, negedge clkMAC)
	begin
		case (currentState)
			S0: // INITIAL PREPARATION TO MAC
			begin
				oSomaOK = 1'b0;
				i = 5'b0;
				auxX1 = auxX[i];
				auxW1 = auxW[i];
				auxX2 = auxX[i+1];
				auxW2 = auxW[i+1];
				auxOut1 = 32'b0;
				
				if (iFlagBias)
					oSoma = {{6{iBias[15]}}, iBias, {10{1'b0}}}; 
				else
					oSoma = 32'b0;
				
				if(start)
					nextState = S0;
				else
					nextState = S1;
			end
			S1: // MULTIPLICATION
			begin
				oSoma = SomaOverflow(oSoma, auxS); // SUM PREVIOUS PRODUCT
				auxX1 = auxX[i]; // GET NEW VALUES
				auxW1 = auxW[i];
				auxX2 = auxX[i+1];
				auxW2 = auxW[i+1];
				
				if ((iQtdEntradas - 3) > i)
				begin
					i = i + 2; // INCREASE COUNTER
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
				oSomaOK = 1'b1;
				
				nextState <= S0;
			end
			default:
			begin
				oSomaOK = 1'b0;
				nextState = S0;
			end
		endcase
	end
endmodule