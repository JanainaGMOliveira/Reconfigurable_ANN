module mac(clkMAC, start, // CLOCK E START DO SISTEMA
			  ix,           // ENTRADAS DO MAC
			  iw,           // PESOS 
			  iBias,        // BIAS
			  iFlagBias,    // FLAG QUE INDICA SE HA BIAS
			  iQtdEntradas, // QUANTIDADE DE ENTRADAS DA CAMADA
			  oSoma,        // SOMA FINAL
			  oSomaOK);     // FLAG QUE INDICA QUE A SOMA FINALIZOU
	
	input clkMAC, start;	
	input reg [7:0] ix [0:19];
	input reg [15:0] iw [0:19];
	input [15:0] iBias; 
	
	input iFlagBias; 
	input [4:0] iQtdEntradas; 
	
	output reg [31:0] oSoma;
	output reg oSomaOK;

	reg [4:0] i;
	
	(* syn_encoding = "safe" *) reg [1:0] atual;  
	
	parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
	
	reg [7:0] auxX1, auxX2; //auxiliares para a entrada x
	reg [15:0] auxW1, auxW2; //auxiliares para a entrada w
	
	wire [31:0] aux1, aux2; // AUXILIARES SAÍDAS MULTIPLICADORES
	wire [31:0] auxS; // AUXILIAR SAÍDA SOMA
	reg [31:0] auxOut1; // AUXILIARES SAÍDAS MULTIPLICADORES
	
	multiplic m1(auxX1, auxW1, aux1);
	multiplic m2(auxX2, auxW2, aux2);
	
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
	
   always @ (negedge clkMAC, posedge start) 
	begin
		if(start)
		begin
			atual <= S0;
			oSomaOK <= 1'b0; 
			auxX1 = {(8){1'b0}};
			auxW1 = {(16){1'b0}};
			auxX2 = {(8){1'b0}};
			auxW2 = {(16){1'b0}};
			auxOut1 = {(32){1'b0}};
			i = 5'b00000;
			if (iFlagBias)
				oSoma = {{(6){iBias[15]}}, iBias, {(10){1'b0}}}; 
			else
				oSoma = {(32){1'b0}};
		end
		else
			case (atual)
				S0: 
				begin
					oSomaOK <= 1'b0;
					auxX1 = ix[i];
					auxW1 = iw[i];
					auxX2 = ix[i+1];
					auxW2 = iw[i+1];
					i = i + 5'b00010;
					atual <= S1;
				end
				S1: 
				begin
			      oSomaOK <= 1'b0;
					auxX1 = ix[i];
					auxW1 = iw[i];
					auxX2 = ix[i+1];
					auxW2 = iw[i+1];	
					i = i + 5'b00010;				
					auxOut1 = SomaOverflow(oSoma, auxS); 
					oSoma <= auxOut1;
					if (iQtdEntradas <= (i - 5'b00011))
						atual <= S2;
					else
						atual <= S1;
				end
				S2: 
				begin
					oSomaOK <= 1'b1;
					auxX1 = {(8){1'b0}};
					auxW1 = {(16){1'b0}};
					auxX2 = {(8){1'b0}};
					auxW2 = {(16){1'b0}};
					oSoma <= oSoma;
					atual <= S2;
				end
				default:
				begin
					oSomaOK <= 1'b0;
					auxX1 = {(8){1'b0}};
					auxW1 = {(16){1'b0}};
					auxX2 = {(8){1'b0}};
					auxW2 = {(16){1'b0}};
				end				
			endcase
	end
endmodule

module multiplic(iA, iB, oP);
	input [7:0] iA;
	input [15:0] iB;

	output [31:0] oP;

	wire [15:0] auxA, auxB;
	wire [31:0] auxP; //, cP;
	
	comp2_16 c1(auxA, {iA[7], iA[7], iA[7], iA, 5'b00000}, iA[7]); // complemento de 2 de A
	comp2_16 c2(auxB, iB, iB[15]); // complemento de 2 de B
	
	mul16b m(auxP, auxA, auxB);
	
	comp2 #(.N(32)) c3(oP, auxP, (iA[7] ^ iB[15])); // complemento de 2 do produto
	
endmodule

module mul16b(oP, iA, iB, m5, c); 
	input [15:0] iA, iB;
	output [31:0] oP;
	output [15:0] m5;
	wire [15:0] m1, m2, m3, m4,  m6;
	output c;
	
	mul8b mul1(m1, iA[7:0], iB[7:0]); 
	assign oP[7:0] = m1[7:0];
	mul8b mul2(m2, iA[15:8], iB[7:0]);
	mul8b mul3(m3, iA[7:0], iB[15:8]);
	mul8b mul4(m4, iA[15:8], iB[15:8]);
	
	adder1_16 a1(m5, c, m2, m3); 
	adder2_16 a2(m6, m5, m1[15:8]); 
	assign oP[15:8] = m6[7:0];
	adder3_16 a3(oP[31:16], m4, {c,m6[15:8]}); 
endmodule

module adder1_16(oSoma, oC, iA, iB);
	input [15:0] iA, iB;
	output [15:0] oSoma;
	output oC;
	
	wire [14:0] auxC;
	
	HA h1  (oSoma[0],  auxC[0],  iA[0],    iB[0]);
	FA f1  (oSoma[1],  auxC[1],  auxC[0],  iA[1],  iB[1]);
	FA f2  (oSoma[2],  auxC[2],  auxC[1],  iA[2],  iB[2]);
	FA f3  (oSoma[3],  auxC[3],  auxC[2],  iA[3],  iB[3]);
	FA f4  (oSoma[4],  auxC[4],  auxC[3],  iA[4],  iB[4]);
	FA f5  (oSoma[5],  auxC[5],  auxC[4],  iA[5],  iB[5]);
	FA f6  (oSoma[6],  auxC[6],  auxC[5],  iA[6],  iB[6]);
	FA f7  (oSoma[7],  auxC[7],  auxC[6],  iA[7],  iB[7]);
	FA f8  (oSoma[8],  auxC[8],  auxC[7],  iA[8],  iB[8]);
	FA f9  (oSoma[9],  auxC[9],  auxC[8],  iA[9],  iB[9]);
	FA f10 (oSoma[10], auxC[10], auxC[9],  iA[10], iB[10]);
	FA f11 (oSoma[11], auxC[11], auxC[10], iA[11], iB[11]);
	FA f12 (oSoma[12], auxC[12], auxC[11], iA[12], iB[12]);
	FA f13 (oSoma[13], auxC[13], auxC[12], iA[13], iB[13]);
	FA f14 (oSoma[14], auxC[14], auxC[13], iA[14], iB[14]);
	FA f15 (oSoma[15], oC,       auxC[14], iA[15], iB[15]);
endmodule

module adder2_16(oSoma, iA, iB);
	input [15:0] iA;
	input [7:0] iB;
	output [15:0] oSoma;
	
	wire [14:0] auxC;
	
	HA h1 (oSoma[0],  auxC[0],  iA[0],    iB[0]);
	FA f1 (oSoma[1],  auxC[1],  auxC[0],  iA[1], iB[1]);
	FA f2 (oSoma[2],  auxC[2],  auxC[1],  iA[2], iB[2]);
	FA f3 (oSoma[3],  auxC[3],  auxC[2],  iA[3], iB[3]);
	FA f4 (oSoma[4],  auxC[4],  auxC[3],  iA[4], iB[4]);
	FA f5 (oSoma[5],  auxC[5],  auxC[4],  iA[5], iB[5]);
	FA f6 (oSoma[6],  auxC[6],  auxC[5],  iA[6], iB[6]);
	FA f7 (oSoma[7],  auxC[7],  auxC[6],  iA[7], iB[7]);
	HA h2 (oSoma[8],  auxC[8],  auxC[7],  iA[8]);
	HA h3 (oSoma[9],  auxC[9],  auxC[8],  iA[9]);
	HA h4 (oSoma[10], auxC[10], auxC[9],  iA[10]);
	HA h5 (oSoma[11], auxC[11], auxC[10], iA[11]);
	HA h6 (oSoma[12], auxC[12], auxC[11], iA[12]);
	HA h7 (oSoma[13], auxC[13], auxC[12], iA[13]);
	HA h8 (oSoma[14], auxC[14], auxC[13], iA[14]);
	
	xor x1 (oSoma[15], auxC[14], iA[15]);
	
endmodule

module adder3_16(oSoma, iA, iB);
	input [15:0] iA;
	input [8:0] iB;
	output [15:0] oSoma;
	
	wire [14:0] auxC;
	
	HA h1 (oSoma[0],  auxC[0],  iA[0],    iB[0]);
	FA f1 (oSoma[1],  auxC[1],  auxC[0],  iA[1], iB[1]);
	FA f2 (oSoma[2],  auxC[2],  auxC[1],  iA[2], iB[2]);
	FA f3 (oSoma[3],  auxC[3],  auxC[2],  iA[3], iB[3]);
	FA f4 (oSoma[4],  auxC[4],  auxC[3],  iA[4], iB[4]);
	FA f5 (oSoma[5],  auxC[5],  auxC[4],  iA[5], iB[5]);
	FA f6 (oSoma[6],  auxC[6],  auxC[5],  iA[6], iB[6]);
	FA f7 (oSoma[7],  auxC[7],  auxC[6],  iA[7], iB[7]);
	FA f8 (oSoma[8],  auxC[8],  auxC[7],  iA[8], iB[8]);
	HA h2 (oSoma[9],  auxC[9],  auxC[8],  iA[9]);
	HA h3 (oSoma[10], auxC[10], auxC[9],  iA[10]);
	HA h4 (oSoma[11], auxC[11], auxC[10], iA[11]);
	HA h5 (oSoma[12], auxC[12], auxC[11], iA[12]);
	HA h6 (oSoma[13], auxC[13], auxC[12], iA[13]);
	HA h7 (oSoma[14], auxC[14], auxC[13], iA[14]);
	
	xor x1 (oSoma[15], auxC[14], iA[15]);
	
endmodule

module mul8b(oP, iA, iB);
	input [7:0] iA, iB;
	output [15:0] oP;
	
	wire [7:0] m1, m2, m3, m4, m5, m6;
	wire c;

	mul4b mul1(m1, iA[3:0], iB[3:0]); 
	assign oP[3:0] = m1[3:0];
	mul4b mul2(m2, iA[7:4], iB[3:0]);
	mul4b mul3(m3, iA[3:0], iB[7:4]);
	mul4b mul4(m4, iA[7:4], iB[7:4]);
	
	adder1_8 a1(m5, c, m2, m3); 
	adder2_8 a2(m6, m5, m1[7:4]); 
	assign oP[7:4] = m6[3:0];
	adder3_8 a3(oP[15:8], m4, {c,m6[7:4]}); 
endmodule

module adder1_8(oSoma, oC, iA, iB);
	input [7:0] iA, iB;
	output [7:0] oSoma;
	output oC;
	
	wire [6:0] auxC;
	
	HA h1(oSoma[0], auxC[0], iA[0], iB[0]);
	FA f1(oSoma[1], auxC[1], auxC[0], iA[1], iB[1]);
	FA f2(oSoma[2], auxC[2], auxC[1], iA[2], iB[2]);
	FA f3(oSoma[3], auxC[3], auxC[2], iA[3], iB[3]);
	FA f4(oSoma[4], auxC[4], auxC[3], iA[4], iB[4]);
	FA f5(oSoma[5], auxC[5], auxC[4], iA[5], iB[5]);
	FA f6(oSoma[6], auxC[6], auxC[5], iA[6], iB[6]);
	FA f7(oSoma[7], oC, auxC[6], iA[7], iB[7]);
endmodule

module adder2_8(oSoma, iA, iB);
	input [7:0] iA;
	input [3:0] iB;
	output [7:0] oSoma;
	
	wire [6:0] auxC;
	
	HA h1(oSoma[0], auxC[0], iA[0], iB[0]);
	FA f1(oSoma[1], auxC[1], auxC[0], iA[1], iB[1]);
	FA f2(oSoma[2], auxC[2], auxC[1], iA[2], iB[2]);
	FA f3(oSoma[3], auxC[3], auxC[2], iA[3], iB[3]);
	HA h2(oSoma[4], auxC[4], auxC[3], iA[4]);
	HA h3(oSoma[5], auxC[5], auxC[4], iA[5]);
	HA h4(oSoma[6], auxC[6], auxC[5], iA[6]);
	xor x1(oSoma[7], auxC[6], iA[7]);
	
endmodule

module adder3_8(oSoma, iA, iB);
	input [7:0] iA;
	input [4:0] iB;
	output [7:0] oSoma;
	
	wire [6:0] auxC;
	
	HA h1(oSoma[0], auxC[0], iA[0], iB[0]);
	FA f1(oSoma[1], auxC[1], auxC[0], iA[1], iB[1]);
	FA f2(oSoma[2], auxC[2], auxC[1], iA[2], iB[2]);
	FA f3(oSoma[3], auxC[3], auxC[2], iA[3], iB[3]);
	FA f4(oSoma[4], auxC[4], auxC[3], iA[4], iB[4]);
	HA h2(oSoma[5], auxC[5], auxC[4], iA[5]);
	HA h3(oSoma[6], auxC[6], auxC[5], iA[6]);
	xor x1(oSoma[7], auxC[6], iA[7]);
	
endmodule

module mul4b(oP, iA, iB);
	output [7:0] oP;
	input [3:0] iA, iB;
	
	wire s1, s2, s3, s4, s5, s6, s7, s8, s9, s10;
	wire aux1, aux2, aux3, aux4, aux5, aux6, aux7, aux8, aux9, aux10, aux11, aux12, aux13, aux14, aux15;
	wire c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13;
	
	// P0
	and a00(oP[0], iA[0], iB[0]);
	
	// P1
	xor x00(oP[1], (iA[0] & iB[1]), (iA[1] & iB[0]));
	
	// P2
	and a01(s1, iA[0], iA[1], iB[0], iB[1]);
	and a02(s2, iA[2], iB[0]);
	and a03(s3, iA[1], iB[1]);
	and a04(s4, iA[0], iB[2]);
	HA h01(aux1, c1, s4, s3);
	HA h02(aux2, c2, s2, s1);
	HA h03(oP[2], c3, aux1, aux2);
	
	// P3
	HA h04(s6, c5, (iA[0] & iB[3]), (iA[1] & iB[2]));
	HA h05(s5, c4, (iA[3] & iB[0]), (iA[2] & iB[1]));
	HA h06(aux3, c6, s5, s6);
	xor x01(s7, c1, c2, c3);
	HA h07(oP[3], c7, aux3, s7);
	
	// P4
	HA h08(s9, c9, (iA[2] & iB[2]), (iA[3] & iB[1]));
	HA h09(s8, c8, (s1 & s2 & s3 & s4), (iA[1] & iB[3]));
	HA h10(aux4, c10, s8, s9);
	xor x02(s10, c4, c5, c6, c7);
	HA h11(oP[4], c11, aux4, s10);
	
	// P5
	or o00(aux5, (c4 & c5), (c4 & s6 & s7), (s7 & c5 & s5));
	xor x03(aux6, (iA[3] & iB[2]), (iA[2] & iB[3]));
	HA h12(aux7, c12, aux5, aux6);
	HA h13(oP[5], c13, aux7, (c8 ^ c9 ^ c10 ^ c11));
	
	// P6 e P7
	HA h14(aux12, aux13, (iA[3] & iB[3]), (iA[2] & iB[2] & iA[3] & iB[3]));
	HA h15(aux11, aux14, c12, aux12);
	or o01(aux8, (c8 & c9), (c8 & s9 & s10), (s10 & c9 & s8));
	HA h16(aux9, aux10, aux11, aux8);
	HA h17(oP[6], aux15, aux9, c13);
	or o02(oP[7], aux15, (aux10 | (aux13 | aux14)));
endmodule

module HA(sum, c_out, x, y);  
   input x, y;
   output sum, c_out;
	
   assign {c_out, sum} = x + y;
	
endmodule 

module FA(sum, c_out, c_in, x, y);  
   input x, y, c_in;
   output sum, c_out;
	
   assign {c_out, sum} = x + y + c_in;
	
endmodule

module comp2_16(oC, iE, iCtrl);
	input iCtrl;
	input [15:0] iE;
	output reg [15:0] oC;
	
	always @(iE)
	begin
		if (iCtrl)
			oC = (iE ^ 16'b1111111111111111) + 1'b1;
		else
			oC = iE;
	end
endmodule
