/* 	Author: Tobias Minn
	MIPS Multicycle Datapath
*/
module MIPSMulticycleDatapath #(parameter WIDTH=32)	(
	input 							clk, reset,
	input		[WIDTH-1:0]			MemData_Signal,
	input 							PCWrite,
	input							PCWriteCond,
	input							IorD,
	input							IRWrite,
	input 							RegDst,
	input 							MemToReg,
	input 							MemWrite,
	input 							ALUSrcA,
	input		[1:0]				ALUSrcB, PCSource,
	input 							RegWrite,
	input		[2:0]				ALUControl,
	output		[WIDTH-1:0]			MemoryAddress, MemoryWriteData,
	output		[5:0]				Opcode, Funct);
	
	
	/* LOCAL SIGNALS */
	
	wire PC_enable, ALU_Carry_Out, ALU_Zero_Flag;
	
	wire [WIDTH-1:0] PC, PC_new, Instruction, MemData_Reg_Signal, ALUOut_Signal, WriteData_MUX_Signal, ReadData1, ReadData2, Reg_A_Signal, Reg_B_Signal, SignExtendedImmediate, SignExtendedImmShift2, ALUSrcA_MUX_Signal, ALUSrcB_MUX_Signal, ALU_Result, JumpShift2, PCJumpConcat, IorD_MUX_Signal;
	
	wire [4:0] WriteRegister_MUX_Signal;
	
	/* instantiate components */

	// generate PC enable signal
	assign PC_enable = (PCWrite | (PCWriteCond & ALU_Zero_Flag));

	// instantiate PC register
	ffre #(32,32'h100) PC_reg(PC_new, clk, reset, PC_enable, PC);

	// instantiate IorD MUX
	mux2 #(32) IorD_MUX(PC, ALUOut_Signal, IorD, IorD_MUX_Signal);

	// instantiate Instruction register
	ffre #(32) Instruction_Reg(MemData_Signal, clk, reset, IRWrite, Instruction);

	// assign Opcode and Function code
	assign Opcode = Instruction[31:26];
	assign Funct = Instruction[5:0];

	// instantiate Memory Data register
	ffr #(32) MemData_Reg(MemData_Signal, clk, reset, MemData_Reg_Signal);

	// instantiate Registerfile MUXs
	mux2 #(5) WriteRegister_MUX(Instruction[20:16], Instruction[15:11], RegDst, WriteRegister_MUX_Signal);
	mux2 #(32) WriteData_MUX(ALUOut_Signal, MemData_Reg_Signal, MemToReg, WriteData_MUX_Signal);

	// instantiate Register File
	// port declaration: RA1 (instruction[25:21]), RA2 (instruction[20:16]), WA3, WD3, CLK, WE3, RD1, RD2
	regfile #(32) Registerfile(Instruction[25:21], Instruction[20:16], WriteRegister_MUX_Signal, WriteData_MUX_Signal, clk, RegWrite, ReadData1, ReadData2);

	// instantiate registers A and B
	ffr #(32) Reg_A(ReadData1, clk, reset, Reg_A_Signal);
	ffr #(32) Reg_B(ReadData2, clk, reset, Reg_B_Signal);

	// instantiate sign extension
	signextension #(32) SignExtension(Instruction[15:0],SignExtendedImmediate);
	// instantiate sign extension shifter
	shifter #(32,2) SignExtShift(SignExtendedImmediate, SignExtendedImmShift2);

	// instantiate ALU MUXs
	mux2 #(32) ALUSrcA_MUX(PC, Reg_A_Signal, ALUSrcA, ALUSrcA_MUX_Signal);
	mux4 #(32) ALUSrcB_MUX(Reg_B_Signal, 32'h00000004, SignExtendedImmediate, SignExtendedImmShift2, ALUSrcB, ALUSrcB_MUX_Signal);

	// instantiate ALU
	MIPSAlu #(32) ALU(ALUSrcA_MUX_Signal, ALUSrcB_MUX_Signal, ALUControl, ALU_Result, ALU_Carry_Out, ALU_Zero_Flag);

	// instantiate ALUOut register
	ffr #(32) ALUOut_Reg(ALU_Result, clk, reset, ALUOut_Signal);

	// instantiate jump shifter
	shifter #(32,2) Jumpshift(Instruction, JumpShift2);
	assign PCJumpConcat = {PC[31:28],JumpShift2[27:0]};

	// instantiate PC new MUX
	mux4 #(32) PCNew_MUX(ALU_Result, ALUOut_Signal, PCJumpConcat, 32'h00000000, PCSource, PC_new);

	// assign outputs
	assign MemoryWriteData = Reg_B_Signal;
	assign MemoryAddress = IorD_MUX_Signal;
    
endmodule