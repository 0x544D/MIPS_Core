/* Synchronous Resettable D-FlipFlop
 * Author: Tobias Minn, 29.08.2016   
 * 
*/ 

module ffr #(parameter WIDTH=32)(
        input [WIDTH-1:0] D,
        input clk,
        input reset,
        output reg [WIDTH-1:0] Q    );
        
        always @ (posedge clk)
        begin
            if(reset)
                Q <= 32'b0;
            else
                Q <= D;
        end
endmodule