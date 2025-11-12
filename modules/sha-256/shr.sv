module shr
# (
    parameter                   w_shr = 32,
                                shr   = 0
)
(
    input                       clk,
    input                       bclk,
    input [$clog2(w_shr) - 1:0] counter,
    input                       in,
    output logic                out
);

    logic                       bclk_prev;
    logic         [w_shr - 1:0] shift_reg;

    always_ff @(posedge clk) begin
        bclk_prev <= bclk;
        if (bclk_prev && !bclk) begin          // Play bit
            out <= shift_reg[w_shr - 1];
        end
        else if (!bclk_prev && bclk) begin     // Record bit
            if (counter > w_shr - shr - 1)
                shift_reg[w_shr - 1:w_shr - shr] <= shift_reg[w_shr - 1:w_shr - shr] << 1;
            else
                shift_reg <= {shift_reg[w_shr - 2:0], in};
        end
    end

endmodule
