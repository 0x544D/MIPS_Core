/* Author: Tobias Minn
	MIPS Singlecycle MainControl
	
	Instruction	| Opcode	| RegDst | Branch | MemRead 	| MemToReg 	| MemWrite 	| AluSrc | RegWrite 	| AluOp 	| Jump	|
	-------------------------------------------------------------------------------------------------------------------
	R-Type		| 000000	| 1		| 0 		| 0 			| 0			| 0 			| 0		| 1			| 10		| 0		|
	lw				| 100011	| 0		| 0 		| 1 			| 1			| 0 			| 1		| 1			| 00		| 0		|
	sw				| 101011	| X		| 0 		| 0 			| X			| 1 			| 1		| 0			| 00		| 0		|
	beq			| 000100	| X		| 1 		| 0 			| X			| 0 			| 0		| 0			| 01		| 0 		|
	addi			| 001000	| 0		| 0 		| 0 			| 0			| 0 			| 1		| 1			| 00		| 0		|
	j				| 000010	| X		| X 		| 0 			| X			| 0 			| X		| 0			| XX		| 1		|
*/
module MainControl #(parameter WIDTH=32)	(
	input   	[31:26]			opcode,
	output  						RegDst,
	output						Branch,
	output						MemRead,
	output 						MemToReg,
	output 						MemWrite,
	output 						AluSrc,
	output 						RegWrite,
	output						Jump,
	output 	[1:0]				AluOp				);
	
	reg [9:0] controlsignals;
	
	assign {RegDst,Branch,MemRead,MemToReg,MemWrite,AluSrc,RegWrite,AluOp,Jump} = controlsignals;
	
	
	// TODO: find possibility to include the don't care control signals
	always @ (*)
    case (opcode)   
			// R-Type Instruction
			6'b000000: controlsignals <= 10'b1000001100;
			
			// lw instruction
			6'b100011: controlsignals <= 10'b0011011000;
			
			// sw instruction
			6'b101011: controlsignals <= 10'b0000110000;
			
			// beq instruction
			6'b000100: controlsignals <= 10'b0100000010;
			
			// addi instruction
			6'b001000: controlsignals <= 10'b0000011000;
			
			// j instruction
			6'b000010: controlsignals <= 10'b0000000001;
        
		default: controlsignals <= 10'b000000000;
    endcase
	
    
endmodule