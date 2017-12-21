/* 	Author: Tobias Minn
	MIPS Pipeline Processor

	Instruction Decode Stage (ID)
		
*/
module ID #(parameter WIDTH = 32)(
	input					clk, reset, RegWrite_W, ForwardA_D, ForwardB_D,
	input	[WIDTH-1:0]		Instr_D, PCPlus4_D, ALUOut_M, Result_W,
	input	[4:0]			WriteReg_W,
	output 					Equal_D,
	output	[5:0]			Opcode, Funct,
	output	[4:0]			Rs_D, Rt_D, Rd_D,
	output 	[WIDTH-1:0]		ReadData1_D, ReadData2_D, SignImm_D, PCBranch_D);

	wire PCBranchCout;

	wire [WIDTH-1:0]	ReadData1, ReadData2, ReadData1_Mux_Out, ReadData2_Mux_Out, SignImm, SignImmShift2;

	// assign the outputs
	assign Opcode = Instr_D[31:26];
	assign Funct = Instr_D[5:0];
	assign Rs_D = Instr_D[25:21];
	assign Rt_D = Instr_D[20:16];
	assign Rd_D = Instr_D[15:11];
	assign SignImm_D = SignImm;
	assign ReadData1_D = ReadData1;
	assign ReadData2_D = ReadData2;

	// instantiate register file
	// DO I NEED A RESET FOR REGISTERFILE?
	regfile #(32) RegisterFile(Instr_D[25:21], Instr_D[20:16], WriteReg_W, Result_W, !clk, RegWrite_W, ReadData1, ReadData2);

	// instantiate equality MUXs
	mux2 #(32) ReadData1_Mux(ReadData1, ALUOut_M, ForwardA_D, ReadData1_Mux_Out);
	mux2 #(32) ReadData2_Mux(ReadData2, ALUOut_M, ForwardB_D, ReadData2_Mux_Out);

	// instantiate equality gate
	equalityGate #(32) equal(ReadData1_Mux_Out, ReadData2_Mux_Out, Equal_D);

	// instantiate SignExtension
	signextension #(32) SignExtension(Instr_D[15:0], SignImm);

	// instantiate shifter for branch adder
	shifter #(32,2) BranchShifter(SignImm, SignImmShift2);

	// instantiate PC plus 4 adder
	adder #(32) PCadder(SignImmShift2, PCPlus4_D, 1'b0, PCBranch_D, PCBranchCout);

endmodule