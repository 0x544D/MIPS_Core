/* Resettable D-FlipFlop
 * Author: Tobias Minn, 29.08.2016   
 * 
*/ 

module ffre #(parameter WIDTH=32, parameter RESET_VALUE=32'h0)(
        input [WIDTH-1:0] D,
        input clk,
        input reset,
        input enable,
        output reg [WIDTH-1:0] Q    );
        
        always @ (posedge clk, posedge reset)
        begin
            if(reset)
                Q <= RESET_VALUE;
            else if(enable)
                Q <= D;
        end
endmodule