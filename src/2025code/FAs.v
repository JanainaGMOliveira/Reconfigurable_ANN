module degrau_bipolar(
	output [7:0] oS,
	input signed [31:0] iA
);	
	assign oS = iA[31] ? 8'b111_00000 : 8'b001_00000;
endmodule

module rampa(
	output [7:0] oS,
	input signed [31:0] iA
);
	reg [7:0] auxS;
	assign oS = auxS;

	always @(*)
	begin
		// menor que -4
		if (iA <= $signed(32'b111111111100_00000000000000000000))
			auxS = 8'b100_00000; 
		// maior que 3,96875
		else if (iA >= $signed(32'b000000000100_00000000000000000000))
			auxS = 8'b011_11111; 
		// entre -4 e 3,96875
		else 
			auxS = iA[22:15];
	end
endmodule

module sigm(
	output [7:0] oS,
	input [31:0] iA
);
	reg [7:0] auxS;
	assign oS = auxS;

	wire [31:0] cA;
	reg [7:0] sai;
	
	twosComplement #(.N(32)) c1(cA, iA, iA[31]); 
	
	always@(*)
	begin
		if (cA >= 32'b000000000000_00000000000000000000 & cA < 32'b000000000001_00000000000000000000)
		begin
			sai[7:3] = 5'b00010;
			sai[2:0] = cA[19:17];
			if (iA[31])
				auxS = 8'b00100000 - sai;
			else
				auxS = sai;
		end
		else if (cA >= 32'b000000000001_00000000000000000000 & cA < 32'b000000000010_01100000000000000000)
		begin
			sai[7:3] = 5'b00011;
			sai[2] = ~cA[20];
			sai[1:0] = cA[19:18];
			if (iA[31])
				auxS = 8'b00100000 - sai;
			else
				auxS = sai;
		end
		else if (cA >= 32'b000000000010_01100000000000000000 & cA < 32'b000000000101_00000000000000000000)
		begin
			sai[7:2] = 6'b000111;
			sai[1] = ~cA[21] | cA[20];
			sai[0] = ~cA[20];
			if (iA[31])
				auxS = 8'b00100000 - sai;
			else
				auxS = sai;
		end
		else if (cA >= 32'b000000000101_00000000000000000000)
		begin
			sai = 8'b00100000;
			if (iA[31])
				auxS = 8'b00000000;
			else
				auxS = sai;
		end
	end

	
endmodule

module tanh(
	output [7:0] oS,
	input [31:0] iA
);
	reg [7:0] auxS;
	assign oS = auxS;

	wire [31:0] cA;
	reg [7:0] sai;
	
	twosComplement #(.N(32)) c1(cA, iA, iA[31]); 
	
	always@(*)
	begin
		if(cA >= 32'b000000000000_00000000000000000000 & cA < 32'b000000000000_10000000000000000000)
		begin
			sai = cA[22:15];
			if (iA[31])
				auxS = (sai ^ {8{1'b1}}) + 1'b1;
			else
				auxS = sai;
		end
		else if(cA >= 32'b000000000000_10000000000000000000 & cA < 32'b000000000001_00000000000000000000)
		begin
			sai[7:3] = 5'b00010;
			sai[2:0] = cA[18:16];
			if (iA[31])
				auxS = (sai ^ {8{1'b1}}) + 1'b1;
			else
				auxS = sai;
		end
		else if(cA >= 32'b000000000001_00000000000000000000 & cA < 32'b000000000010_00000000000000000000)
		begin
			sai[7:3] = 5'b00011;
			sai[2:0] = cA[19:17];
			if (iA[31])
				auxS = (sai ^ {8{1'b1}}) + 1'b1;
			else
				auxS = sai;
		end
		else if(cA >= 32'b000000000010_00000000000000000000)
		begin
			sai = 8'b001_00000;
			if (iA[31])
				auxS = 8'b111_00000;
			else
				auxS = sai;
		end
	end
	
endmodule