module stage3_cleanup (
    input wire clk,
    input wire rst,
    input wire [15:0] in_data,
    input wire [1:0] fsm_state,
    output reg [15:0] out_data
);

always @(posedge clk or posedge rst) begin
    if (rst)
        out_data <= 16'd0;
    else begin
        case (fsm_state)
            2'd0: out_data <= 16'd0;                    // parity removed
            2'd1: out_data <= in_data;
            2'd2: out_data <= in_data;
            2'd3: out_data <= {4'd0, in_data[11:0]};    // trim extended bits
            default: out_data <= in_data;
        endcase
    end
end

endmodule
