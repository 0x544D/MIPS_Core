/* 	Author: Tobias Minn
	MIPS Multicycle Control FSM
*/

module MulticycleControlFSM(
	input			clk,
	input			reset,
	input	[5:0]	opcode,
	output			IorD,
	output			IRWrite,
	output  		RegDst,
	output			MemRead,
	output 			MemToReg,
	output 			MemWrite,
	output 			ALUSrcA,
	output 	[1:0]	ALUSrcB,
	output 			RegWrite,
	output 	[1:0]	ALUOp,
	output 	[1:0]	PCSource,
	output			PCWrite,
	output			PCWriteCond);


	reg [15:0] controlsignals;
	

	// define register for state and next state
	reg [3:0] state, nextstate;

	// define states
	parameter IF 		= 4'b0000;
	parameter ID 		= 4'b0001;
	parameter LWSW		= 4'b0010;
	parameter LW 		= 4'b0011;
	parameter LWWB		= 4'b0100;
	parameter SW 		= 4'b0101;
	parameter R 		= 4'b0110;
	parameter RCOMP 	= 4'b0111;
	parameter BEQ		= 4'b1000;
	parameter J			= 4'b1001;
	parameter ADDI		= 4'b1010;
	parameter ADDICOMP	= 4'b1011;


	//state register
    always @ (posedge clk, posedge reset)
    	if(reset)   state <= IF;
    	else        state <= nextstate;

	// next state logic
    always @ (*)
        case(state)
        	IF 		:	nextstate = ID;
			ID 		:	begin
							if(opcode == 0)
								// R-Type instruction
								nextstate = R;
							else if(opcode == 6'h23 || opcode == 6'h2b ) begin
								// LW or SW instruction
								nextstate = LWSW;
							end else if(opcode == 6'h04) begin
								// BEQ instruction
								nextstate = BEQ;
							end else if(opcode == 6'h02) begin
								// JUMP instruction
								nextstate = J;
							end else if(opcode == 6'h08) begin
								nextstate = ADDI;
							end else begin
								// unknown instruction
								nextstate = IF;
							end
						end 
			LWSW	:	begin
							if(opcode == 6'h23) begin
								nextstate = LW;
							end else if(opcode == 6'h2b) begin
								nextstate = SW;
							end else begin
								nextstate = IF;
							end
						end
			LW 		:	nextstate = LWWB;
			LWWB	:	nextstate = IF;
			SW		:	nextstate = IF;
			R 		:	nextstate = RCOMP;
			RCOMP	:	nextstate = IF;
			BEQ		:	nextstate = IF;
			J		: 	nextstate = IF;
			ADDI 	: 	nextstate = ADDICOMP;
			ADDICOMP: 	nextstate = IF;
        endcase

	assign {IorD, IRWrite, RegDst, MemRead, MemToReg, MemWrite, ALUSrcA, ALUSrcB, RegWrite, ALUOp, PCSource, PCWrite, PCWriteCond} = controlsignals;
    // output logic
    always @ (*)
        case(state)
        	IF 		:	controlsignals = 16'b0101000010000010;
        	ID 		:	controlsignals = 16'b0000000110000000;
        	LWSW 	:	controlsignals = 16'b0000001100000000;
        	LW 		:	controlsignals = 16'b1001000000000000;
        	LWWB 	:	controlsignals = 16'b0000100001000000;
        	SW 		:	controlsignals = 16'b1000010000000000;
        	R 		:	controlsignals = 16'b0000001000100000;
        	RCOMP	:	controlsignals = 16'b0010000001000000;
        	BEQ 	:	controlsignals = 16'b0000001000010101;
        	J 		:	controlsignals = 16'b0000000000001010;
        	ADDI 	: 	controlsignals = 16'b0000001100000000;
        	ADDICOMP: 	controlsignals = 16'b0000000001000000;
    	endcase

endmodule
        
