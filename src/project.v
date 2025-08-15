// 4-bit unsigned divider packed into TinyTapeout 8-bit IO:
// ui_in[7:4] = dividend, ui_in[3:0] = divisor
// uo_out[7:4] = quotient, uo_out[3:0] = remainder

module tt_um_unsigned_divider (
    input  [7:0] ui_in,
    output [7:0] uo_out,
    input  [7:0] uio_in,
    output [7:0] uio_out,
    output [7:0] uio_oe,
    input        clk,
    input        rst_n,  // active-low reset
    input        ena
);

    // Internal regs
    reg [3:0] dividend, divisor;
    reg [3:0] quotient, remainder;
    reg [7:0] uo_out_reg;

    // Tie off bidirectional IOs (unused) and drive outputs
    assign uo_out  = uo_out_reg;
    assign uio_out = 8'd0;
    assign uio_oe  = 8'd0;

    // Mark uio_in as intentionally unused (silences lint)
    wire _unused_uio_in = &uio_in;  // harmless reduction; uses all bits

    // Sequential logic, fully reset for GL sim
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dividend   <= 4'd0;
            divisor    <= 4'd0;
            quotient   <= 4'd0;
            remainder  <= 4'd0;
            uo_out_reg <= 8'h00;
        end else if (ena) begin
            dividend <= ui_in[7:4];
            divisor  <= ui_in[3:0];

            if (ui_in[3:0] == 4'd0) begin
                // Divide-by-zero flag value expected by tests
                quotient   <= 4'hF;
                remainder  <= 4'hF;
                uo_out_reg <= 8'hFF;
            end else begin
                quotient   <= ui_in[7:4] / ui_in[3:0];
                remainder  <= ui_in[7:4] % ui_in[3:0];
                uo_out_reg <= {quotient, remainder};
            end
        end
    end

endmodule
