module unidadeInstrucao(clk, rst,     // CLOCK E RESET DO SISTEMA
								iInstrucao,  // INSTRUCAO DE ENTRADA
								iFlag,       // FLAG QUE INDICA QUE UMA NOVA INSTRUÇÃO FOI COLOCADA
								oDados,      // SAIDA COM INFORMACOES IMPORTANTES DAS INSTRUCOES 
								oOK,         // FLAG DE SAIDA DISPONIVEL
								oQtdCamadas // QUANTIDADE DE CAMADAS DA REDE
								);
	
	input clk, rst;
	input [9:0] iInstrucao; 
	input iFlag;
	output reg [12:0] oDados [3:0]; // NÚMERO MÁXIMO DE CAMADAS DA REDE É 4
	output reg oOK;
	output reg [2:0] oQtdCamadas;

	reg [3:0] i, j;
	reg [9:0] instrucao [4:0]; // MÁXIMO DE 5 INSTRUCOES NA REDE
	
	reg captOK; // DIZ SE A CAPTUTA DAS INSTRUCOES ESTA FINALIZADA
	
	(* syn_encoding = "safe" *) reg [1:0] atual;  
	parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11; // ESTADOS
	
	always @(negedge iFlag, negedge rst)
	begin
		if(~rst) // ZERA REGISTRADORES DE INSTRUCOES E FLAGS
		begin
			captOK <= 1'b0;
			oQtdCamadas = 3'b000;
			i = 4'b0000;
		end
		else
		if(~iFlag & ~captOK)
		begin
			instrucao[i] = iInstrucao[9:0];
			i = i + 4'b0001;
			if(iInstrucao[9:8] != 2'b11) // VERIFICA SE É A ÚLTIMA INSTRUÇÃO A SER LIDA (CAMADA DE SAIDA) 
				captOK <= 1'b0;
			else
			begin
				i = i - 4'b0001;
				oQtdCamadas = i[2:0];
				captOK <= 1'b1;
			end
		end
	end
	
   always @ (negedge clk, negedge rst) 
	begin
		if(~rst) // ZERA REGISTRADORES DE INSTRUCOES E FLAGS
		begin
			oDados = '{{13{1'b0}}, {13{1'b0}}, {13{1'b0}}, {13{1'b0}}}; 
			j = 4'b0000;
			oOK = 1'b0;
			atual <= S0;
		end
		else
			case (atual)
				S0: // RECEBER OS DADOS DE CONFIGURAÇÃO DAS ENTRADAS
				begin
			      oOK = 1'b0;
					if(captOK)
						atual <= S1;
					else
						atual <= S0;
				end
				S1: // PASSAR INSTRUCOES PARA DADOS
				begin
					oDados[j[1:0]][4:0] = instrucao[j][7:3]; // QUANTIDADE DE ENTRADAS DA CAMADA
					oDados[j[1:0]][12:8] = instrucao[j+4'b0001][7:3]; // QUANTIDADE DE NEURONIOS NA CAMADA
					oDados[j[1:0]][7] = instrucao[j+4'b0001][2]; // FLAG DE BIAS DA CAMADA
					oDados[j[1:0]][6:5] = instrucao[j+4'b0001][1:0]; // FA
					
					if (instrucao[j+4'b0001][9:8] == 2'b11)
						atual <= S2;
					else
					begin
						j = j + 4'b0001;
						atual <= S1;
					end
				end
				S2: // ESTADO FINAL - DISPONIBILIZACAO DA SAIDA
				begin
					oOK = 1'b1;
				end
				default:
				begin
					oOK = 1'b0;
					atual <= S0;
				end
			endcase
	end	
endmodule
