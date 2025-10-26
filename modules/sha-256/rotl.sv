module rotl
# (
    parameter                    w_rotl = 32,
                                 rot    = 0
)
(
    input                        clk,
    input                        bclk,
    input [$clog2(w_rotl) - 1:0] counter,
    input                        in,
    output logic                 out
);

    logic                        bclk_prev;
    logic         [w_rotl - 1:0] shift_reg = '0;

    always_ff @(posedge clk) begin
        bclk_prev <= bclk;
        if (bclk_prev && !bclk) begin      // Play bit
            out <= shift_reg[w_rotl - 1];
        end
        else if (!bclk_prev && bclk) begin // Record bit
            if (counter < rot)
                shift_reg <= {shift_reg[w_rotl - 2:0], in};
            else
                shift_reg[w_rotl - 1:rot - 1] <= {shift_reg[w_rotl - 2:rot - 1], in};
        end
    end

endmodule
