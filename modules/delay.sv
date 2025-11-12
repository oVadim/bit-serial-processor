module delay
# (
    parameter                           w_delay   = 32,
                                        max_delay = 1
)
(
    input                               clk,
    input                               bclk,
    input                               lrclk,
    input [$clog2(max_delay + 1) - 1:0] delay,
    input                               in,
    output logic                        out
);

    logic [$clog2(max_delay + 1) - 1:0] delay_buf;
    logic   [w_delay * max_delay - 1:0] delay_reg;
    logic                               lrclk_prev;
    logic                               bclk_prev;
    logic                               out_reg;
    logic                         [1:0] start;

    assign out = delay_buf ? delay_buf > max_delay ? 1'b0 : out_reg : in;

    always_ff @(posedge clk) begin
        bclk_prev <= bclk;
        if (bclk_prev && !bclk) begin      // Play bit
            lrclk_prev <= lrclk;
            out_reg <= delay_reg[w_delay * delay_buf - 1];
            if (lrclk_prev ^ lrclk)        // lrclk change
                start <= 2'b1;
            else if (start == 2'b1)
                start <= start + 1'b1;     // Offset counter for I2S
            else
                start <= 2'b0;
        end
        else if (!bclk_prev && bclk) begin // Record bit
            delay_reg <= {delay_reg[w_delay * max_delay - 2:0], in};
            if (start == 2'd2)             // Offset by one cycle for I2S
                delay_buf <= delay;
        end
    end

endmodule
