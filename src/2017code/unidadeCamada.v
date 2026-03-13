module unidadeCamada(clkMAC, clk,                                                          // CLOCKs DO SISTEMA
						   iStartNeuro,                                                          // START DO NEURONIO
						   ix,                                                                   //ENTRADAS DA CAMADA
						   iw,                                                                   // PESOS DOS NEURONIOS
						   iBias,                                                                // BIAS DOS NEURONIOS
						   iFlagBias,                                                            // FLAG DE ATIVACAO DO BIAS
						   iCtrlFA,                                                              // CONTROLE DA FA
						   iStartCamada, 																			 // PERMITE QUE A SAIDA DA CAMADA SEJA DISPONIBILIZADA
						   iEn1, iEn2, iEn3, iEn4, iEn5, iEn6, iEn7, iEn8, iEn9, iEn10,          // ENABLE DOS NEURONIOS
						   iEn11, iEn12, iEn13, iEn14, iEn15, iEn16, iEn17, iEn18, iEn19, iEn20, // ENABLE DOS NEURONIOS
						   iQtdEntradas, 																			 // QUANTIDADE DE ENTRADAS DA CAMADA
							oR,  																						 // SAIDA DA CAMADA 
						   oFlagCamada																				 // FLAG DE SAIDA DA CAMADA
							); 
		
	input clkMAC, clk; 
	input iStartNeuro;
	
	input [7:0] ix [0:19]; 
	input [15:0] iw [0:399];
	input [15:0] iBias [0:19];

	input [1:0] iCtrlFA;
	input iStartCamada;
	input iFlagBias;
	input iEn1, iEn2, iEn3, iEn4, iEn5, iEn6, iEn7, iEn8, iEn9, iEn10, iEn11, iEn12, iEn13, iEn14, iEn15, iEn16, iEn17, iEn18, iEn19, iEn20;
	input [4:0] iQtdEntradas;
	
	output reg [7:0] oR [0:19];
	output reg oFlagCamada;

	wire [7:0] auxR [0:19];
	
	wire oFlagNeuro1, oFlagNeuro2, oFlagNeuro3, oFlagNeuro4, oFlagNeuro5, oFlagNeuro6, oFlagNeuro7, oFlagNeuro8, oFlagNeuro9, oFlagNeuro10;
	wire oFlagNeuro11, oFlagNeuro12, oFlagNeuro13, oFlagNeuro14, oFlagNeuro15, oFlagNeuro16, oFlagNeuro17, oFlagNeuro18, oFlagNeuro19, oFlagNeuro20;
	
	controleSaida #(.N(8)) c(auxR,
									 oFlagNeuro1, oFlagNeuro2, oFlagNeuro3, oFlagNeuro4, oFlagNeuro5, oFlagNeuro6, oFlagNeuro7, oFlagNeuro8,  oFlagNeuro9, oFlagNeuro10, 
									 oFlagNeuro11, oFlagNeuro12, oFlagNeuro13, oFlagNeuro14, oFlagNeuro15, oFlagNeuro16, oFlagNeuro17, oFlagNeuro18, oFlagNeuro19, oFlagNeuro20, // flags neurônios
									 iStartCamada,
									 oR, 
									 oFlagCamada);
	
	neuronio n1(clkMAC, clk, iStartNeuro, iStartCamada,
					ix, 
					iw[0:19], 
					iBias[0],
					iFlagBias, iEn1, iCtrlFA, iQtdEntradas,
					auxR[0], oFlagNeuro1
					);					
					
	neuronio n2(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[20:39], 
					iBias[1],
					iFlagBias, iEn2, iCtrlFA, iQtdEntradas,
					auxR[1], oFlagNeuro2
					);
					
	neuronio n3(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[40:59],
					iBias[2],
					iFlagBias, iEn3, iCtrlFA, iQtdEntradas,
					auxR[2], oFlagNeuro3);
					
	neuronio n4(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[60:79],
					iBias[3],
					iFlagBias, iEn4, iCtrlFA, iQtdEntradas,
					auxR[3], oFlagNeuro4);
				
	neuronio n5(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[80:99], 
					iBias[4],
					iFlagBias, iEn5, iCtrlFA, iQtdEntradas,
					auxR[4], oFlagNeuro5);
					
	neuronio n6(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[100:119],
					iBias[5],
					iFlagBias, iEn6, iCtrlFA, iQtdEntradas,
					auxR[5], oFlagNeuro6);
					
	neuronio n7(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[120:139], 
					iBias[6],
					iFlagBias, iEn7, iCtrlFA, iQtdEntradas,
					auxR[6], oFlagNeuro7);
					
	neuronio n8(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[140:159],
					iBias[7],
					iFlagBias, iEn8, iCtrlFA, iQtdEntradas,
					auxR[7], oFlagNeuro8);
					
	neuronio n9(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[160:179],
					iBias[8],
					iFlagBias, iEn9, iCtrlFA, iQtdEntradas,
					auxR[8], oFlagNeuro9);
					
	neuronio n10(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[180:199],
					iBias[9],
					iFlagBias, iEn10, iCtrlFA, iQtdEntradas,
					auxR[9], oFlagNeuro10);
					
	neuronio n11(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[200:219], 
					iBias[10],
					iFlagBias, iEn11, iCtrlFA, iQtdEntradas,
					auxR[10], oFlagNeuro11);

	neuronio n12(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[220:239], 
					iBias[11],
					iFlagBias, iEn12, iCtrlFA, iQtdEntradas,
					auxR[11], oFlagNeuro12);
					
	neuronio n13(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[240:259],
					iBias[12],
					iFlagBias, iEn13, iCtrlFA, iQtdEntradas,
					auxR[12], oFlagNeuro13);
					
	neuronio n14(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[260:279],
					iBias[13],
					iFlagBias, iEn14, iCtrlFA, iQtdEntradas,
					auxR[13], oFlagNeuro14);
				
	neuronio n15(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[280:299],
					iBias[14],
					iFlagBias, iEn15, iCtrlFA, iQtdEntradas,
					auxR[14], oFlagNeuro15);
					
	neuronio n16(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[300:319],  
					iBias[15],
					iFlagBias, iEn16, iCtrlFA, iQtdEntradas,
					auxR[15], oFlagNeuro16);
					
	neuronio n17(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[320:339], 
					iBias[16],
					iFlagBias, iEn17, iCtrlFA, iQtdEntradas,
					auxR[16], oFlagNeuro17);
					
	neuronio n18(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[340:359], 
					iBias[17],
					iFlagBias, iEn18, iCtrlFA, iQtdEntradas,		
					auxR[17], oFlagNeuro18);
					
	neuronio n19(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[360:379],
					iBias[18],
					iFlagBias, iEn19, iCtrlFA, iQtdEntradas,
					auxR[18], oFlagNeuro19);
					
	neuronio n20(clkMAC, clk, iStartNeuro, iStartCamada,
					ix,
					iw[380:399], 
					iBias[19],
					iFlagBias, iEn20, iCtrlFA, iQtdEntradas,
					auxR[19], oFlagNeuro20);
