module unidadeClock(clk, rst, clk_3);
	input rst, clk;
	output clk_3;
	reg clk_2;
	
	wire d0, q0, d1, q1, d, q, nq0, nq1;
	
	ffd f1(clk, rst, d0, q0);
	ffd f2(clk, rst, d1, q1);
	ffd f3(~clk, rst, d, q);
	
	and a1(d0, nq0, nq1);
	or o1(clk_3, q, d);
	
	assign nq0 = ~q0;
	assign nq1 = ~q1;
	assign d1 = q0;
	assign d = q1;
	
endmodule

module ffd(clk, rst, d, q);
	input rst, clk, d;
	output reg q;
	
	always@(posedge clk, negedge rst)
	begin
		if(~rst)
			q = 1'b0;
		else
			q = d;
	end
	
endmodule

