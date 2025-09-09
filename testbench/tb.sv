`include "config.svh"

module tb;

    timeunit      1ns;
    timeprecision 1ps;

    //------------------------------------------------------------------------

    localparam clk_mhz = 50,
               w_key   = 4,
               w_sw    = 4,
               w_led   = 8,
               w_digit = 8,
               w_sound = 16,
               w_gpio  = 100;

    localparam clk_period = 20ns;

    //------------------------------------------------------------------------

    logic                 clk;
    logic                 rst;
    logic [w_key   - 1:0] key;
    logic [w_sw    - 1:0] sw;
    logic [w_sound - 1:0] sound;
    logic [w_sound - 1:0] sound2;
    logic [          2:0] waveform;

    //------------------------------------------------------------------------

    lab_top
    # (
        .clk_mhz ( clk_mhz ),
        .w_key   ( w_key   ),
        .w_sw    ( w_sw    ),
        .w_led   ( w_led   ),
        .w_digit ( w_digit ),
        // TODO .w_sound ( w_sound ),
        .w_gpio  ( w_gpio  )
    )
    i_lab_top
    (
        .clk      ( clk    ),
        .slow_clk ( clk    ),
        .rst      ( rst    ),
        .key      ( key    ),
        .sw       ( sw     ),
        .sound    ( sound  )
    );

    //------------------------------------------------------------------------

    lab_top
    # (
        .clk_mhz ( clk_mhz ),
        .w_key   ( w_key   ),
        .w_sw    ( w_sw    ),
        .w_led   ( w_led   ),
        .w_digit ( w_digit ),
        // TODO .w_sound ( w_sound ),
        .w_gpio  ( w_gpio  )
    )
    i_lab_top2
    (
        .clk      ( clk    ),
        .slow_clk ( clk    ),
        .rst      ( rst    ),
        .key      ( 4'd2   ),
        .sw       ( sw     ),
        .sound    ( sound2 )
    );

    //------------------------------------------------------------------------

    wire mclk, bclk, lrclk, bclk1, lrclk1, sdata, sdata2;

    i2s_audio_out
    # (
        .clk_mhz  ( clk_mhz ),
        .in_res   ( w_sound ),

        // For the standard I2S, align_right = 0,
        // i.e. value is aligned to the left relative to LRCLK signal,
        // MSB - Most Significant Bit Justified.

        // For PT8211 DAC, align_right = 1,
        // i.e. value is aligned to the right relative to LRCLK signal,
        // LSB - Least Significant Bit Justified.

        .align_right (0),

        // For the standard I2S, offset_by_one_cycle = 1,
        // i.e. value transmission starts with an offset of 1 clock cycle
        // relative to LRCLK signal

        // For PT8211 DAC, offset_by_one_cycle = 0,
        // i.e. value transmission is aligned with LRCLK signal change.

        .offset_by_one_cycle (1)
    )
    i_i2s_audio_out
    (
        .clk      ( clk    ),
        .reset    ( rst    ),
        .data_in  ( sound  ),
        .mclk     ( mclk   ),
        .bclk     ( bclk   ),
        .lrclk    ( lrclk  ),
        .sdata    ( sdata  )
    );

    i2s_audio_out
    # (
        .clk_mhz  ( clk_mhz ),
        .in_res   ( w_sound ),

        // For the standard I2S, align_right = 0,
        // i.e. value is aligned to the left relative to LRCLK signal,
        // MSB - Most Significant Bit Justified.

        // For PT8211 DAC, align_right = 1,
        // i.e. value is aligned to the right relative to LRCLK signal,
        // LSB - Least Significant Bit Justified.

        .align_right (0),

        // For the standard I2S, offset_by_one_cycle = 1,
        // i.e. value transmission starts with an offset of 1 clock cycle
        // relative to LRCLK signal

        // For PT8211 DAC, offset_by_one_cycle = 0,
        // i.e. value transmission is aligned with LRCLK signal change.

        .offset_by_one_cycle (1)
    )
    i_i2s_audio_out2
    (
        .clk         ( clk    ),
        .reset       ( rst    ),
        .data_in     ( sound2 ),
        .mclk        ( mclk   ),
        .bclk        ( bclk   ),
        .lrclk       ( lrclk  ),
        .sdata       ( sdata2 )
    );

    //------------------------------------------------------------------------

    wire a, b, c;

    sum
    # (
        .w_sum       ( 6'd32  )
    )
    i_sum_1
    (
        .bclk        ( bclk   ),
        .clk         ( clk    ),
        .lrclk       ( lrclk  ),
        .in_a        ( sdata  ),
        .in_b        ( sdata2 ),
        .minus_a     ( 1'b0   ),
        .minus_b     ( 1'b0   ),
        .out         ( a      ),
        .out_p       (        )
    );

    shift
    # (
        .max_shift   ( 4'd8   )
    )
    i_shift
    (
        .bclk        ( bclk   ),
        .clk         ( clk    ),
        .lrclk       ( lrclk  ),
        .shift       ( 4'd8   ),
        .in          ( a      ),
        .out         ( b      )
    );

    mixer
    # (
        .w_mixer     ( 6'd32  )
    )
    i_mixer
    (
        .bclk        ( bclk1  ),
        .clk         ( clk    ),
        .lrclk       ( lrclk1 ),
        .level       ( 7'd9   ),
        .in          ( b      ),
        .out         ( c      )
    );

    //------------------------------------------------------------------------

    i2s_clk
    # (
        .clk_mhz     ( clk_mhz )
    )
    i_i2s_clk
    (
        .clk         ( clk     ),
        .rst         ( rst     ),
        .mclk        (         ),
        .bclk        ( bclk1   ),
        .lrclk       ( lrclk1  )
    );

    //------------------------------------------------------------------------

    i2s_des
    # (
        .w_des       ( 6'd24   ),
        .stereo      ( 1'b1    )
    )
    i_i2s_des
    (
        .clk         ( clk     ),
        .bclk        ( bclk1   ),
        .lrclk       ( lrclk1  ),
        .sd          ( c       ),
        .out         (         )
    );

    //------------------------------------------------------------------------

    i2s_ser
    # (
        .w_ser       ( 6'd16   )
    )
    i_i2s_ser
    (
        .clk         ( clk     ),
        .bclk        ( bclk1   ),
        .lrclk       ( lrclk1  ),
        .in          ( sound   ),
        .sd          (         )
    );

    //------------------------------------------------------------------------
    inmp441_mic_i2s_receiver_alt
    # (
        .clk_mhz    ( clk_mhz )
    )
    i_microphone
    (
        .clk        ( clk     ),
        .rst        ( rst     ),
        .right      ( 1'b0    ),
        .lr         (         ),
        .ws         (         ),
        .sck        (         ),
        .sd         ( c       ),
        .value      (         )
    );

    //------------------------------------------------------------------------

    initial
    begin
        clk = 1'b0;

        forever
            # (clk_period / 2) clk = ~ clk;
    end

    //------------------------------------------------------------------------

    initial
    begin
        waveform = 1'd1;

        repeat (2)
            # 0.0024s waveform = waveform << 1;
    end

    assign key = w_key' (waveform);

    //------------------------------------------------------------------------

    initial
    begin
        rst <= 'bx;
        repeat (2) @ (posedge clk);
        rst <= 1;
        repeat (2) @ (posedge clk);
        rst <= 0;
    end

    //------------------------------------------------------------------------

    initial
    begin
        `ifdef __ICARUS__
            $dumpvars;
        `endif

        // Based on timescale is 1 ns / 1 ps

        # 0.0072s

        `ifdef MODEL_TECH  // Mentor ModelSim and Questa
            $stop;
        `else
            $finish;
        `endif
    end

endmodule
