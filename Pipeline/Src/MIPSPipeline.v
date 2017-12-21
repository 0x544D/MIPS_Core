/* Author: Tobias Minn
	MIPS Singlecycle
	
	
*/
module MIPSPipeline #(parameter WIDTH=32)	(
	input 				clk,
	input 				reset,
	output				MemWrite,
	output	[WIDTH-1:0] ALUOut, WriteData
);

	/**** Signals ****/
	
	// Fetch Stage
	wire 		Stall_F;

	// Decode Stage
	wire 		Branch_D, Equal_D, PCSrc_D, Stall_D, ForwardA_D, ForwardB_D;
	wire [4:0] 	Rs_D, Rt_D;
	

	// Execution Stage
	wire 		RegDst_E, ALUSrc_E, Flush_E, MemToReg_E, RegWrite_E;
	wire [1:0]	ForwardA_E, ForwardB_E;
	wire [2:0] 	ALU_Control_E;
	wire [4:0] 	WriteReg_E, Rs_E, Rt_E;
	

	// Memory Stage
	wire 		MemWrite_M, MemToReg_M, RegWrite_M;
	wire [4:0] 	WriteReg_M;
	

	// Write-back Stage
	wire 		MemToReg_W, RegWrite_W;
	wire [4:0] 	WriteReg_W;
	

	// other signals
	wire [5:0] 	Opcode, Funct;

	// instantiate Pipeline Control
	PipelineControl #(WIDTH) pipelineControl(clk, reset, Equal_D, Opcode, Funct, PCSrc_D, Branch_D, RegDst_E, ALUSrc_E, MemToReg_E, RegWrite_E, ALU_Control_E, MemWrite_M, MemToReg_M, RegWrite_M, MemToReg_W, RegWrite_W);

	// instantiate Pipeline Datapath
	PipelineDatapath #(WIDTH) pipelineDatapath(clk, reset, PCSrc_D, RegWrite_W, RegDst_E, ALUSrc_E, MemWrite_M, MemToReg_W, ALU_Control_E, Stall_F, Stall_D, ForwardA_D, ForwardB_D, Flush_E, ForwardA_E, ForwardB_E, Equal_D, WriteReg_E, WriteReg_M, WriteReg_W, Rs_D, Rt_D, Rs_E, Rt_E, Opcode, Funct, ALUOut, WriteData, MemWrite);

	// instantiate Hazard Unit
	HazardUnit #(WIDTH) hazardUnit(clk, Branch_D, MemToReg_E, RegWrite_E, MemToReg_M, RegWrite_M, RegWrite_W, Rs_D, Rt_D, Rs_E, Rt_E, WriteReg_E, WriteReg_M, WriteReg_W, Stall_F, Stall_D, ForwardA_D, ForwardB_D, Flush_E, ForwardA_E, ForwardB_E);


endmodule