module i2s_ser
# (
    parameter                        w_ser               = 16,

    // For the standard I2S, align_right = 0,
    // i.e. value is aligned to the left relative to LRCLK signal,
    // MSB - Most Significant Bit Justified.

    // For PT8211 DAC, align_right = 1 and w_ser = 16,
    // i.e. value is aligned to the right relative to LRCLK signal,
    // LSB - Least Significant Bit Justified.

                                     align_right         = 0,

    // For the standard I2S, offset_by_one_cycle = 1,
    // i.e. value transmission starts with an offset of 1 clock cycle
    // relative to LRCLK signal

    // For PT8211 DAC, offset_by_one_cycle = 0,
    // i.e. value transmission is aligned with LRCLK signal change.

                                     offset_by_one_cycle = 1,

    // Doubling the input signal with overload and distortion
    // if more than the maximum volume is needed

                                     loud                = 0
)
(
    input                            clk,
    input                            bclk,
    input                            lrclk,
    input              [w_ser - 1:0] in,
    output                           sd
);

    logic [w_ser-1+16*align_right:0] shift;
    logic                            start;
    logic                            lrclk_prev;
    logic                            bclk_prev;

    assign sd = shift[w_ser-1+16*align_right];

    always_ff @(posedge clk) begin
        bclk_prev  <= bclk;
        lrclk_prev <= lrclk;
        if (bclk_prev && !bclk) begin
            if (lrclk_prev ^ lrclk)
                start <= 1'b1;
            else
                start <= 1'b0;
            if (offset_by_one_cycle ? start : lrclk_prev ^ lrclk) begin
                if ((in[w_ser - 2] ^ in[w_ser - 1]) && loud)
                    shift <= {in[w_ser - 1], {(w_ser - 1){~in[w_ser - 1]}}};
                else
                    shift <= {in[w_ser - 1], {in[w_ser - 2:0] <<< loud}};
            end
            else
                shift <= shift << 1; // Shift to generate serial data
        end
    end

endmodule
