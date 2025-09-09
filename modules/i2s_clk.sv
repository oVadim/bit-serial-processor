module i2s_clk
# (
    parameter            clk_mhz            = 50,
                         word_select_period = 64
)
(
    input                clk,
    input                rst,
    output logic         mclk,
    output logic         bclk,
    output logic         lrclk
);

    // Standard frequencies are 12.288 MHz, 3.072 MHz and 48 KHz.
    // We are using frequencies somewhat higher
    // but with the same relationship 256:64:1.

    // We are grouping together clk_mhz ranges of
    // (9-12) (13-20), (21-36), (37-68), (69-132).

    localparam LRCLK_BIT = $clog2(clk_mhz - 4) + 4,
               BCLK_BIT  = LRCLK_BIT - $clog2(word_select_period),
               MCLK_BIT  = LRCLK_BIT - 8;

    logic   [LRCLK_BIT   - 1:0] clk_div = '0;

    generate

        if (MCLK_BIT > 0)
        begin : gen_MCLK_BIT
            assign mclk = clk_div [MCLK_BIT - 1];
        end
        else
        begin : gen_not_MCLK_BIT
            assign mclk = clk;
        end

    endgenerate

    assign bclk  = clk_div [BCLK_BIT  - 1];
    assign lrclk = clk_div [LRCLK_BIT - 1];

    always_ff @ (posedge clk or posedge rst)
        if (rst)
            clk_div <= '0;
        else
            clk_div <= clk_div + 1'd1;

endmodule
