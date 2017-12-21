module shifter #(parameter WIDTH = 32, parameter SHIFT = 2) (
    input   [WIDTH-1:0]     in,
    output  [WIDTH-1:0]     out                     );
    
    assign out = in << SHIFT;
 
 endmodule