`timescale 1ns / 1ps

module tb;

    // Inputs to DUT
    reg  [7:0] ui_in;
    reg  [7:0] uio_in;   // Must be driven, even if unused
    reg        clk;
    reg        rst_n;
    reg        ena;

    // Outputs from DUT
    wire [7:0] uo_out;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;

    // Instantiate the DUT
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

    // Clock generation: 100 MHz
    always #5 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize signals
        clk    = 0;
        rst_n  = 0;
        ena    = 1;
        ui_in  = 0;
        uio_in = 8'b0;   // Tie unused IO to zero to avoid lint warning

        // Reset pulse
        #20;
        rst_n = 1;

        // Test case 1: divide 100 / 5
        ui_in = {4'd5, 4'd10}; // [7:4] divisor = 5, [3:0] dividend = 10
        #20;

        // Test case 2: divide 15 / 3
        ui_in = {4'd3, 4'd15};
        #20;

        // Test case 3: divide 8 / 2
        ui_in = {4'd2, 4'd8};
        #20;

        // Finish simulation
        $finish;
    end

endmodule
