module testbenchFSM();

	// local signals
	reg clk, reset;
	
	wire IorD, RegDst, MemToReg, MemWrite, MemRead, PCWrite, PCWriteCond, RegWrite, ALUSrcA, IRWrite;
	
	wire [1:0] ALUSrcB, AluOp, PCSource;
	
	reg [5:0] opcode;
	
	// instantiate dut
	MulticycleControlFSM controlfsm(clk, reset, opcode, IorD, IRWrite, RegDst, MemRead,	MemToReg, MemWrite,	ALUSrcA, ALUSrcB, RegWrite, AluOp, PCSource, PCWrite, PCWriteCond);
	
	// initial config
	initial
		begin
			opcode <= 6'h23;
			reset <= 1;
			# 22;
			reset <= 0;

			# 50;
			// opcode for sw
			opcode = 6'h2b;
			# 40;
			// opcode for R-Type
			opcode = 6'h00;
			# 40;
			// opcode for beq
			opcode = 6'h04;
			# 30;
			// opcode for j
			opcode = 6'h02;
			# 30;
			
			// test reset while in loop
			opcode = 6'h2b;
			# 24;
			reset = 1;
			# 20;
			opcode = 6'h00;
			reset = 0;
			
			// change opcode in flight
			# 23;
			opcode = 6'h23;
			
			# 50;
			
			$display("Simulation finished");
			$stop;
		end
	
	// clock generation
	always
		begin
			clk <= 1;
			# 5;
			clk <= 0;
			# 5;
		end
			

endmodule