//  A testbench for microprogramIII_tb
`timescale 1us/1ns

module microprogramIII_tb;
    reg clock;
    reg reset;
    reg [7:0] IN;
    wire [7:0] OUT;

  microprogramIII microprogramIII_tb0 (
    .clock(clock),
    .reset(reset),
    .IN(IN),
    .OUT(OUT)
  );

  parameter PERIOD = 10;


  initial begin
    $dumpfile("db_microprogramIII_tb.vcd");
    $dumpvars(0, microprogramIII_tb);
    /*
    * Please insert your code as fellow.
    */

    clock = 1'b0;
	
	reset = 1;
	IN = 0;
	#50
	reset = 0;
	#50
	reset = 1;

    #(PERIOD/2);
    forever
      #(PERIOD/2)  clock =~ clock;
  end

  initial
    #100000 $finish;
  endmodule