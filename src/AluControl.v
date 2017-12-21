/* Author: Tobias Minn
	MIPS Singlecycle AluControl
	
	| AluOp	| Funct	| AluControl	|
	----------------------------------
	| 00		| X		| 010 (add)		|
	| X1		| X		| 110 (sub)		|
	| 1X		| 100000 | 010 (add)		|
	| 1X		| 100010 | 110 (sub)		|
	| 1X		| 100100 | 000 (and)		|
	| 1X		| 100101 | 001 (or)		|
	| 1X		| 101010	| 111	(slt)		|
	
*/
module AluControl #(parameter WIDTH=32)	(
	input 		[5:0]				Funct,
	input   		[1:0]				AluOp,
	output reg 	[2:0]				AluControl		);
	

	always @ (*)
    case (AluOp)
			2'b00:	AluControl <= 3'b010;
			2'b01:	AluControl <= 3'b110;
			2'b10:	case (Funct)
								6'b100000:		AluControl <= 3'b010;	// add
								6'b100010:		AluControl <= 3'b110;	// sub
								6'b100100:		AluControl <= 3'b000;	// and
								6'b100101:		AluControl <= 3'b001;	// or
								6'b101010:		AluControl <= 3'b111;	// slt
								default:			AluControl <= 3'b000;	
						endcase
			2'b11:	AluControl <= 3'b000;
			default: AluControl <= 3'b000;
			
    endcase
	
    
endmodule