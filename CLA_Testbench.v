
module CLA_Testbench;
    reg  [3:0] A, B;
    wire [7:0] P;

   bruh uut (
    P,
    A,
    B
    );


    initial begin
        $dumpfile("vedic_multiplier_4bit.vcd");
        $dumpvars(0, CLA_Testbench);

        A = 4'b0011; B = 4'b0101; #10;
        A = 4'b1010; B = 4'b1100; #10;
        A = 4'b0111; B = 4'b0011; #10;
        A = 4'b1111; B = 4'b1111; #10;

        $finish;
    end
endmodule