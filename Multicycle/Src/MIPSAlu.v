/* MIPS ALU from Digital Design and Computer Architecture
 * Author: Tobias Minn
 *
 * ALUControl:
 *  000 - and
 *  001 - or
 *  010 - add
 *  011 - 
 *  100 - SrcA and ~SrcB
 *  101 - SrcA or ~SrcB
 *  110 - subtract
 *  111 - slt
 *
*/


module MIPSAlu #(parameter WIDTH=32) 
            (   input [WIDTH-1:0] SrcA,
                input [WIDTH-1:0] SrcB,
                input [2:0] ALUControl,
                output reg [WIDTH-1:0]ALUResult,
                output cout,
                output zero            );
                
               
    wire [WIDTH-1:0] sum, bnot, bb;
    wire cin;
    
    // select cin
    assign cin = ALUControl[2];
    
    // inverting b
    assign bnot = ~SrcB;
    
    // choosing b
    assign bb = ALUControl[2] ? bnot : SrcB;
    
    // adder stage
    adder #(32) add(SrcA, bb, cin, sum, cout);
    
    // output mux
    always @ (*)
    case (ALUControl[1:0])
        0: ALUResult = SrcA&bb;
        1: ALUResult = SrcA|bb;
        2: ALUResult = sum;
        3: ALUResult = {{WIDTH-1{1'd0}},sum[WIDTH-1]};
        default: ALUResult = {WIDTH{1'bx}};
    endcase
    
    assign zero = (sum == 0) ? 1'b1 : 1'b0;
    
 endmodule