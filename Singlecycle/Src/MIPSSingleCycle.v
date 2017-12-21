/* Author: Tobias Minn
	MIPS Singlecycle
	
	
*/
module MIPSSingleCycle #(parameter WIDTH=32)	(
	input 				clk,
	input 				reset,
	output	[31:0]	readdataRT, aluresult,
	output 				memwrite
);

	/* local signals */
	wire	RegDst,
			Branch,
			MemRead,
			MemToReg,
			MemWrite,
			AluSrc,
			RegWrite,
			Jump;
			
	wire [2:0] AluControl;
	
	wire [WIDTH-1:0] PCin, PCout, Instruction, ReadData, ALUResult, ReadDataRT;

	// instantiate PC register
	ffr #(32) ProgramCounter(PCin, clk, reset, PCout);
	
	// instantiate Datapath
	MIPSDatapath #(32) datapath(clk, Instruction, PCout, ReadData, RegDst, Branch, MemRead, MemToReg, MemWrite, AluSrc, RegWrite, Jump, AluControl, ALUResult, ReadDataRT, PCin);

	// instantiate Controlpath
	MIPSControl #(32) controlpath(Instruction[31:26], Instruction[5:0], RegDst, Branch, MemRead, MemToReg, MemWrite, AluSrc, RegWrite, Jump, AluControl);
	
	// instantiate instruction memory
	imem instructionMemory(PCout[7:2], Instruction);
	
	// instantiate data memory
	dmem dataMemory(clk, MemWrite, ALUResult, ReadDataRT, ReadData);
	
	assign readdataRT = ReadDataRT;
	assign aluresult = ALUResult;
	assign memwrite = MemWrite;
    
endmodule