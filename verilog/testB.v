`timescale 1ns/1ns

module ander(a, b, out);

input [1:0] a, b;
output [1:0]  out;


endmodule

module testbench();

	reg a;
	reg b;
	wire out;
	
	ander test (a, b, out);

	initial
	  begin
	    $monitor($time,, "a=%b, b=%b, out=%b", a, b, out);
	    $display($time,, "a=%b, b=%b, out=%b", a, b, out);
	    #100   a=0; b=0; 
	    #100   a=1; b=0;
	    #100   a=0; b=1;
	    #100   a=1; b=1;
            #100
	    $display($time,, "a=%b, b=%b, out=%b", a, b, out);
	end

endmodule
