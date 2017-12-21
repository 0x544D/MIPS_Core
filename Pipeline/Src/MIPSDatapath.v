/* Author: Tobias Minn
	MIPS Singlecycle
	
	
*/
module MIPSDatapath #(parameter WIDTH=32)	(
	input 							clk,
	input		[WIDTH-1:0]			instruction, ProgramCounter, ReadData,
	input 							RegDst,
	input 							Branch,
	input								MemRead,
	input 							MemToReg,
	input 							MemWrite,
	input 							AluSrc,
	input 							RegWrite,
	input								Jump,
	input		[2:0]					AluControl,
	output	[WIDTH-1:0]			ALUResult, ReadDataRT, ProgramCounter_Out	);
	
	
	/* LOCAL SIGNALS */
	
	wire ALU_Carry_Out, ALU_Zero_Flag, PCOverflow_Flag, PCBranchOverflow_Flag, PCSrc_Select;
	
	// MUX for selecting rt or rd as register destination
	wire [4:0] RegDst_Mux_Out;
	
	// MUX for selecting ALU result or Memory Data
	wire [WIDTH-1:0] MemToReg_Mux_Out, ReadData1, ReadData2, SignExtImm, SignExtImmShift2, ALUInput_MUX_Out, ALU_Result, PCPlus4, PCBranchResult, JumpShift2, JumpPCPlus4MUX;
	
	
	/* instantiate components */
	
	// instantiate Register File
	// port declaration: RA1 (instruction[25:21]), RA2 (instruction[20:16]), WA3, WD3, CLK, WE3, RD1, RD2
	regfile #(32) regfile(instruction[25:21], instruction[20:16], RegDst_Mux_Out, MemToReg_Mux_Out, clk, RegWrite, ReadData1, ReadData2);
	
	// instantiate RegDst MUX for register file (addresses are 5 bit wide)
	mux2 #(5) RegDst_MUX(instruction[20:16], instruction[15:11], RegDst, RegDst_Mux_Out);
	
	// instantiate sign extension
	signextension #(32) signext(instruction[15:0],SignExtImm);
	
	// instantiate ALU input mux for second ALU input
	mux2 #(32) ALUInput_MUX(ReadData2, SignExtImm, AluSrc, ALUInput_MUX_Out);
	
	// instantiate ALU
	MIPSAlu #(32) ALU(ReadData1, ALUInput_MUX_Out, AluControl, ALU_Result, ALU_Carry_Out, ALU_Zero_Flag);
	
	// assign ALU result as output and register data RT as output
	assign ALUResult = ALU_Result;
	assign ReadDataRT = ReadData2;
	
	// instantiate MemToReg MUX
	mux2 #(32) MemToReg_MUX(ALU_Result, ReadData, MemToReg, MemToReg_Mux_Out);
	
	// instantiate sign extension shifter
	shifter #(32,2) signextshift(SignExtImm, SignExtImmShift2);
	
	// instantiate program counter adder
	adder #(32) PCadder(ProgramCounter, 32'h4, 1'b0, PCPlus4, PCOverflow_Flag);
	
	// instantiate branch adder
	adder #(32) PCBranchadder(JumpPCPlus4MUX, SignExtImmShift2, 1'b0, PCBranchResult, PCBranchOverflow_Flag);
	
	// instantiate PC Src MUX
	mux2 #(32) PCSrcMUX(JumpPCPlus4MUX, PCBranchResult, PCSrc_Select, ProgramCounter_Out);
	assign PCSrc_Select = (ALU_Zero_Flag & Branch);
	
	// jump
	shifter #(32,2) jumpshift(instruction, JumpShift2);
	assign JumpShift2[31:28] = ProgramCounter[31:28];
	mux2 #(32) JumpMUX(PCPlus4, JumpShift2, Jump, JumpPCPlus4MUX);
    
endmodule