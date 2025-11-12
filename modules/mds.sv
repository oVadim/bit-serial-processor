module mds
# (
    parameter          shift = 5,
                       delay = 8
)
(
    input              clk,
    input              bclk,
    input              lrclk,
    input              in,
    input              line,
    output logic       out
);

    wire a, b;

    shift
    # (
        .max_shift   ( shift    )
    )
    i_shift
    (
        .clk         ( clk      ),
        .bclk        ( bclk     ),
        .lrclk       ( lrclk    ),
        .shift       ( shift    ),
        .in          ( in       ),
        .out         ( a        )
    );

    sum
    # (
        .w_sum       ( shift + 5'd24 )
    )
    i_sum
    (
        .clk         ( clk      ),
        .bclk        ( bclk     ),
        .lrclk       ( lrclk    ),
        .in_a        ( a        ),
        .in_b        ( line     ),
        .minus_a     ( 1'b0     ),
        .minus_b     ( 1'b0     ),
        .out         ( b        ),
        .out_p       (          )
    );

    delay
    # (
        .max_delay   ( delay    )
    )
    i_delay
    (
        .clk         ( clk      ),
        .bclk        ( bclk     ),
        .lrclk       ( lrclk    ),
        .delay       ( delay    ),
        .in          ( b        ),
        .out         ( out      )
    );

endmodule
