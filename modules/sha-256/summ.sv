module summ
# (
    parameter                    w_sum = 32
)
(
    input                        clk,
    input                        bclk,
    input  [$clog2(w_sum) - 1:0] counter,
    input                        in_a,         // Input a bit
    input                        in_b,         // Input b bit
    output logic                 out           // Output bit
);

    logic          [w_sum - 1:0] sum;          // Sum bits
    logic          [w_sum - 2:0] carry;        // Сarry bits
    logic          [w_sum - 2:0] carry_ready;  // Сarry distribution area
    logic                        lrclk_prev;
    logic                        bclk_prev;

    always_ff @(posedge clk) begin
        bclk_prev <= bclk;
        if (bclk_prev && !bclk) begin          // Play bit
            if (counter < w_sum - 1)
                out <= sum[w_sum - 1] ^ ((counter == w_sum - 2) ? 1'b0 : carry[w_sum - 2]);
            else
                carry_ready <= '0;
        end
        else if (!bclk_prev && bclk) begin     // Record bit
            sum <= {sum[w_sum - 2:0], in_a ^ in_b};
            if (counter == w_sum - 1)
                carry <= carry << 1;
            else begin
                carry_ready <= {carry_ready[w_sum - 3:0]
                                & {w_sum - 2{in_a ^ in_b}}, in_a ^ in_b};
                carry <= {carry[w_sum - 3:0] | (carry_ready[w_sum - 3:0]
                                & {w_sum - 2{in_a & in_b}}), in_a & in_b};
            end
        end
    end

endmodule
