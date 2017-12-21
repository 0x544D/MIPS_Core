module adder #(parameter N=8)
            (   input [N-1:0] a, b,
                input cin,
                output [N-1:0] y,
                output cout         );
                
    assign {cout,y} = a + b + cin;
endmodule