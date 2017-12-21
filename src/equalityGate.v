/* 	Author: Tobias Minn
	MIPS Pipeline Processor

	Equality Gate
		
*/
module equalityGate #(parameter WIDTH = 32)(
	input	[WIDTH-1:0] 	A, B,
	output					Out);

	assign Out = (A == B) ? 1'h1 : 1'h0;

endmodule