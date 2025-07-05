module cryptoveril_reverse (
    input wire clk1,
    input wire clk2,
    input wire clk3,
    input wire rst,
    input wire [15:0] encrypted_data,
    input wire [5:0] key_bits,
    output reg [15:0] original_data
);

// --- Stage 3 Reverse (Undo cleanup) ---
reg [15:0] stage3_rev;
always @(posedge clk3 or posedge rst) begin
    if (rst) stage3_rev <= 16'd0;
    else begin
        case (key_bits[2:1])
            2'd0: stage3_rev <= encrypted_data; // nothing was added
            2'd3: stage3_rev <= {{4{encrypted_data[11]}}, encrypted_data[11:0]}; // re-extend
            default: stage3_rev <= encrypted_data; // passthrough
        endcase
    end
end

// --- Stage 2 Reverse (Undo FSM logic) ---
reg [15:0] stage2_rev;
always @(posedge clk2 or posedge rst) begin
    if (rst) stage2_rev <= 16'd0;
    else begin
        case (key_bits[2:1])
            2'd0: stage2_rev <= 16'hXXXX; // parity can't be reversed
            2'd1: stage2_rev <= stage3_rev | ~(16'hAAAA); // revert AND
            2'd2: stage2_rev <= stage3_rev & ~(16'h5555); // revert OR
            2'd3: stage2_rev <= {4'd0, stage3_rev[11:0]}; // un-sign-extend
            default: stage2_rev <= stage3_rev;
        endcase
    end
end

// --- Stage 1 Reverse (Undo shift-add) ---
wire [2:0] shift_amt = key_bits[5:3];
always @(posedge clk1 or posedge rst) begin
    if (rst)
        original_data <= 16'd0;
    else
        original_data <= (stage2_rev - shift_amt) >> shift_amt;
end

endmodule
