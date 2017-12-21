/* Registerfile with variable WIDTH
 * Author: Tobias Minn
 *
 */

module regfile #(parameter WIDTH=32)(
        input [4:0]         ra1, ra2, wa3,
        input [WIDTH-1:0]   wd3,
        input               clk, 
        input               we3,
        output [WIDTH-1:0]  rd1, rd2);
        
        // [reg width] name[number of regs]
        reg [WIDTH-1:0] regs[31:0]; 

        // write only on positive clock edge        
        always @ (posedge clk)
        begin
            // write reg only if write enable is HIGH
            if(we3) regs[wa3] <= wd3;
        end

        // read regfile asynchronously if not zero register     
        assign rd1 = (ra1 != 0)? regs[ra1] : 0;
        assign rd2 = (ra2 != 0)? regs[ra2] : 0;

endmodule