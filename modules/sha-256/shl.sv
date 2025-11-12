module shl
# (
    parameter                   w_shl = 32,
                                shl   = 0
)
(
    input                       clk,
    input                       bclk,
    input [$clog2(w_shl) - 1:0] counter,
    input                       in,
    output logic                out
);

    logic                bclk_prev;
    logic  [w_shl - 1:0] shift_reg = '0;

    always_ff @(posedge clk) begin
        bclk_prev <= bclk;
        if (bclk_prev && !bclk) begin      // Play bit
            out <= shift_reg[w_shl - 1];
        end
        else if (!bclk_prev && bclk) begin // Record bit
            if (counter < shl)
                shift_reg <= {shift_reg[w_shl - 2:0], in};
            else if (shl == w_shl - 1)
                shift_reg[w_shl - 1] <= in;
            else
                shift_reg[w_shl - 1:shl] <= {shift_reg[w_shl - 2:shl], in};
        end
    end

endmodule
