//  A testbench for adder_tb
`timescale 1us/1ns

module adder_tb;
    reg A;
    reg B;
    reg \C_{i-1} ;
    wire C_i;
    wire S;

  adder adder_tb0 (
    .A(A),
    .B(B),
    .\C_{i-1} (\C_{i-1} ),
    .C_i(C_i),
    .S(S)
  );

  parameter PERIOD = 10;


  initial begin
    $dumpfile("db_adder_tb.vcd");
    $dumpvars(0, adder_tb);
    /*
    * Please insert your code as fellow.
    */

	A = 1;
	B = 0;
	\C_{i-1} = 1;

  end

  initial
    #100000 $finish;
  endmodule