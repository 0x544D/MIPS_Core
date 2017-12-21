/* 	Author: Tobias Minn
	MIPS Pipeline Processor

	Instruction Fetch Stage (IF)
		
*/
module IF #(parameter WIDTH = 32, parameter RESET_ADDRESS = 32'h0)(
	input					clk, reset,
	input	[WIDTH-1:0]		PCBranch_D,
	input					PCSrc_D, Stall_F,
	output	[WIDTH-1:0]		PCPlus4_F, Instr_F);


	wire [WIDTH-1:0] PCPlus4, PC_new, PC_F;

	wire PC_cout;

	// instantiate PC MUX
	mux2 #(32) PC_MUX(PCPlus4, PCBranch_D, PCSrc_D, PC_new);

	// instantiate PC register
	ffre #(32,RESET_ADDRESS) PC_Reg(PC_new, clk, reset, !Stall_F, PC_F);

	// instantiate PC + 4 adder
	adder #(32) PCPlus4_Adder(PC_F, 32'h4, 1'b0, PCPlus4, PC_cout);

	// instantiate Instruction memory
	imem instructionMemory(PC_F, Instr_F);

	// assign internal PCPlus4 signal to output
	assign PCPlus4_F = PCPlus4;

endmodule