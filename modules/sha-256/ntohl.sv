module ntohl
(
    input                        clk,
    input                        bclk,
    input                  [4:0] counter,
    input                        in,
    output logic                 out
);

    logic                        bclk_prev;
    logic                 [31:0] shift_reg = '0;

    always_ff @(posedge clk) begin
        bclk_prev <= bclk;
        if (bclk_prev && !bclk) begin      // Play bit
            out <= shift_reg[31];
        end
        else if (!bclk_prev && bclk) begin // Record bit
            if (counter < 8)
                shift_reg <= {shift_reg[30:0], in};
            else if (counter < 16)
                shift_reg[31:8] <= {shift_reg[30:8], in};
            else if (counter < 24)
                shift_reg[31:16] <= {shift_reg[30:16], in};
            else
                shift_reg[31:24] <= {shift_reg[30:24], in};
        end
    end

endmodule
