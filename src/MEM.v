/* 	Author: Tobias Minn
	MIPS Pipeline Processor

	Memory Stage (MEM)
		
*/
module MEM #(parameter WIDTH = 32)(
	input					clk, MemWrite_M,
	input	[WIDTH-1:0]		ALUOut_M, WriteData_M,
	output	[WIDTH-1:0]		ReadData_M);


	// instantiate data memory
	dmem datamemory(clk, MemWrite_M, ALUOut_M, WriteData_M, ReadData_M);

endmodule