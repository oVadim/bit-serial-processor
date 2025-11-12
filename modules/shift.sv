module shift
# (
    parameter                           max_shift = 7
)
(
    input                               clk,
    input                               bclk,
    input                               lrclk,
    input [$clog2(max_shift + 1) - 1:0] shift,
    input                               in,
    output logic                        out
);

    logic [$clog2(max_shift + 1) - 1:0] shift_buf;
    logic             [max_shift - 1:0] shift_reg;
    logic                               lrclk_prev;
    logic                               bclk_prev;
    logic                               out_reg;
    logic                         [1:0] start;

    assign out = (shift_buf > max_shift) ? 1'b0 :
                          (start == 2'd2 ? in : (shift_buf ? out_reg : in));

    always_ff @(posedge clk) begin
        bclk_prev <= bclk;
        if (bclk_prev && !bclk) begin         // Play bit
            lrclk_prev <= lrclk;
            out_reg    <= shift_reg[shift_buf - 1];
            if (lrclk_prev ^ lrclk)           // lrclk change
                start  <= 2'b1;
            else if (start == 2'b1)
                start  <= start + 1'b1;       // Offset counter for I2S
            else
                start  <= 2'b0;
        end
        else if (!bclk_prev && bclk) begin    // Record bit
            if (start == 2'd2) begin          // Offset by one cycle for I2S
                shift_buf <= shift;
                shift_reg <= {max_shift{in}}; // Arithmetic shift
            end
            else
                shift_reg <= {shift_reg[max_shift - 2:0], in};
        end
    end

endmodule
