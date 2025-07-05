module buffer_reg #(
    parameter WIDTH = 16
)(
    input wire clk,
    input wire rst,
    input wire [WIDTH-1:0] in_data,
    input wire in_valid,
    output reg [WIDTH-1:0] out_data,
    output reg out_valid
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out_data <= {WIDTH{1'b0}};
        out_valid <= 1'b0;
    end else if (in_valid) begin
        out_data <= in_data;
        out_valid <= 1'b1;
    end
end

endmodule
