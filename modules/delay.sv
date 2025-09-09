module delay
# (
    parameter                           max_delay = 1
)
(
    input                               clk,
    input                               bclk,
    input                               lrclk,
    input [$clog2(max_delay + 1) - 1:0] delay,
    input                               in,
    output logic                        out
);

    localparam W_OUT_SER = 32;

    logic [$clog2(max_delay + 1) - 1:0] delay_buf = '0;
    logic [W_OUT_SER * max_delay - 1:0] delay_reg = '0;
    logic                               lrclk_prev;
    logic                               bclk_prev;
    logic                               out_reg   = '0;

    assign out = delay_buf ? delay_buf > max_delay ? 1'b0 : out_reg : in;

    always_ff @(posedge clk) begin
        bclk_prev     <= bclk;
        if (bclk_prev && !bclk) begin   // Play bit
            lrclk_prev    <= lrclk;
            out_reg       <= delay_reg[W_OUT_SER * delay_buf - 1];
            if (lrclk_prev ^ lrclk)     // lrclk change
                delay_buf <= delay;
        end
        else if (!bclk_prev && bclk)    // Record bit
            delay_reg     <= {delay_reg[W_OUT_SER * max_delay - 2:0], in};
    end

endmodule
