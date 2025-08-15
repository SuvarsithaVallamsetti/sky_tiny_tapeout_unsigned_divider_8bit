module tt_um_unsigned_divider (
    input  wire clk,           // clock
    input  wire rst_n,         // reset (active low)
    input  wire ena,           // enable
    input  wire [7:0] ui_in,   // ui_in[7:4] = dividend, ui_in[3:0] = divisor
    output reg  [7:0] uo_out   // uo_out[7:4] = quotient, uo_out[3:0] = remainder
);

    reg [3:0] dividend;
    reg [3:0] divisor;
    reg [3:0] quotient;
    reg [3:0] remainder;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dividend <= 4'd0;
            divisor  <= 4'd0;
            quotient <= 4'd0;
            remainder <= 4'd0;
            uo_out <= 8'h00;
        end else if (ena) begin
            dividend <= ui_in[7:4];
            divisor  <= ui_in[3:0];

            if (ui_in[3:0] == 4'b0000) begin
                // divide-by-zero flag
                quotient  <= 4'hF;
                remainder <= 4'hF;
                uo_out <= 8'hFF;
            end else begin
                quotient  <= ui_in[7:4] / ui_in[3:0];
                remainder <= ui_in[7:4] % ui_in[3:0];
                uo_out    <= {quotient, remainder};
            end
        end
    end

endmodule
