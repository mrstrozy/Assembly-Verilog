`timescale 1ns/1ns
/*********************************************
 *
 * File: alu_zero.v
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
	
	not 
	   g2(binv, b),
	   g3(sub1, sub),
	   g22(invop1, op[1]),
	   g23(invop0, op[0]),
	   g25(zero, w9);
	or 
	   g1(sub, op[2], op[0]),
	   g6(bnew, w1, w2),
	   g8(w4, b, a),
	   g13(cout, w6, w7, w8),
	   g18(out, w10, w11, w12, w13);
	and 
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
	xor 
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
	and 
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
	and 
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
	not 
	    g3(w4, w2),
	    g4(w5, w3),
	    g5(over, w8),
	    g11(w9, w6);
	or  
	    g6(w2, a[31], b[31]),
	    g7(w6, w5, cov),
	    g8(w8, w7, w9);
	xor 
	    g1(w1, op[2], op[0]),
	    g2(set, out[31], over);
	and 
	    g0(zero, z1, z2),
	    g9(w3, a[31], b[31]),
	    g10(w7, w4, cov);
	
	
	sixteenBitALU a0 (a[15:0], b[15:0], w1, set, c, op[2:0], out[15:0], z1, dc);
	sixteenBitALU a1 (a[31:16], b[31:16], c, 0, cout, op[2:0], out[31:16], z2, cov);

	
endmodule

module testbench();


	reg [31:0] a, b;
	reg [2:0] op;
	reg cin, cout;
	output [31:0] out;
	output  zero, over;

	completeALU compa (a, b, op, out, zero, over);	

	initial
	  begin

	    $monitor($time,, "a=%d, b=%d, cout=%b, op=%d, out=%d, zero=%b, over=%b",
								a, b, cout, op, out, zero, over);
	    $display($time,, "a=%d, b=%d, cout=%b, op=%d, out=%d, zero=%b, over=%b",
 								a, b, cout, op, out, zero, over);

	    //logic test for "AND"
	    #1000   a=0; b=0; cin=0; op=0; //zero tested
            #1000   a=0; b=0; cin=0; op=0; //zero tested
            #1000   a=0; b=1; cin=0; op=0;
            #1000   a=0; b=1; cin=0; op=0;
            #1000   a=1; b=0; cin=0; op=0;
            #1000   a=1; b=0; cin=0; op=0;
            #1000   a=1; b=1; cin=0; op=0;  //zero tested
            #1000   a=1; b=1; cin=0; op=0;  //zero tested

	    //logic test for "OR"
	    #1000   a=0; b=0; cin=0; op=1; //zero tested
            #1000   a=0; b=0; cin=0; op=1; //zero tested
            #1000   a=0; b=1; cin=0; op=1;
            #1000   a=0; b=1; cin=0; op=1;
            #1000   a=1; b=0; cin=0; op=1;
            #1000   a=1; b=0; cin=0; op=1; 
            #1000   a=1; b=1; cin=0; op=1; //zero tested
            #1000   a=1; b=1; cin=0; op=1; //zero tested

	    //logic test for "ADD"
            #1000   a=25; b=23; cin=0; op=2;
            #1000   a=256; b=10000; cin=0; op=2;           
	    #1000   a=2468; b=333; cin=0; op=2;
            #1000   a=429496729; b=111111111; cin=0; op=2;
            #1000   a=8665; b=1335; cin=0; op=2;
	    #1000   a=1123; b=343; cin=0; op=2;
            #1000   a=22367; b=88; cin=0; op=2;
            #1000   a=99786; b=96; cin=0; op=2;

	    //logic test for "SUB"
            #1000   a=555; b=5; cin=0; op=6;
            #1000   a=1; b=34; cin=0; op=6; //overflow test
            #1000   a=30; b=32454; cin=0; op=6; //overflow test
            #1000   a=1111; b=1102; cin=0; op=6;
            #1000   a=333; b=300; cin=0; op=6;
            #1000   a=4342394; b=2000000; cin=0; op=6;
            #1000   a=1000000; b=999999; cin=0; op=6;
            #1000   a=1123212; b=11312; cin=0; op=6;

	    //logic test for "SLT"
            #1000   a=0; b=25; cin=0; op=3; //overflow test
            #1000   a=0; b=0; cin=0; op=3;
            #1000   a=123; b=122; cin=0; op=3;
            #1000   a=555; b=555; cin=0; op=3; //zero tested 
            #1000   a=1; b=23; cin=0; op=3; //overflow test
            #1000   a=250; b=246; cin=0; op=3;
            #1000   a=250; b=500; cin=0; op=3; //overflow test
            #1000   a=32; b=32; cin=0; op=3; //zero tested
	    #1000
	    $display($time,, "a=%d, b=%d, cout=%b, op=%d, out=%d, zero=%b",
                                                         a, b, cout, op, out, zero); 
	    end
endmodule
