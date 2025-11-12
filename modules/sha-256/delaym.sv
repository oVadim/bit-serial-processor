module delaym
# (
    parameter                       w_delay = 32,
                                    delay   = 1
)
(
    input                           clk,
    input                           bclk,
    input                           in,
    output logic                    out
);

    logic   [w_delay * delay - 1:0] delay_reg;
    logic                           bclk_prev;

    always_ff @(posedge clk) begin
        bclk_prev <= bclk;
        if (bclk_prev && !bclk)                // Play bit
            out <= delay_reg[w_delay * delay - 1];
        else if (!bclk_prev && bclk)           // Record bit
            delay_reg <= {delay_reg[w_delay * delay - 2:0], in};
    end

endmodule
