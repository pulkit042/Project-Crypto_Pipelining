module cryptoveril (
    input wire clk1,
    input wire clk2,
    input wire clk3,
    input wire rst,
    input wire [15:0] input_data,
    input wire [5:0] key_bits,
    output wire [15:0] output_data
);

// --- Stage 1 ---
wire [15:0] stage1_out;
stage1_shift_add s1 (
    .clk(clk1),
    .rst(rst),
    .in_data(input_data),
    .shift_amt(key_bits[5:3]),
    .out_data(stage1_out)
);

// --- Buffer 1 ---
wire [15:0] buffer1_out;
wire valid1;
buffer_reg b1 (
    .clk(clk2),
    .rst(rst),
    .in_data(stage1_out),
    .in_valid(1'b1),
    .out_data(buffer1_out),
    .out_valid(valid1)
);

// --- Stage 2 ---
wire [15:0] stage2_out;
wire [1:0] fsm_state;
stage2_fsm s2 (
    .clk(clk2),
    .rst(rst),
    .in_data(buffer1_out),
    .key_bits(key_bits[2:1]),
    .out_data(stage2_out),
    .state(fsm_state)
);

// --- Buffer 2 ---
wire [15:0] buffer2_out;
wire valid2;
buffer_reg b2 (
    .clk(clk3),
    .rst(rst),
    .in_data(stage2_out),
    .in_valid(valid1),
    .out_data(buffer2_out),
    .out_valid(valid2)
);

// --- Stage 3 ---
stage3_cleanup s3 (
    .clk(clk3),
    .rst(rst),
    .in_data(buffer2_out),
    .fsm_state(fsm_state),
    .out_data(output_data)
);

endmodule
