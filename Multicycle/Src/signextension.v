module signextension #(parameter WIDTH=32)(
    input   [15:0]      in,
    output  [WIDTH-1:0] out               );
    
    assign out = {{WIDTH-16{in[15]}},in};
    
endmodule