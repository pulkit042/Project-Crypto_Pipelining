module stage2_fsm (
    input wire clk,
    input wire rst,
    input wire [15:0] in_data,
    input wire [1:0] key_bits,  // key_bits[2:1]
    output reg [15:0] out_data,
    output reg [1:0] state
);

// FSM State Definitions
parameter S0 = 2'd0;
parameter S1 = 2'd1;
parameter S2 = 2'd2;
parameter S3 = 2'd3;

reg [1:0] curr_state, next_state;


// FSM Transition Logic
always @(*) begin
    case (curr_state)
        S0: next_state = key_bits ^ 2'b01;
        S1: next_state = key_bits ^ 2'b10;
        S2: next_state = key_bits ^ 2'b11;
        S3: next_state = key_bits;
        default: next_state = S0;
    endcase
end

// FSM Sequential + Output Logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        curr_state <= S0;
        out_data <= 16'd0;
        state <= S0;
    end else begin
        curr_state <= next_state;
        $display("FSM Transition: %0t | From %0d -> %0d | Input: %h", $time, curr_state, next_state, in_data);
        state <= next_state;
        case (curr_state)
            S0: out_data <= (^in_data) ? 16'd1 : 16'd0;
            S1: out_data <= in_data & 16'hAAAA;
            S2: out_data <= in_data | 16'h5555;
            S3: out_data <= {{4{in_data[15]}}, in_data[11:0]};
        endcase
    end
end

endmodule
