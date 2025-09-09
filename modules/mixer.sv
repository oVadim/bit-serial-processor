module mixer
# (
    parameter                        w_mixer = 32
)
(
    input                            clk,
    input                            bclk,
    input                            lrclk,
    input                     [ 6:0] level,
    input                            in,
    output logic                     out,
    output logic     [w_mixer - 1:0] out_p
);

    logic                     [10:0] mix;
    logic                            lrclk_prev;
    logic                            bclk_prev;
    logic                            out_reg;

    wire a, b, c, d, e;

    shift
    # (
        .max_shift   ( 3'd4     )
    )
    i_shift_1
    (
        .bclk        ( bclk     ),
        .clk         ( clk      ),
        .lrclk       ( lrclk    ),
        .shift       ( mix[5:3] ),
        .in          ( in       ),
        .out         ( a        )
    );

    shift
    # (
        .max_shift   ( 3'd5     )
    )
    i_shift_2
    (
        .bclk        ( bclk     ),
        .clk         ( clk      ),
        .lrclk       ( lrclk    ),
        .shift       ( mix[2:0] ),
        .in          ( in       ),
        .out         ( b        )
    );

    shift
    # (
        .max_shift   ( 3'd5     )
    )
    i_shift_3
    (
        .bclk        ( bclk     ),
        .clk         ( clk      ),
        .lrclk       ( lrclk    ),
        .shift       ( {1'b1, ~ mix[10], mix[8] & ~ mix[10]} ),
        .in          ( c        ),
        .out         ( d        )
    );

    delay
    # (
        .max_delay   ( 1'b1     )
    )
    i_delay
    (
        .bclk        ( bclk     ),
        .clk         ( clk      ),
        .lrclk       ( lrclk    ),
        .delay       ( 1'b1     ),
        .in          ( in       ),
        .out         ( c        )
    );

    sum
    # (
        .w_sum       ( w_mixer  )
    )
    i_sum_1
    (
        .bclk        ( bclk     ),
        .clk         ( clk      ),
        .lrclk       ( lrclk    ),
        .in_a        ( a        ),
        .in_b        ( b        ),
        .minus_a     ( 1'b0     ),
        .minus_b     ( mix[6]   ),
        .out         ( e        ),
        .out_p       (          )
    );

    sum
    # (
        .w_sum       ( w_mixer  )
    )
    i_sum_2
    (
        .bclk        ( bclk     ),
        .clk         ( clk      ),
        .lrclk       ( lrclk    ),
        .in_a        ( d        ),
        .in_b        ( e        ),
        .minus_a     ( mix[9]   ),
        .minus_b     ( mix[7]   ),
        .out         ( out      ),
        .out_p       ( out_p    )
    );

    table_mix i_table_mix (.level (level), .mix (mix));

endmodule

module table_mix
(
    input        [ 6:0] level,
    output logic [10:0] mix
);

    always_comb
        case (level)
         0: mix = 11'b10000000010;
         1: mix = 11'b00000000010;
         2: mix = 11'b11000000010;
         3: mix = 11'b11100000010;
         4: mix = 11'b10000000011;
         5: mix = 11'b00000000011;
         6: mix = 11'b11000000011;
         7: mix = 11'b00000000100;
         8: mix = 11'b00000000101;
         9: mix = 11'b00000001001;
        10: mix = 11'b00001000101;
        11: mix = 11'b00001000100;
        12: mix = 11'b11001000100;
        13: mix = 11'b00001000011;
        14: mix = 11'b11001000011;
        15: mix = 11'b11101000011;
        16: mix = 11'b10000001010;
        17: mix = 11'b00000001010;
        18: mix = 11'b11000001010;
        19: mix = 11'b11100001010;
        20: mix = 11'b10000001011;
        21: mix = 11'b00000001011;
        22: mix = 11'b11000001011;
        23: mix = 11'b00000001100;
        24: mix = 11'b00000001101;
        25: mix = 11'b00000010010;
        26: mix = 11'b00001001101;
        27: mix = 11'b00001001100;
        28: mix = 11'b11001001100;
        29: mix = 11'b00000010011;
        30: mix = 11'b11000010011;
        31: mix = 11'b00000010100;
        32: mix = 11'b00000010101;
        33: mix = 11'b00000011011;
        34: mix = 11'b00001010101;
        35: mix = 11'b00000011100;
        36: mix = 11'b00000011101;
        37: mix = 11'b00000100100;
        38: mix = 11'b00001011101;
        39: mix = 11'b00001011100;
        40: mix = 11'b00001100101;
        41: mix = 11'b00001010010;
        42: mix = 11'b00001101100;
        43: mix = 11'b00001010011;
        44: mix = 11'b00001101011;
        45: mix = 11'b00010100100;
        46: mix = 11'b00010011101;
        47: mix = 11'b00010011100;
        48: mix = 11'b00001101010;
        49: mix = 11'b00010011011;
        50: mix = 11'b00010010101;
        51: mix = 11'b00010010100;
        52: mix = 11'b10010010011;
        53: mix = 11'b00010010011;
        54: mix = 11'b00001100001;
        55: mix = 11'b00001100001;
        56: mix = 11'b00001101001;
        57: mix = 11'b00010010010;
        58: mix = 11'b00010001101;
        59: mix = 11'b00010001100;
        60: mix = 11'b10010001011;
        61: mix = 11'b00010001011;
        62: mix = 11'b11010001011;
        63: mix = 11'b10110001010;
        64: mix = 11'b10010001010;
        65: mix = 11'b00010001010;
        66: mix = 11'b11010001010;
        67: mix = 11'b00001011000;
        68: mix = 11'b00001011000;
        69: mix = 11'b00001011000;
        70: mix = 11'b00101100000;
        71: mix = 11'b00001100000;
        72: mix = 11'b00001101000;
        73: mix = 11'b00010001001;
        74: mix = 11'b00010000101;
        75: mix = 11'b00010000100;
        76: mix = 11'b10010000011;
        77: mix = 11'b00010000011;
        78: mix = 11'b11010000011;
        79: mix = 11'b10110000010;
        80: mix = 11'b10010000010;
        81: mix = 11'b00010000010;
        82: mix = 11'b11010000010;
        default: mix = 11'b0;
        endcase

endmodule
