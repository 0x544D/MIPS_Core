/* 	Author: Tobias Minn
	MIPS Multicycle
	
*/
module MIPSMulticycle #(parameter WIDTH=32)	(
	input 				clk,
	input 				reset,
	output	[31:0]		readdata, aluresult,
	output 				memwrite
);

	/* local signals */
	wire PCWriteCond, PCWrite, IorD, IRWrite, RegDst, MemRead, MemToReg, MemWrite, ALUSrcA, RegWrite;

	wire [1:0] ALUSrcB, PCSource;

	wire [2:0] ALUControl;

	wire [5:0] Opcode, Funct;
	
	wire [WIDTH-1:0] MemData_Signal, MemoryAddress, MemoryWriteData;
	
	// instantiate Datapath
	MIPSMulticycleDatapath #(32) MCDatapath(clk, reset, MemData_Signal, PCWrite, PCWriteCond, IorD, IRWrite, RegDst, MemToReg, MemWrite, ALUSrcA, ALUSrcB, PCSource, RegWrite, ALUControl, MemoryAddress, MemoryWriteData, Opcode, Funct);

	// instantiate Controlpath
	MIPSControl #(32) MCControl(clk, reset, Opcode, Funct, IorD, IRWrite, RegDst, MemRead, MemToReg, MemWrite, ALUSrcA, ALUSrcB, RegWrite, ALUControl, PCSource, PCWrite, PCWriteCond);
	
	// instantiate unified Memory
	MCmem #(32) mem(clk, MemoryAddress, MemoryWriteData, MemRead, MemWrite, MemData_Signal);

	assign memwrite = MemWrite;
	assign aluresult = MemoryAddress;
	assign readdata = MemoryWriteData;
    
endmodule