`timescale 1ns/1ns
/*********************************************
 *
 * File: alu_real_delay_random.v
 * 
 * Made by: Matthew Strozyk
 *
 * *******************************************/


//All gates, wires, inputs, and outputs are labeled on the given diagrams


//Single-bit ALU
module oneBitALU(a, b, cin, less, cout, op[2:0], out, zero);

	input a, b, cin, less;
	input [2:0] op;
	output cout, out, zero;
	wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13;
	wire invop1, invop0, sub, sub1, binv, bnew;
	
	not #1
	   g2(binv, b),
	   g3(sub1, sub),
	   g22(invop1, op[1]),
	   g23(invop0, op[0]),
	   g25(zero, w9);
	or #2
	   g1(sub, op[2], op[0]),
	   g6(bnew, w1, w2),
	   g8(w4, b, a),
	   g13(cout, w6, w7, w8),
	   g18(out, w10, w11, w12, w13);
	and #2
	   g4(w1, sub1, b),
	   g5(w2, sub, binv),
	   g7(w3, a, b),
	   g10(w6, a, cin),
	   g11(w7, bnew, cin),
	   g12(w8, bnew, a),
	   g15(w9, sum, 0),
	   g16(w10, w3, invop1, invop0),
	   g17(w11, w4, op[0], invop1),
	   g19(w12, sum, invop0, op[1]),
	   g20(w13, less, op[0], op[1]); 
	xor #3
	   g9(w5, a, bnew),
	   g14(sum, w5, cin),
	   g24(w9, a, b);

endmodule


//Four-bit ALU works by using 4 1-bit ALU's
module fourBitALU(a, b, cin, less, cout, op, out, zero, cov);

	input [3:0] a, b;
	output [3:0] out;
	input cin, less;
	input [2:0] op;
	output cout, zero, cov;
	wire [1:0] c;
	wire z1, z2, z3, z4;

	//Computes zero signal at the 1-bit ALU level
	and #2
	   g0(zero, z1, z2, z3, z4);

	oneBitALU a0 (a[0], b[0], cin, less, c[0], op[2:0], out[0], z1);
	oneBitALU a1 (a[1], b[1], c[0], 0, c[1], op[2:0], out[1], z2);
	oneBitALU a2 (a[2], b[2], c[1], 0, cov, op[2:0], out[2], z3);
	oneBitALU a3 (a[3], b[3], cov, 0, cout, op[2:0], out[3], z4);

endmodule

//16-bit ALU works by using 4 4-bit ALU's
module sixteenBitALU(a, b, cin, less, cout, op, out, zero, cov);

	input [15:0] a, b;
	output [15:0] out;
	input cin, less;
	input [2:0] op;
	output cout, zero, cov;
	wire [2:0] c;
	wire z1, z2, z3, z4, dc1, dc2, dc3;

	//Computes zero signal at the 4-bit ALU level
	and #2
	   g0(zero, z1, z2, z3, z4);

	fourBitALU a0 (a[3:0], b[3:0], cin, less, c[0], op[2:0], out[3:0], z1, dc1);
	fourBitALU a1 (a[7:4], b[7:4], c[0], 0, c[1], op[2:0], out[7:4], z2, dc2);
	fourBitALU a2 (a[11:8], b[11:8], c[1], 0, c[2], op[2:0], out[11:8], z3, dc3);
	fourBitALU a3 (a[15:12], b[15:12], c[2], 0, cout, op[2:0], out[15:12], z4, cov);

endmodule

//The complete ALU uses two 16-bit ALU's to perform instructions
module completeALU(a, b, op, out, zero, over);

	input [31:0] a, b;
	input [2:0] op;
	output [31:0] out;
	output cout, zero, over;
	wire c, w1, w2, w3, w4, w5, w6, w7, w8, w9, z1, z2, set, dc, cov;
	
	//Used for logic outside the 1-bit ALU's. This is to compute 
	//the zero and overflow signals
	not #1
	    g3(w4, w2),
	    g4(w5, w3),
	    g5(over, w8),
	    g11(w9, w6);
	or  #2
	    g6(w2, a[31], b[31]),
	    g7(w6, w5, cov),
	    g8(w8, w7, w9);
	xor #3
	    g1(w1, op[2], op[0]),
	    g2(set, out[31], over);
	and #2
	    g0(zero, z1, z2),
	    g9(w3, a[31], b[31]),
	    g10(w7, w4, cov);
	
	
	sixteenBitALU a0 (a[15:0], b[15:0], w1, set, c, op[2:0], out[15:0], z1, dc);
	sixteenBitALU a1 (a[31:16], b[31:16], c, 0, cout, op[2:0], out[31:16], z2, cov);

	
endmodule

module testbench();

	reg cin;
	reg [2:0] op;
	reg [31:0] a, b;
	output [31:0] out;
	wire cout, zero, less, over;
	integer i, _and, _or, add, sub, slt;

	completeALU ca (a, b, op[2:0], out, zero, over);

	initial
	  begin
	    _and=0;
	    _or=0;
	    add=0;
	    sub=0;
	    slt=0;
//	    for(i=0; i<5000; i=i+1) begin
	    while( (sub+slt+add+_and+_or) < 5000) begin	

            $monitor($time,, "op= %d , out=%d", op, out);
            $display($time,, "op= %d , out=%d", op, out);
		a=$random;
	  	b=$random;
		op=$random;

			if(op==0)begin
			   _and=_and+1;
		end	if(op==1)begin
		   	   _or=_or+1;
		end     if(op==2)begin
	 	   	   add=add+1;
		end	if(op==3)begin
	   	   	   slt=slt+1;
		end	if(op==6)begin
		   	   sub=sub+1;
		end
	#200;
	end
	$display("and=%d, or=%d, add=%d, sub=%d, slt=%d", _and, _or, add, sub, slt);
	end
endmodule

