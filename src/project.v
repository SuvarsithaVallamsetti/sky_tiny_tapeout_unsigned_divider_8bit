module tt_um_unsigned_divider (
    input  [7:0] ui_in,    // upper 4 bits: dividend, lower 4 bits: divisor
    output [7:0] uo_out,   // upper 4 bits: quotient, lower 4 bits: remainder
    input  [7:0] uio_in,
    output [7:0] uio_out,
    output [7:0] uio_oe,
    input clk,
    input rst_n,
    input ena
);

    reg [3:0] dividend, divisor;
    reg [3:0] quotient, remainder;
    reg [7:0] uo_out_reg;

    assign uo_out = uo_out_reg;
    assign uio_out = 8'd0;
    assign uio_oe = 8'd0;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uo_out_reg <= 8'd0;
        end else if (ena) begin
            dividend  <= ui_in[7:4];
            divisor   <= ui_in[3:0];

            if (ui_in[3:0] == 4'd0) begin
                uo_out_reg <= 8'hFF;
            end else begin
                quotient  <= ui_in[7:4] / ui_in[3:0];
                remainder <= ui_in[7:4] % ui_in[3:0];
                uo_out_reg <= {quotient, remainder};
            end
        end
    end

endmodule
