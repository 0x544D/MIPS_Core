/* 	Author: Tobias Minn
	MIPS Pipeline Processor

	Datapath Assembly		
*/
module PipelineDatapath #(parameter WIDTH = 32)(
	input			clk, reset,
	// Control Path Signals
	input			PCSrc_D, RegWrite_W, RegDst_E, ALUSrc_E, MemWrite_M, MemToReg_W,
	input	[2:0]	ALUControl_E,
	// Hazard Unit Signals
	input			Stall_F, Stall_D, ForwardA_D, ForwardB_D, Flush_E,
	input	[1:0]	ForwardA_E, ForwardB_E,
	// outputs
	output 			Equal_D,
	output 	[4:0] 	WriteReg_E_Out, WriteReg_M_Out, WriteReg_W_Out, Rs_D_Out, Rt_D_Out, Rs_E_Out, Rt_E_Out,
	output	[5:0]	Opcode, Funct,
	// signals for testbench
	output 	[WIDTH-1:0] ALUOut, WriteData,
	output 	MemWrite
	);


	// internal signals of datapath
	// Fetch Stage
	wire [WIDTH-1:0] 	PCPlus4_F, Instr_F;
	// Decode Stage
	wire [4:0]			Rs_D, Rt_D, Rd_D;
	wire [WIDTH-1:0] 	PCBranch_D, Instr_D, PCPlus4_D, ReadData1_D, ReadData2_D, SignImm_D;
	// Execute Stage
	wire [4:0] 			Rs_E, Rt_E, Rd_E, WriteReg_E;
	wire [WIDTH-1:0]	ReadData1_E, ReadData2_E, SignImm_E, ALUOut_E, WriteData_E;
	// Memory Stage
	wire [4:0] 			WriteReg_M;
	wire [WIDTH-1:0] 	ALUOut_M, WriteData_M, ReadData_M;
	// Write-back Stage
	wire [4:0] 			WriteReg_W;
	wire [WIDTH-1:0]	Result_W, ReadData_W, ALUOut_W;

	// instantiate Instruction Fetch (IF) stage
	IF #(32) InstructionFetch(clk, reset, PCBranch_D, PCSrc_D, Stall_F, PCPlus4_F, Instr_F);

	// instantiate IF/ID register (enable through !Stall_D and clear through PCSrc_D)
	ffre #(64) IF_ID_register({Instr_F, PCPlus4_F}, clk, PCSrc_D, !Stall_D, {Instr_D, PCPlus4_D});

	// instantiate Instruction Decode (ID) stage
	ID #(32) InstructionDecode(clk, reset, RegWrite_W, ForwardA_D, ForwardB_D, Instr_D, PCPlus4_D, ALUOut_M, Result_W, WriteReg_W, Equal_D, Opcode, Funct, Rs_D, Rt_D, Rd_D, ReadData1_D, ReadData2_D, SignImm_D, PCBranch_D);

	// instantiate ID/EX register (always enable, clear through Flush_E)
	ffre #(111) ID_EX_register({ReadData1_D, ReadData2_D, Rs_D, Rt_D, Rd_D, SignImm_D}, clk, Flush_E, 1'b1, {ReadData1_E, ReadData2_E, Rs_E, Rt_E, Rd_E, SignImm_E}); 

	// instantiate Execute (EX) stage
	EX #(32) Execute(RegDst_E, ALUSrc_E, ForwardA_E, ForwardB_E, ALUControl_E, Rs_E, Rt_E, Rd_E, ReadData1_E, ReadData2_E, SignImm_E, ALUOut_M, Result_W, WriteReg_E, ALUOut_E, WriteData_E);

	// instantiate EX/MEM register
	ffr #(69) EX_MEM_register({ALUOut_E, WriteData_E, WriteReg_E}, clk, reset, {ALUOut_M, WriteData_M, WriteReg_M});

	// instantiate Memory (MEM) stage
	MEM #(32) Memory(clk, MemWrite_M, ALUOut_M, WriteData_M, ReadData_M);

	// instantiate MEM/WB register
	ffr #(69) MEM_WB_register({ReadData_M, ALUOut_M, WriteReg_M}, clk, reset, {ReadData_W, ALUOut_W, WriteReg_W});

	// instantiate Write-back (WB) stage
	WB #(32) Writeback(MemToReg_W, ReadData_W, ALUOut_W, Result_W);


	// assign output signals
	assign Rs_D_Out = Rs_D;
	assign Rt_D_Out = Rt_D;
	assign Rs_E_Out = Rs_E;
	assign Rt_E_Out = Rt_E;
	assign WriteReg_E_Out = WriteReg_E;
	assign WriteReg_M_Out = WriteReg_M;
	assign WriteReg_W_Out = WriteReg_W;

	// for testbench
	assign ALUOut = ALUOut_M;
	assign WriteData = WriteData_M;
	assign MemWrite = MemWrite_M;


endmodule