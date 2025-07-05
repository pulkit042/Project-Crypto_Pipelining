`timescale 1ns / 1ps

module cryptoveril_tb;

    reg clk1 = 0, clk2 = 0, clk3 = 0;
    reg rst;
    reg [15:0] input_data;
    reg [5:0] key_bits;
    wire [15:0] output_data;

    cryptoveril uut (
        .clk1(clk1),
        .clk2(clk2),
        .clk3(clk3),
        .rst(rst),
        .input_data(input_data),
        .key_bits(key_bits),
        .output_data(output_data)
    );

    // Clocks
    always #5  clk1 = ~clk1;   // 100 MHz
    always #15 clk2 = ~clk2;   // 33 MHz
    always #45 clk3 = ~clk3;   // 11 MHz

    initial begin
        $dumpfile("fsm_trace.vcd");
        $dumpvars(0, cryptoveril_tb);
        
        $dumpfile("dump.vcd");
        $dumpvars(0, cryptoveril_tb);

        rst = 1;
        input_data = 0;
        key_bits = 0;
        #50;
        rst = 0;

        // Test Case 1
        input_data = 16'h1234; // 0001 0010 0011 0100
        key_bits = 6'b001_01_0; // Shift 1, FSM S1
        #200;

        // Test Case 2
        input_data = 16'hABCD;
        key_bits = 6'b100_11_0; // Shift 4, FSM S3
        #200;

        // Test Case 3
        input_data = 16'hFFFF;
        key_bits = 6'b010_00_0; // Shift 2, FSM S0 (parity check)
        #200;

        $finish;
    end

endmodule
