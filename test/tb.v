`timescale 1ns / 1ps

module tb;

    reg  [7:0] ui_in = 0;
    reg  [7:0] uio_in = 0;
    reg clk = 0;
    reg rst_n = 1;
    reg ena = 1;

    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

   tt_um_unsigned_divider uut (
    .ui_in(ui_in),
    .uo_out(uo_out),
    .uio_in(uio_in),
    .uio_out(uio_out),
    .uio_oe(uio_oe),
    .clk(clk),
    .rst_n(rst_n),
    .ena(ena)
);


    always #5 clk = ~clk;

endmodule
