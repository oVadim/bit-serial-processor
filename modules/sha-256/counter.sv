module counter
# (
    parameter                               w_counter = 32
)
(
    input                                   clk,
    input                                   bclk,
    input                                   lrclk,
    output logic  [$clog2(w_counter) - 1:0] counter
);

    logic                                   lrclk_prev;
    logic                                   bclk_prev;
    logic                                   start;

    always_ff @(posedge clk) begin
        bclk_prev <= bclk;
        if (bclk_prev && !bclk) begin // Play bit
            lrclk_prev <= lrclk;
            counter    <= start ? '0 : counter + 1'b1;
            if (lrclk_prev ^ lrclk)   // lrclk change
                start  <= 1'b1;
            else
                start  <= 1'b0;
        end
    end

endmodule
