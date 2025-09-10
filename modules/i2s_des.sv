module i2s_des
# (
    parameter                   w_des  = 24
)
(
    input                       clk,
    input                       bclk,
    input                       lrclk,
    input                       sd,
    output logic  [w_des - 1:0] out_l,
    output logic  [w_des - 1:0] out_r
);

    logic         [w_des - 1:0] shift   = '0;
    logic [$clog2(w_des + 1):0] counter = '0;
    logic                       bclk_prev;
    logic                       lrclk_prev;

    always_ff @(posedge clk) begin
        bclk_prev <= bclk;
        if (bclk_prev && !bclk) begin
            counter <= counter + 1'b1;
            if (!counter) begin
                if (lrclk)
                out_l <= shift;
                else
                out_r <= shift;
            end
        end
        else if (!bclk_prev && bclk) begin  // Record bit
            lrclk_prev  <= lrclk;
            if (lrclk_prev ^ lrclk)         // lrclk change
                counter <= '0;
            if (counter && counter <= w_des)
                shift   <= {shift[w_des - 2:0], sd};
        end
    end

endmodule
