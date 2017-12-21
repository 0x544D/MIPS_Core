/* Author: Tobias Minn
	MIPS Singlecycle Control
	
	Instruction	| Opcode	| RegDst | Branch | MemRead 	| MemToReg 	| MemWrite 	| AluSrc | RegWrite 	| AluOp 	| Jump	|
	-------------------------------------------------------------------------------------------------------------------
	R-Type		| 000000	| 1		| 0 		| 0 			| 0			| 0 			| 0		| 1			| 10		| 0		|
	lw				| 100011	| 0		| 0 		| 1 			| 1			| 0 			| 1		| 1			| 00		| 0		|
	sw				| 101011	| X		| 0 		| 0 			| X			| 1 			| 1		| 0			| 00		| 0		|
	beq			| 000100	| X		| 1 		| 0 			| X			| 0 			| 0		| 0			| 01		| 0 		|
	addi			| 001000	| 0		| 0 		| 0 			| 0			| 0 			| 1		| 1			| 00		| 0		|
	j				| 000010	| X		| X 		| 0 			| X			| 0 			| X		| 0			| XX		| 1		|
*/
module MIPSControl #(parameter WIDTH=32)	(
	input   	[31:26]			opcode,
	input		[5:0]				funct,
	output  						RegDst,
	output						Branch,
	output						MemRead,
	output 						MemToReg,
	output 						MemWrite,
	output 						AluSrc,
	output 						RegWrite,
	output						Jump,
	output 	[2:0]				AluControl);
	
	wire [1:0] AluOp;
	
	MainControl maincontrol(opcode,RegDst,Branch,MemRead,MemToReg,MemWrite,AluSrc,RegWrite,Jump,AluOp);
	
	AluControl alucontrol(funct,AluOp,AluControl);
    
endmodule