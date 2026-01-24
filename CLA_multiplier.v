module CLA_multiplier(
    output [7:0] P,
    input  [3:0] A,
    input  [3:0] B
);
    wire [3:0] pp0, pp1, pp2, pp3;

    wire [7:0] op1, op2, op3, op4;
    wire [7:0] sum1, sum2, sum3;

    wire c1, c2, c3;
    wire [7:0] g1, g2, g3;


    assign pp0 = A & {4{B[0]}};
    assign pp1 = A & {4{B[1]}};
    assign pp2 = A & {4{B[2]}};
    assign pp3 = A & {4{B[3]}};


    assign op1 = {4'b0000, pp0};        
    assign op2 = {3'b000, pp1, 1'b0};   
    assign op3 = {2'b00, pp2, 2'b00};   
    assign op4 = {1'b0,  pp3, 3'b000}; 

    ReversibleCLA8bit cla1 (
        sum1, c1, g1,
        op1, op2, 1'b0
    );

    ReversibleCLA8bit cla2 (
        sum2, c2, g2,
        sum1, op3, 1'b0
    );

    ReversibleCLA8bit cla3 (
        sum3, c3, g3,
        sum2, op4, 1'b0
    );

    assign P = sum3;

endmodule





module FeynmanGate(
    output P,
    output Q,
    input  A,
    input  B
);
    assign P = A;
    assign Q = A ^ B;
endmodule


module ToffoliGate(
    output P,
    output Q,
    output R,
    input  A,
    input  B,
    input  C
);
    assign P = A;
    assign Q = B;
    assign R = (A & B) ^ C;
endmodule


module PeresGate(
    output P,
    output Q,
    output R,
    input  A,
    input  B,
    input  C
);
    assign P = A;
    assign Q = A ^ B;
    assign R = (A & B) ^ C;
endmodule


module ReversiblePFA(
    output p,
    output g,
    output s,
    output garbage1,
    output garbage2,
    input  a,
    input  b,
    input  c
);
    wire t1;

    FeynmanGate fg1 (
        garbage1,
        t1,
        a,
        b
    );

    ToffoliGate tg1 (
        garbage2,
        ,
        g,
        a,
        b,
        1'b0
    );

    FeynmanGate fg2 (
        ,
        s,
        t1,
        c
    );

    assign p = t1;
endmodule


module ReversibleCLA4bit(
    output [3:0] s,
    output       cout,
    output [3:0] garbage,
    input  [3:0] a,
    input  [3:0] b,
    input        cin
);
    wire [3:0] p, g;
    wire [3:0] c;

    ReversiblePFA pfa0 (
        p[0], g[0], s[0], garbage[0], ,
        a[0], b[0], cin
    );
    assign c[1] = g[0] | (p[0] & cin);

    ReversiblePFA pfa1 (
        p[1], g[1], s[1], garbage[1], ,
        a[1], b[1], c[1]
    );
    assign c[2] = g[1] | (p[1] & c[1]);

    ReversiblePFA pfa2 (
        p[2], g[2], s[2], garbage[2], ,
        a[2], b[2], c[2]
    );
    assign c[3] = g[2] | (p[2] & c[2]);

    ReversiblePFA pfa3 (
        p[3], g[3], s[3], garbage[3], ,
        a[3], b[3], c[3]
    );
    assign cout = g[3] | (p[3] & c[3]);
endmodule

module ReversibleCLA8bit(
    output [7:0] s,
    output       cout,
    output [7:0] garbage,
    input  [7:0] a,
    input  [7:0] b,
    input        cin
);
    wire c4;

    ReversibleCLA4bit cla_lower (
        s[3:0], c4, garbage[3:0],
        a[3:0], b[3:0], cin
    );

    ReversibleCLA4bit cla_upper (
        s[7:4], cout, garbage[7:4],
        a[7:4], b[7:4], c4
    );
endmodule









