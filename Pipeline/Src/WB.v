/* 	Author: Tobias Minn
	MIPS Pipeline Processor

	Write Back Stage (WB)
		
*/
module WB #(parameter WIDTH = 32)(
	input				MemToReg_W,
	input	[WIDTH-1:0]	ReadData_W, ALUOut_W,
	output	[WIDTH-1:0]	Result_W	);

	// instantiate MemToReg MUX
	mux2 #(32) MemToReg_MUX(ALUOut_W, ReadData_W, MemToReg_W, Result_W);

endmodule