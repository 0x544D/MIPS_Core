/*	Author: Tobias Minn
	mux8 design using 2 mux4 and one mux2
*/

module mux8 #(parameter WIDTH = 32) (
	input	[WIDTH-1:0] 	in0, in1, in2, in3, in4, in5, in6, in7,
	input	[2:0]			sel,
	output	[WIDTH-1:0]		out);

	wire [WIDTH-1:0] lowMUX_out, highMUX_out;
	
	mux4 #(WIDTH) lowMUX(in0, in1, in2, in3, sel[1:0], lowMUX_out);
	mux4 #(WIDTH) highMUX(in4, in5, in6, in7, sel[1:0], highMUX_out);
	mux2 #(WIDTH) finalMUX(lowMUX_out, highMUX_out, sel[2], out);

endmodule