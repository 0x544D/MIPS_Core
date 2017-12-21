/* Author: Tobias Minn
	MIPS Singlecycle
	Instruction Memory
	
*/
module imem(
	input 	[5:0]			addr,
	output 	[31:0]		readData
);

	// allocate memory
	reg [31:0] RAM[63:0];
	
	initial
		begin
			$readmemh("memfile.dat",RAM);
		end
	
	// assign instruction at position addr
	assign readData = RAM[addr];
    
endmodule