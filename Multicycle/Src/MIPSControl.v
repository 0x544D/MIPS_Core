/* 	Author: Tobias Minn
	MIPS Multicycle Control
	see Control FSM 
*/
module MIPSControl #(parameter WIDTH=32)	(
	input			clk,
	input			reset,
	input	[5:0]	Opcode, Funct,
	output			IorD,
	output			IRWrite,
	output  		RegDst,
	output			MemRead,
	output 			MemToReg,
	output 			MemWrite,
	output 			ALUSrcA,
	output 	[1:0]	ALUSrcB,
	output 			RegWrite,
	output 	[2:0]	ALUControl,
	output 	[1:0]	PCSource,
	output			PCWrite,
	output			PCWriteCond);
	
	wire [1:0] ALUOp;
	
	// instantiate Main Control FSM for Multicycle
	MulticycleControlFSM ControlFSM(clk, reset, Opcode, IorD, IRWrite, RegDst, MemRead, MemToReg, MemWrite, ALUSrcA, ALUSrcB, RegWrite, ALUOp, PCSource, PCWrite, PCWriteCond);
	
	// instantiate ALUControl
	AluControl Alucontrol(Funct, ALUOp, ALUControl);
    
endmodule