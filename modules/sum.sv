module sum
# (
    parameter                    w_sum = 32
)
(
    input                        clk,
    input                        bclk,
    input                        lrclk,
    input                        in_a,         // Input a bit
    input                        in_b,         // Input b bit
    input                        minus_a,      // Input a will be inverted
    input                        minus_b,      // Input b will be inverted
    output logic                 out,          // Output bit
    output logic   [w_sum - 1:0] out_p         // Output byte
);

    logic                        a;
    logic                        b;
    logic          [w_sum - 1:0] sum;          // Sum bits
    logic          [w_sum - 2:0] carry;        // Сarry bits
    logic          [w_sum - 2:0] carry_ready;  // Сarry distribution area
    logic  [$clog2(w_sum + 1):0] counter;
    logic                        lrclk_prev;
    logic                        bclk_prev;
    logic                        minus;

    assign a     = in_a ^ minus_a;
    assign b     = in_b ^ minus_b;
    assign minus = minus_a | minus_b;          // + 1

    always_ff @(posedge clk) begin
        bclk_prev <= bclk;
        if (bclk_prev && !bclk) begin          // Play bit
            counter <= counter + 1'b1;
            if (counter < w_sum)
                out <= sum[w_sum - 1] ^ ((counter == w_sum - 1) ? minus : carry[w_sum - 2]);
            else if (counter == w_sum)
                out <= 1'b0;
            if (!counter) begin
                out_p <= sum ^ {carry[w_sum - 2:0], minus};
                carry_ready <= '0;
            end
        end
        else if (!bclk_prev && bclk) begin     // Record bit
            lrclk_prev <= lrclk;
            if (lrclk_prev ^ lrclk)            // lrclk change
                counter <= '0;
            if (counter && (counter <= w_sum)) begin
                sum <= {sum[w_sum - 2:0], a ^ b};
                if (counter == w_sum)
                    carry <= {carry[w_sum - 3:0] | (carry_ready[w_sum - 3:0] & {w_sum - 2{minus}}), minus};
                else begin
                    carry_ready <= {carry_ready[w_sum - 3:0] & {w_sum - 2{a ^ b}}, a ^ b};
                    carry <= {carry[w_sum - 3:0] | (carry_ready[w_sum - 3:0] & {w_sum - 2{a & b}}), a & b};
                end
            end
        end
    end

endmodule
