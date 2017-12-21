/* Author: Tobias Minn
	MIPS Singlecycle
	Data Memory
	
*/
module dmem(
	input 					clk, we, 
	input 	[31:0]		addr, writeData,
	output 	[31:0]		readData
);
	// allocate memory
	reg [31:0] RAM[63:0];
	
	// assign output always memory content at addr
	assign readData = RAM[addr[31:2]];
	
	always @(posedge clk)
		if(we)
			RAM[addr[31:2]] <= writeData;	
    
endmodule