/*	Author: Tobias Minn
	mux4 design using 3 mux2
*/

module mux4 #(parameter WIDTH = 32) (
	input	[WIDTH-1:0] 	in0, in1, in2, in3,
	input	[1:0]			sel,
	output	[WIDTH-1:0]		out);

	wire [WIDTH-1:0] lowMUX_out, highMUX_out;
	
	mux2 #(WIDTH) lowMUX(in0, in1, sel[0], lowMUX_out);
	mux2 #(WIDTH) highMUX(in2, in3, sel[0], highMUX_out);
	mux2 #(WIDTH) finalMUX(lowMUX_out, highMUX_out, sel[1], out);

endmodule