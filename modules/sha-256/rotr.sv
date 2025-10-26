module rotr
# (
    parameter                    w_rotr = 32,
                                 rot    = 0
)
(
    input                        clk,
    input                        bclk,
    input [$clog2(w_rotr) - 1:0] counter,
    input                        in,
    output logic                 out
);

    logic                        bclk_prev;
    logic         [w_rotr - 1:0] shift_reg = '0;

    always_ff @(posedge clk) begin
        bclk_prev <= bclk;
        if (bclk_prev && !bclk) begin      // Play bit
            out <= shift_reg[w_rotr - 1];
        end
        else if (!bclk_prev && bclk) begin // Record bit
            if (counter < w_rotr - rot)
                shift_reg <= {shift_reg[w_rotr - 2:0], in};
            else
                shift_reg[w_rotr - 1:w_rotr - rot] <= {shift_reg[w_rotr - 2:w_rotr - rot], in};
        end
    end

endmodule
