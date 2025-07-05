module stage1_shift_add (
    input wire clk,
    input wire rst,
    input wire [15:0] in_data,
    input wire [2:0] shift_amt,  // key_bits[5:3]
    output reg [15:0] out_data
);

always @(posedge clk or posedge rst) begin
    if (rst)
        out_data <= 16'd0;
    else
        out_data <= (in_data << shift_amt) + shift_amt;
end

endmodule
