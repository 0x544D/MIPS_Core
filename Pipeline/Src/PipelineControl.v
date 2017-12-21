/* 	Author: Tobias Minn
	MIPS Pipeline Processor

	Pipeline Control		
*/
module PipelineControl #(parameter WIDTH = 32) (
	input			clk, reset,
	input 			Equal_D,
	input	[5:0]	Opcode, Funct,
	// Decode Stage
	output			PCSrc_D, Branch_D,
	// Execution Stage
	output			RegDst_E, ALUSrc_E, MemToReg_E, RegWrite_E,
	output	[2:0]	ALU_Control_E,
	// Memory Stage
	output			MemWrite_M, MemToReg_M, RegWrite_M, 
	// Write-back Stage
	output			MemToReg_W, RegWrite_W);


	/**** Signals ****/
	// Decode Stage
	wire 			RegWrite_D, MemToReg_D, MemWrite_D, ALUSrc_D, RegDst_D, MemRead_D, Jump_D;
	wire 	[2:0]	ALU_Control_D;

	// Execution Stage
	wire 			MemWrite_E;


	// instatiate MIPS Control
	MIPSControl #(32) PipeControl(Opcode, Funct, RegDst_D, Branch_D, MemRead_D, MemToReg_D, MemWrite_D, ALUSrc_D, RegWrite_D, Jump_D, ALU_Control_D);

	// instantiate Pipeline Control registers
	ffre #(8) ID_EX_Control_reg({RegWrite_D, MemToReg_D, MemWrite_D, ALU_Control_D, ALUSrc_D, RegDst_D}, clk, reset, 1'h1, {RegWrite_E, MemToReg_E, MemWrite_E, ALU_Control_E, ALUSrc_E, RegDst_E});

	ffre #(3) EX_MEM_Control_reg({RegWrite_E, MemToReg_E, MemWrite_E}, clk, reset, 1'h1, {RegWrite_M, MemToReg_M, MemWrite_M});

	ffre #(2) MEM_WB_Control_reg({RegWrite_M, MemToReg_M}, clk, reset, 1'h1, {RegWrite_W, MemToReg_W});

	// assign outputs
	assign PCSrc_D = (Branch_D & Equal_D);

endmodule