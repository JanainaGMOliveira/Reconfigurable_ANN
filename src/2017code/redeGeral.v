module redeGeral(clk, rst, start,                                            // CLOCK E RESET E START
					  instrucao,                                                  // INSTRUCAO DE ENTRADA DA REDE
					  flagInst,                                                   // FLAG QUE INDICA QUE UMA NOVA INSTRUCAO ESTA' DISPONIVEL 
					  ix1, ix2, ix3, ix4, ix5, ix6, ix7, ix8, ix9, ix10,          // ENTRADAS DA REDE 
					  ix11, ix12, ix13, ix14, ix15, ix16, ix17, ix18, ix19, ix20, // ENTRADAS DA REDE
					  oR1, oR2, oR3, oR4, oR5, oR6, oR7, oR8, oR9, oR10,          // SAIDAS DA REDE
					  oR11, oR12, oR13, oR14, oR15, oR16, oR17, oR18, oR19, oR20, // SAIDAS DA REDE
					  oFlagRede                                                   // FLAG DE SAIDA DA REDE
					  ); 
	
	input clk;
	wire clkMAC;
	input rst;
	input start; // INDICA SE HA NOVA ENTRADA NA REDE, MESMA CONFIGURAÇÃO
	input flagInst;
	
	input [7:0] ix1, ix2, ix3, ix4, ix5, ix6, ix7, ix8, ix9, ix10, ix11, ix12, ix13, ix14, ix15, ix16, ix17, ix18, ix19, ix20; 
	input [9:0] instrucao;

	output reg [7:0] oR1, oR2, oR3, oR4, oR5, oR6, oR7, oR8, oR9, oR10, oR11, oR12, oR13, oR14, oR15, oR16, oR17, oR18, oR19, oR20;
	output reg oFlagRede; 
	
	// CONTROLE DA EXECUCAO
	wire instOK; // INDICA QUE AS INSTRUCOES JA ESTAO PRONTAS PARA SEREM USADAS
	reg startCarga; // INICIA O PROCESSO DA CARGA DE PESOS DA CAMADA
	wire pesosOK; // INDICA SE OS PESOS E BIAS ESTAO PRONTOS
	reg startCamada; // INICIA O PROCESSO DA CAMADA
	reg startNeuro; // INICIA O PROCESO DA MAC DOS NEURONIOS
	wire flagCamada; // INDICA SE A CAMADA FOI FINALIZADA
	
	// DADOS DE CONFIGURACAO
	reg [1:0] ctrlFA; // QUAL FA VAI SER USADA NA CAMADA
	reg [1:0] numCamada; // QUAL CAMADA ESTA SENDO EXECUTADA
	reg [4:0] qtdEntradas; // QUANTIDADE DE ENTRADAS DA CAMADA
	reg [4:0] qtdNeuro; // QUANTIDADE DE NEURONIOS NA CAMADA
	wire [2:0] qtdCamadas; // QUANTIDADE DE CAMADAS A SEREM EXECUTADAS
	reg flagBias; // INDICA SE HA BIAS NA CAMADA
	reg en1, en2, en3, en4, en5, en6, en7, en8, en9, en10, en11, en12, en13, en14, en15, en16, en17, en18, en19, en20; // INDICA SE O RESPECTIVO NEURONIO ESTA SENDO USADO
	
	// REGISTRADORES AUXILIARES
	wire [15:0] w [0:399]; // PESOS DAS ENTRADAS -- qtd de pesos depende do tamanho da memoria
	wire [15:0] bias [0:19]; // BIAS DOS NEURONIOS
	reg [7:0] inCamada [0:19]; // ENTRADAS DAS CAMADAS
	wire [7:0] outCamada [0:19]; // SAIDAS DAS CAMADAS
	wire [12:0] dados [3:0]; // DADOS PARA EXECUCAO DAS CAMADAS -  VEM DA INSTRUCAO
	reg [2:0] i; // controle camada
	
	// ESTADOS DA MDE
	(* syn_encoding = "safe" *) reg [2:0] atual;  
	parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100; 
	
	//GERA O CLOCK DO MAC
	unidadeClock g(clk, rst, clkMAC);
	
	// BUSCA DADOS DAS INTRUCOES E OS COLOCA EM UM REGISTRADOR ESPECIFICO
	unidadeInstrucao p(clk, rst,
							 instrucao, 
							 flagInst,
							 dados, 
							 instOK, 
							 qtdCamadas, 
							 ); 		  
	
	// BUSCA PESOS E BIAS DE CADA CAMADA
	unidadeMemoria s(clk, rst & start,
						  startCarga, 
						  flagCamada,
						  i[1:0], 
						  qtdEntradas, 
						  qtdNeuro, 
						  w,
						  bias, 
						  pesosOK); 
					 	
	// EXECUTA A CAMADA DA REDE
	unidadeCamada c(clkMAC, clk,
						 startNeuro,
	                inCamada, 
						 w,	
						 bias, 
						 flagBias, 
						 ctrlFA, 
						 startCamada, 
						 en1, en2, en3, en4, en5, en6, en7, en8, en9, 
						 en10, en11, en12, en13, en14, en15, en16, en17, en18, en19, en20,
						 qtdEntradas,
						 outCamada,
						 flagCamada
						 ); 
			  
   always @(negedge clk, negedge rst) 
	begin
		if(~rst)
		begin
			//ZERAR OS REG E DADOS NECESSARIOS
			inCamada <= '{{8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}},
							 {8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}}, {8{1'b0}}};
			oR1 <= {8{1'b0}}; oR2 <= {8{1'b0}}; oR3 <= {8{1'b0}}; oR4 <= {8{1'b0}}; oR5 <= {8{1'b0}};
			oR6 <= {8{1'b0}}; oR7 <= {8{1'b0}}; oR8 <= {8{1'b0}}; oR9 <= {8{1'b0}}; oR10 <= {8{1'b0}};
			oR11 <= {8{1'b0}}; oR12 <= {8{1'b0}}; oR13 <= {8{1'b0}}; oR14 <= {8{1'b0}}; oR15 <= {8{1'b0}};
			oR16 <= {8{1'b0}}; oR17 <= {8{1'b0}}; oR18 <= {8{1'b0}}; oR19 <= {8{1'b0}}; oR20 <= {8{1'b0}};
			oFlagRede <= 1'b0;
			
			startNeuro <= 1'b0;
			startCamada <= 1'b0;
			ctrlFA <= 2'b00; 
			numCamada <= 2'b00; 
			qtdEntradas <= 5'b00000;

			flagBias <= 1'b0; 
			en1 <= 1'b0; en2 <= 1'b0; en3 <= 1'b0; en4 <= 1'b0; en5 <= 1'b0; en6 <= 1'b0; en7 <= 1'b0; en8 <= 1'b0; en9 <= 1'b0; en10 <= 1'b0;
			en11 <= 1'b0; en12 <= 1'b0; en13 <= 1'b0; en14 <= 1'b0; en15 <= 1'b0; en16 <= 1'b0; en17 <= 1'b0; en18 <= 1'b0; en19 <= 1'b0; en20 <= 1'b0;
			i <= 3'b000;
			
			atual <= S0;

		end
		else
			case (atual)
				S0: // EXECUCAO DA BUSCA DE INSTRUCOES
				begin
					if(instOK)
					begin
						startCarga <= 1'b1;
						inCamada[0] <= ix1;
						inCamada[1] <= ix2;
						inCamada[2] <= ix3;
						inCamada[3] <= ix4;
						inCamada[4] <= ix5;
						inCamada[5] <= ix6;
						inCamada[6] <= ix7;
						inCamada[7] <= ix8;
						inCamada[8] <= ix9;
						inCamada[9] <= ix10;
						inCamada[10] <= ix11;
						inCamada[11] <= ix12;
						inCamada[12] <= ix13;
						inCamada[13] <= ix14;
						inCamada[14] <= ix15;
						inCamada[15] <= ix16;
						inCamada[16] <= ix17;
						inCamada[17] <= ix18;
						inCamada[18] <= ix19;
						inCamada[19] <= ix20;
						atual <= S1;
					end
					else
					begin
						startCarga <= 1'b0;
						atual <= S0;
					end
				end
				S1: // EXECUCAO DA BUSCA DE PESOS	
				begin 					
					startCarga <= 1'b0;
					
					if(i < qtdCamadas)
					begin
						// DISPONIBILIZAR AS INFORMACOES PARA A EXECUCAO DA CAMADA.
						numCamada = i[1:0];
						qtdEntradas = dados[i[1:0]][4:0];
						flagBias = dados[i[1:0]][7];
						ctrlFA = dados[i[1:0]][6:5];
						qtdNeuro = dados[i[1:0]][12:8];
						
						// DETERMINAR QUAIS NEURONIOS ESTAO SENDO USADOS PELA CAMADA
						en1 = 1'b1; 
						en2 = qtdNeuro[4] | qtdNeuro[3] | qtdNeuro[2]| qtdNeuro[1] | qtdNeuro[0];
						en3 = qtdNeuro[4] | qtdNeuro[3] | qtdNeuro[2] | qtdNeuro[1];
						en4 = qtdNeuro[4] | qtdNeuro[3] | qtdNeuro[2] | (qtdNeuro[1] & qtdNeuro[0]);
						en5 = qtdNeuro[4] | qtdNeuro[3] | qtdNeuro[2];
						en6 = (qtdNeuro[4] | qtdNeuro[3] | qtdNeuro[2]) & (qtdNeuro[4] | qtdNeuro[3] | ~qtdNeuro[2] | qtdNeuro[1] | qtdNeuro[0]);
						en7 = (qtdNeuro[4] | qtdNeuro[3] | qtdNeuro[2]) & (qtdNeuro[4] | qtdNeuro[3] | ~qtdNeuro[2] | qtdNeuro[1]);
						en8 = qtdNeuro[4] | qtdNeuro[3] | (qtdNeuro[2] & qtdNeuro[1] & qtdNeuro[0]);
						en9 = qtdNeuro[4] | qtdNeuro[3];
						en10 = (qtdNeuro[4] | qtdNeuro[3]) & (qtdNeuro[4] | qtdNeuro[2] | qtdNeuro[1] | qtdNeuro[0]);
						en11 = (qtdNeuro[4] | qtdNeuro[3]) & (qtdNeuro[4] | ~qtdNeuro[3] | qtdNeuro[2] | qtdNeuro[1]);
						en12 = (qtdNeuro[4] | qtdNeuro[3]) & (qtdNeuro[4] | qtdNeuro[2] | qtdNeuro[1]) & (qtdNeuro[4] | qtdNeuro[2] | ~qtdNeuro[1] | qtdNeuro[0]);
						en13 = (qtdNeuro[4] | qtdNeuro[3] | ~qtdNeuro[2]) & (qtdNeuro[4] | qtdNeuro[2]);
						en14 = qtdNeuro[4] | (qtdNeuro[4] & qtdNeuro[3] & qtdNeuro[2] & qtdNeuro[1]) | (qtdNeuro[4] & qtdNeuro[3] & qtdNeuro[2] & ~qtdNeuro[1] & qtdNeuro[0]);
						en15 = qtdNeuro[4] | (~qtdNeuro[4] & qtdNeuro[3] & qtdNeuro[2] & qtdNeuro[1]);
						en16 = qtdNeuro[4] | (qtdNeuro[3] & qtdNeuro[2] & qtdNeuro[1] & qtdNeuro[0]);
						en17 = qtdNeuro[4];
						en18 = qtdNeuro[4] & (qtdNeuro[1] | qtdNeuro[0]);
						en19 = qtdNeuro[4] & qtdNeuro[1];
						en20 = qtdNeuro[4] & qtdNeuro[1] & qtdNeuro[0];
						
						if(pesosOK)
						begin
							startNeuro <= 1'b1;
							startCamada <= 1'b1;
							atual <= S2;
						end
						else
						begin
							startNeuro <= 1'b0;
							startCamada <= 1'b0;
							atual <= S1;
						end
					end
					else
						atual <= S3;
				end
				S2: // EXECUCAO DA CAMADA
				begin
					startNeuro <= 1'b0;
					startCamada <= 1'b1;
					if(flagCamada) // A EXECUCAO DA CAMADA TERMINOU
					begin
						startCamada <= 1'b0;
						// VERIFICAR SE É A ULTIMA CAMADA A SER EXECUTADA.
						if(i < qtdCamadas)
						begin
							i <= i + 3'b001;
							numCamada <= i[1:0];
							inCamada <= outCamada;
							if(i < qtdCamadas) startCarga <= 1'b1;
							else startCarga <= 1'b0;
							atual <= S1;
						end
						else
							atual <= S3;
					end
				end
				S3: // COLOCAR AS SAIDAS PARA FORA
				begin	
					oR1 <= outCamada[0];
					oR2 <= outCamada[1];
					oR3 <= outCamada[2];
					oR4 <= outCamada[3];
					oR5 <= outCamada[4];
					oR6 <= outCamada[5];
					oR7 <= outCamada[6];
					oR8 <= outCamada[7];
					oR9 <= outCamada[8];
					oR10 <= outCamada[9];
					oR11 <= outCamada[10];
					oR12 <= outCamada[11];
					oR13 <= outCamada[12];
					oR14 <= outCamada[13];
					oR15 <= outCamada[14];
					oR16 <= outCamada[15];
					oR17 <= outCamada[16];
					oR18 <= outCamada[17];
					oR19 <= outCamada[18];
					oR20 <= outCamada[19];
					atual <= S4;
				end
				S4: //FINALIZAR A REDE E ESPERAR NOVAS ENTRADAS
				begin
					oFlagRede <= 1'b1;
					if(~start)
					begin
						oFlagRede <= 1'b0;
						startCarga <= 1'b1;
						i <= 3'b000;
						inCamada[0] <= ix1;
						inCamada[1] <= ix2;
						inCamada[2] <= ix3;
						inCamada[3] <= ix4;
						inCamada[4] <= ix5;
						inCamada[5] <= ix6;
						inCamada[6] <= ix7;
						inCamada[7] <= ix8;
						inCamada[8] <= ix9;
						inCamada[9] <= ix10;
						inCamada[10] <= ix11;
						inCamada[11] <= ix12;
						inCamada[12] <= ix13;
						inCamada[13] <= ix14;
						inCamada[14] <= ix15;
						inCamada[15] <= ix16;
						inCamada[16] <= ix17;
						inCamada[17] <= ix18;
						inCamada[18] <= ix19;
						inCamada[19] <= ix20;
						atual <= S1;
					end						
				end
			endcase
	end
endmodule


