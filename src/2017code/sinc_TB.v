`timescale 1ns/1ps 
module sinc_TB;

	reg clk, rst, start;
	reg [7:0] ix1, ix2, ix3, ix4, ix5, ix6, ix7, ix8, ix9, ix10;
	reg [7:0] ix11, ix12, ix13, ix14, ix15, ix16, ix17, ix18, ix19, ix20;
	reg [9:0] instrucao;
	reg flagInst;

	wire oFlagRede;
	wire [7:0] oR1, oR2, oR3, oR4, oR5, oR6, oR7, oR8, oR9, oR10;
	wire [7:0] oR11, oR12, oR13, oR14, oR15, oR16, oR17, oR18, oR19, oR20;
	
	
	redeGeral r(clk, rst, start, 
					instrucao, 
					flagInst, 
					ix1, ix2, ix3, ix4, ix5, ix6, ix7, ix8, ix9, ix10, ix11, ix12, ix13, ix14, ix15, ix16, ix17, ix18, ix19, ix20, 
					oR1, oR2, oR3, oR4, oR5, oR6, oR7, oR8, oR9, oR10, oR11, oR12, oR13, oR14, oR15, oR16, oR17, oR18, oR19, oR20, 
					oFlagRede
					);
					 
initial 
begin
	clk = 1'b0;
	rst = 1'b0;
	start = 1'b1;
	flagInst = 1'b1;
	instrucao = 10'b00_00000_0_00;
		
	ix1 = 8'b00000000; 
	
	ix2 = 8'b00000000; ix3 = 8'b00000000; ix4 = 8'b00000000; ix5 = 8'b00000000; ix6 = 8'b00000000; ix7 = 8'b00000000; ix8 = 8'b00000000; ix9 = 8'b00000000; ix10 = 8'b00000000; 
	ix11 = 8'b00000000; ix12 = 8'b00000000; ix13 = 8'b00000000; ix14 = 8'b00000000; ix15 = 8'b00000000; ix16 = 8'b00000000; ix17 = 8'b00000000; ix18 = 8'b00000000; ix19 = 8'b00000000; ix20 = 8'b00000000; 
	
	#50 rst = 1'b1; 
		
	#40 flagInst = 1'b0; // captura a primeira
		
	#40 flagInst = 1'b1;
	instrucao = 10'b10_01100_1_11;
		
	#40 flagInst = 1'b0; // captura a segunda
		
	#40 flagInst = 1'b1;
	instrucao = 10'b11_00000_1_01;
		
	#40 flagInst = 1'b0; // captura a terceira
	#40 flagInst = 1'b1;
   
	
	#4800 start = 1'b0; ix1 = 8'b00011011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10000010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10000011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10000100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10000101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10000110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10000111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10001000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10001001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10001010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10001011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10001100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10001101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10001110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10001111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10010000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10010001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10010010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10010011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10010100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10010101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10010110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10010111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10011000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10011001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10011010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10011011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10011100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10011101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10011110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10011111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10100000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10100001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10100010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10100011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10100100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10100101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10100110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10100111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10101000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10101001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10101010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10101011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10101100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10101101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10101110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10101111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10110000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10110001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10110010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10110011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10110100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10110101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10110110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10110111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10111000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10111001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10111010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10111011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10111100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10111101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10111110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b10111111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11000000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11000001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11000010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11000011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11000100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11000101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11000110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11000111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11001000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11001001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11001010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11001011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11001100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11001101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11001110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11001111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11010000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11010001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11010010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11010011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11010100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11010101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11010110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11010111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11011000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11011001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11011010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11011011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11011100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11011101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11011110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11011111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11100000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11100001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11100010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11100011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11100100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11100101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11100110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11100111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11101000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11101001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11101010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11101011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11101100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11101101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11101110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11101111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11110000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11110001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11110010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11110011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11110100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11110101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11110110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11110111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11111000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11111001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11111010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11111011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11111100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11111101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11111110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b11111111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00000000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00000001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00000010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00000011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00000100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00000101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00000110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00000111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00001000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00001001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00001010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00001011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00001100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00001101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00001110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00001111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00010000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00010001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00010010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00010011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00010100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00010101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00010110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00010111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00011000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00011001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00011010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00011011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00011100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00011101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00011110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00011111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00100000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00100001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00100010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00100011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00100100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00100101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00100110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00100111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00101000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00101001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00101010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00101011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00101100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00101101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00101110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00101111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00110000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00110001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00110010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00110011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00110100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00110101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00110110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00110111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00111000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00111001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00111010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00111011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00111100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00111101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00111110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b00111111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01000000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01000001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01000010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01000011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01000100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01000101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01000110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01000111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01001000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01001001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01001010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01001011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01001100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01001101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01001110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01001111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01010000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01010001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01010010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01010011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01010100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01010101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01010110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01010111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01011000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01011001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01011010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01011011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01011100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01011101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01011110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01011111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01100000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01100001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01100010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01100011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01100100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01100101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01100110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01100111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01101000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01101001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01101010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01101011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01101100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01101101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01101110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01101111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01110000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01110001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01110010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01110011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01110100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01110101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01110110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01110111; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01111000; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01111001; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01111010; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01111011; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01111100; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01111101; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01111110; #40 start = 1'b1;
	#4800 start = 1'b0; ix1 = 8'b01111111; #40 start = 1'b1;

	#4800 $stop;
end
	
	always
	begin
		#20 clk = 1'b1;
		#20 clk = 1'b0;
	end
	
endmodule
