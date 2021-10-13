//  A testbench for sample1_tb
`timescale 1us/1ns

module sample1_tb;
    reg [1:0] A1;
    reg [1:0] A2;
    reg [1:0] A3;
    wire [1:0] Y;

  sample1 sample10 (
    .A1(A1),
    .A2(A2),
    .A3(A3),
    .Y(Y)
  );

    reg [7:0] patterns[0:15];
    integer i;

    initial begin
      patterns[0] = 8'b00_00_00_00;
      patterns[1] = 8'b00_01_00_00;
      patterns[2] = 8'b00_10_00_00;
      patterns[3] = 8'b00_11_00_00;
      patterns[4] = 8'b01_00_00_00;
      patterns[5] = 8'b01_01_00_01;
      patterns[6] = 8'b01_10_00_00;
      patterns[7] = 8'b01_11_00_01;
      patterns[8] = 8'b10_00_00_00;
      patterns[9] = 8'b10_01_00_00;
      patterns[10] = 8'b10_10_00_10;
      patterns[11] = 8'b10_11_00_10;
      patterns[12] = 8'b11_00_00_00;
      patterns[13] = 8'b11_01_00_01;
      patterns[14] = 8'b11_10_00_10;
      patterns[15] = 8'b11_11_00_11;

      for (i = 0; i < 16; i = i + 1)
      begin
        A1 = patterns[i][7:6];
        A2 = patterns[i][5:4];
        A3 = patterns[i][3:2];
        #10;
        if (patterns[i][1:0] !== 2'hx)
        begin
          if (Y !== patterns[i][1:0])
          begin
            $display("%d:Y: (assertion error). Expected %h, found %h", i, patterns[i][1:0], Y);
            $finish;
          end
        end
      end

      $display("All tests passed.");
    end
    endmodule
