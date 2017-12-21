/* Author: Tobias Minn
	Testbench for MIPS Singlecycle
	
	
*/
module testbench();
	
	reg clk;
	reg reset;
	
	wire [31:0] writedata, dataaddr;
	wire 			memwrite;
	
	// instantiate device to be tested
	MIPSPipeline mips_dut(clk, reset, memwrite, dataaddr, writedata);
	
	// initialize test
	initial
		begin
			reset <= 1; # 22; reset <= 0;
		end
		
	// generate clock sequence
	always
		begin
			clk <= 1; # 5; clk <= 0; # 5;
		end
	
	// check results
	always @ (negedge clk)
		begin
			if(memwrite)
				begin
					if(dataaddr == 84 & writedata === 7)
						begin
							$display("Simulation succeded");
							$stop;
						end
					else if(dataaddr !== 80)
						begin
							$display("Simulation failed");
							$stop;
						end
				end
		end
    
endmodule