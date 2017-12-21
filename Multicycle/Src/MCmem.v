/* 	Author: Tobias Minn
	MIPS Multicycle
	Unified Instruction and Data Memory
	
*/
module MCmem #(parameter WIDTH = 32)(
	input					clk,
	input 	[WIDTH-1:0]		Address, WriteData,
	input 					MemRead, MemWrite,
	output 	[WIDTH-1:0]		ReadData
);

	// allocate memory
	reg [31:0] RAM[127:0];
	
	initial
		begin
			$readmemh("instructions.dat",RAM, 64);
			$readmemh("data.dat",RAM);
		end
	
	always @(posedge clk) begin
		if (MemWrite) begin
			RAM[Address[31:2]] = WriteData;
		end
	end

	// assign instruction at position addr
	assign ReadData = MemRead ? RAM[Address[31:2]] : 0;
    
endmodule