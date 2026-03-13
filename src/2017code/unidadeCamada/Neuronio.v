module neuronio(clkMAC, clk,  // CLOCKs DO SISTEMA
					 iStart,       // DA INICIO A EXECUCAO DO NEURONIO
					 iStartCamada, // INDICA O INICIO DA CAMADA
					 ix,           // ENTRADAS DA CAMADA
					 iw,           // PESOS DO NEURONIO
					 iBias,        // BIAS DO NEURONIO
					 iFlagBias,    // FLAG QUE INDICA A PRESENCA DE BIAS
					 iEnable,      // INDICA SE O NEURONIO ESTA ATIVADO
					 iCtrlFA,      //INDICA QUAL A FA DO NEURONIO
					 iQtdEntradas, // INDICA A QUANTIDADE DE ENTRADAS USADAS
					 oN,           // SAIDA DO NEURONIO
					 oFlagNeuro    // FLAG DA SAIDA DO NEURONIO
					 );

	input clk, clkMAC, iStart; 
	input iStartCamada; 
	input iEnable; 
	input [1:0] iCtrlFA; // CONTROLA A FA: se 00 bipolar, se 01 rampa, se 10 sig, se 11 tanh.
	input [4:0] iQtdEntradas;
	input iFlagBias; 

	input [7:0] ix [0:19];
	input [15:0] iw [0:19];
	input [15:0] iBias; 
	
	output [7:0] oN; 
	output oFlagNeuro; 
	
	wire [31:0] soma; 
	wire somaOK; 
	wire [7:0] oFA1, oFA2, oFA3, oFA4; 
	
	mac m(clkMAC, ~(~iStart & iStartCamada),
			ix,
			iw, 
			iBias, 
			iFlagBias, 
			iQtdEntradas,
			soma, 
			somaOK); 
	
	degrau_bipolar     b(soma, oFA1); 
	rampa              r(soma, oFA2);
	sig                l(soma, oFA3);
	tanh               t(soma, oFA4);
	
	mux4_1 #(.N(8)) mx(clk, oFA1, oFA2, oFA3, oFA4, iCtrlFA, somaOK, iStartCamada, iEnable, oN, oFlagNeuro);
	
endmodule

module mux4_1(clk, iFA1, iFA2, iFA3, iFA4, iCtrlFA, iCtrlSoma, iStartCamada, iEnable, oSaidaNeuro, oF);
	parameter N = 8;
	
	input clk;
	input [N-1:0] iFA1, iFA2, iFA3, iFA4;
   input [1:0] iCtrlFA;
	input iCtrlSoma, iEnable, iStartCamada;
   output reg [N-1:0] oSaidaNeuro;
	output reg oF;
	reg [N-1:0] aux;

   always @(iFA1, iFA2, iFA3, iFA4, iCtrlSoma, iStartCamada, clk)
	begin
	if(clk)
		if(iStartCamada) // CAMADA INICIOU SUA EXECUÇÃO
			if (iEnable) // NEURÔNIO ESTÁ ATIVADO
				if(iCtrlSoma) // SOMA ESTÁ OK
					case (iCtrlFA)
						2'b00:
						begin	
							oF = 1'b1;
							oSaidaNeuro <= iFA1;
						end
						2'b01: 
						begin
							oF = 1'b1;
							oSaidaNeuro <= iFA2;
						end
						2'b10: 
						begin	
							oF = 1'b1;
							oSaidaNeuro <= iFA3;
						end
						2'b11: 
						begin	
							oF = 1'b1;
							oSaidaNeuro <= iFA4;
						end
						default 
						begin	
							oSaidaNeuro <= {N{1'b0}};
							oF = 1'b0;
						end
					endcase
				else // SOMA NÃO ESTÁ OK
				begin
					oSaidaNeuro = {N{1'b0}};
					oF = 1'b0;
				end
			else
			begin // NEURÔNIO NÃO ESTÁ ATIVADO
				oSaidaNeuro <= {N{1'b0}};
				oF = 1'b1;
			end
		else 
		begin // CAMADA NÃO INICIOU SUA EXECUÇÃO
			oSaidaNeuro <= {N{1'b0}};
			oF = 1'b0;
		end
	end
endmodule
