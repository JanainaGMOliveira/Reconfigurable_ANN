module degrau_bipolar(iA, oS);
	
	input signed [31:0] iA;
	output reg [7:0] oS;
	
	always@(iA)
	begin
		if (iA[31]) 
			oS = 8'b11100000; 
		else
			oS = 8'b00100000; 
	end
endmodule

module rampa(iA, oS);
	
	input signed [31:0] iA;
	output reg [7:0] oS;
	
	always @(iA)
	begin
		// menor que -4
		if (iA <= $signed(32'b111111111100_00000000000000000000))
			oS = 8'b10000000; 
		// maior que 3,96875
		else if (iA >= $signed(32'b000000000100_00000000000000000000))
			oS = 8'b01111111; 
		// entre -4 e 3,96875
		else 
			oS = iA[22:15];
	end
endmodule

module sig(iA, oS);
	input [31:0] iA;
	output reg [7:0] oS;

	wire [31:0] cA;
	reg [7:0] sai;
	
	comp2 #(.N(32)) c1(cA, iA, iA[31]); 
	
	always@(iA, cA)
	begin
		if (cA >= 32'b000000000000_00000000000000000000 & cA < 32'b000000000001_00000000000000000000)
		begin
			sai[7:3] = 5'b00010;
			sai[2:0] = cA[19:17];
			if (iA[31])
				oS = 8'b00100000 - sai;
			else
				oS = sai;
		end
		else if (cA >= 32'b000000000001_00000000000000000000 & cA < 32'b000000000010_01100000000000000000)
		begin
			sai[7:3] = 5'b00011;
			sai[2] = ~cA[20];
			sai[1:0] = cA[19:18];
			if (iA[31])
				oS = 8'b00100000 - sai;
			else
				oS = sai;
		end
		else if (cA >= 32'b000000000010_01100000000000000000 & cA < 32'b000000000101_00000000000000000000)
		begin
			sai[7:2] = 6'b000111;
			sai[1] = ~cA[21] | cA[20];
			sai[0] = ~cA[20];
			if (iA[31])
				oS = 8'b00100000 - sai;
			else
				oS = sai;
		end
		else if (cA >= 32'b000000000101_00000000000000000000)
		begin
			sai = 8'b00100000;
			if (iA[31])
				oS = 8'b00000000;
			else
				oS = sai;
		end
	end

	
endmodule

module tanh(iA, oS);
	input [31:0] iA;
	output reg [7:0] oS;

	wire [31:0] cA;
	reg [7:0] sai;
	
	comp2 #(.N(32)) c1(cA, iA, iA[31]); 
	
	always@(iA, cA)
	begin
		if(cA >= 32'b000000000000_00000000000000000000 & cA < 32'b000000000000_10000000000000000000)
		begin
			sai = cA[22:15];
			if (iA[31])
				oS = (sai ^ {8{1'b1}}) + 1'b1;
			else
				oS = sai;
		end
		else if(cA >= 32'b000000000000_10000000000000000000 & cA < 32'b000000000001_00000000000000000000)
		begin
			sai[7:3] = 5'b00010;
			sai[2:0] = cA[18:16];
			if (iA[31])
				oS = (sai ^ {8{1'b1}}) + 1'b1;
			else
				oS = sai;
		end
		else if(cA >= 32'b000000000001_00000000000000000000 & cA < 32'b000000000010_00000000000000000000)
		begin
			sai[7:3] = 5'b00011;
			sai[2:0] = cA[19:17];
			if (iA[31])
				oS = (sai ^ {8{1'b1}}) + 1'b1;
			else
				oS = sai;
		end
		else if(cA >= 32'b000000000010_00000000000000000000)
		begin
			sai = 8'b001_00000;
			if (iA[31])
				oS = 8'b111_00000;
			else
				oS = sai;
		end
	end
	
endmodule

module comp2(oC, iE, iCtrl);
	
	parameter N = 3; 
	
	input [N-1:0] iE;
	input iCtrl;
	output reg [N-1:0] oC;
	
	always @(iE, iCtrl)
	begin
		if (iCtrl)
			oC = (iE ^ {N{1'b1}}) + 1'b1;
		else
			oC = iE;
	end	
endmodule
