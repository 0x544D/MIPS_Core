/* 	Author: Tobias Minn
	MIPS Pipeline Processor

	Execution Stage (EX)
		
*/

module EX #(parameter WIDTH = 32)(
	input					RegDst_E, ALUSrc_E,
	input 	[1:0]			ForwardA_E, ForwardB_E,
	input	[2:0]			ALUControl_E,
	input	[4:0] 			Rs_E, Rt_E, Rd_E,
	input	[WIDTH-1:0]		ReadData1_E, ReadData2_E, SignImm_E, ALUOut_M, Result_W,
	output	[4:0]			WriteReg_E,
	output 	[WIDTH-1:0]		ALUOut_E, WriteData_E );


	wire ALU_Zero, ALU_Cout;
	wire [WIDTH-1:0] SrcA_E, WriteData, SrcB_E;

	// assign the outputs
	assign WriteData_E = WriteData;

	// instantiate WriteReg MUX
	mux2 #(5) WriteReg_MUX(Rt_E, Rd_E, RegDst_E, WriteReg_E);

	// instantiate Forward MUXs
	mux4 #(32) ForwardA_MUX(ReadData1_E, Result_W, ALUOut_M, 32'hx, ForwardA_E, SrcA_E);
	mux4 #(32) ForwardB_MUX(ReadData2_E, Result_W, ALUOut_M, 32'hx, ForwardB_E, WriteData);

	// instantiate SrcB MUX
	mux2 #(32) SrcB_MUX(WriteData, SignImm_E, ALUSrc_E, SrcB_E);

	// instantiate ALU
	MIPSAlu #(32) ALU(SrcA_E, SrcB_E, ALUControl_E, ALUOut_E, ALU_Cout, ALU_Zero);


endmodule