`timescale 1ns/1ps

module tb;

    reg  [7:0] ui_in;
    wire [7:0] uo_out;
    reg  [7:0] uio_in;
    wire [7:0] uio_out;
    wire [7:0] uio_oe;
    reg clk;
    reg rst_n;
    reg ena;

    integer dividend, divisor;
    reg [3:0] exp_q, exp_r;

    tt_um_unsigned_divider dut (
        .ui_in(ui_in),
        .uo_out(uo_out),
        .uio_in(uio_in),
        .uio_out(uio_out),
        .uio_oe(uio_oe),
        .clk(clk),
        .rst_n(rst_n),
        .ena(ena)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    initial begin
        $display("Starting Verilog TB...");
        clk = 0; rst_n = 0; ena = 1;
        uio_in = 8'h00; ui_in = 8'h00;

        #20 rst_n = 1;

        for (dividend = 0; dividend < 16; dividend = dividend + 1) begin
            for (divisor = 1; divisor < 16; divisor = divisor + 1) begin
                ui_in = {dividend[3:0], divisor[3:0]}; // [7:4]=dividend, [3:0]=divisor
                @(posedge clk);
                @(posedge clk);
                exp_q = dividend / divisor;
                exp_r = dividend % divisor;
                if (uo_out !== {exp_q, exp_r}) begin
                    $display("FAIL %0d/%0d → got Q=%0d R=%0d exp Q=%0d R=%0d",
                        dividend, divisor, uo_out[7:4], uo_out[3:0], exp_q, exp_r);
                    $stop;
                end
            end
        end

        // Divide-by-zero
        ui_in = {4'd5, 4'd0};
        @(posedge clk); @(posedge clk);
        if (uo_out !== 8'hFF) begin
            $display("FAIL div-by-zero → got %h exp FF", uo_out);
            $stop;
        end

        $display("All tests passed!");
        $finish;
    end

endmodule
