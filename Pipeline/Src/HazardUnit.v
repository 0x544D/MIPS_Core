/* 	Author: Tobias Minn
	MIPS Pipeline Processor

	Hazard Unit		
*/
module HazardUnit #(parameter WIDTH = 32)(
	
	// Control Signals
	input				clk, Branch_D, MemToReg_E, RegWrite_E, MemToReg_M, RegWrite_M, RegWrite_W,
	// Datapath Signals
	input		[4:0]	Rs_D, Rt_D, Rs_E, Rt_E, WriteReg_E, WriteReg_M, WriteReg_W,
	
	output reg			Stall_F, Stall_D, ForwardA_D, ForwardB_D, Flush_E,
	output reg	[1:0] 	ForwardA_E, ForwardB_E);

	// signals
	reg LWStall, BranchStall;

	always @(*)
	begin
		// Rs Forward logic
		if( (Rs_E != 0) && (Rs_E == WriteReg_M) && (RegWrite_M) ) begin
			ForwardA_E <= 2'b10;
		end else if( (Rs_E != 0) && (Rs_E == WriteReg_W) && (RegWrite_W) ) begin
			ForwardA_E <= 2'b01;
		end else begin
			ForwardA_E <= 2'b00;
		end

		// Rt Forward logic
		if( (Rt_E != 0) && (Rt_E == WriteReg_M) && (RegWrite_M) ) begin
			ForwardB_E <= 2'b10;
		end else if( (Rt_E != 0) && (Rt_E == WriteReg_W) && (RegWrite_W) ) begin
			ForwardB_E <= 2'b01;
		end else begin
			ForwardB_E <= 2'b00;
		end

		// Load Word Hazard -> Stall
		LWStall <= ( ( (Rs_D == Rt_E) || (Rt_D == Rt_E) ) && MemToReg_E );
		
		// Forward for equality comparator in Decode Stage in case a branch need to get results from previous 
		// instruction (currently in MEM stage) forwarded
		ForwardA_D <= ( (Rs_D != 0) && (Rs_D == WriteReg_M) && RegWrite_M );
		ForwardB_D <= ( (Rt_D != 0) && (Rt_D == WriteReg_M) && RegWrite_M );

		BranchStall = 	( ( Branch_D && RegWrite_E && ( (WriteReg_E == Rs_D) || (WriteReg_E == Rt_D) ) ) ||
			 			  ( Branch_D && MemToReg_M && ( (WriteReg_M == Rs_D) || (WriteReg_M == Rt_D) ) ) );
	
		Stall_F <= LWStall || BranchStall;
		Stall_D <= LWStall || BranchStall;
		Flush_E <= LWStall || BranchStall;

	end

endmodule