endmodule

module controleSaida(iN,                                                         // SAIDAS DOS NEURONIOS 
							iF1, iF2, iF3, iF4, iF5, iF6, iF7, iF8, iF9, iF10,          // FLAGS DE SAIDA DOS NEURONIOS
							iF11, iF12, iF13, iF14, iF15, iF16, iF17, iF18, iF19, iF20, // FLAGS DE SAIDA DOS NEURONIOS
							iStartCamada,                                               // HABILITA A SAIDA DA CAMADA
							oC,                                                         // SAIDAS DA CAMADA
							oFlag);                                                     // FLAG DE SAIDA DA CAMADA
		
	parameter N = 8;
	
	input [N-1:0] iN [0:19];
	input iF1, iF2, iF3, iF4, iF5, iF6, iF7, iF8, iF9, iF10, iF11, iF12, iF13, iF14, iF15, iF16, iF17, iF18, iF19, iF20;
	input iStartCamada;
	output reg [N-1:0] oC [0:19];
	output reg oFlag;
	
	always @(*)
	begin
		if(iStartCamada)
		begin
			oC = iN;
			oFlag = iF1 & iF2 & iF3 & iF4 & iF5 & iF6 & iF7 & iF8 & iF9 & iF10 & iF11 & iF12 & iF13 & iF14 & iF15 & iF16 & iF17 & iF18 & iF19 & iF20;
		end
		else
		begin
			oFlag = 1'b0;
		end			
	end
endmodule
