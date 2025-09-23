// Test11 top level - Malformed constraints test
// Note: This test is for validating error handling in SDC promotion
module top (
    // Top-level clocks (simple and working)
    input wire clk,
    input wire rst_n,
    
    // Simple signals for basic connectivity
    input wire [7:0] data_input,
    input wire [15:0] bracket_input,
    input wire [7:0] range_input,
    input wire valid_input,
    input wire signal1_input,
    input wire signal2_input,
    input wire dollar_input,
    input wire slash_input,
    
    output wire [7:0] data_output,
    output wire valid_output,
    output wire test_output
);

    // Instantiate the fixed IP module (working Verilog)
    // The malformed constraints will be tested against this working design
    malformed_test_ip_fixed ip_inst (
        .clk(clk),
        .rst_n(rst_n),
        .data_bus(data_input),
        .data_output(data_output),
        .bracket_signal(bracket_input),
        .range_signal(range_input),
        .valid_signal(valid_input),
        .valid_output(valid_output),
        .\\signal$with$escaped$dollars (dollar_input),
        .\\signal/with/escaped/slashes (slash_input),
        .signal1(signal1_input),
        .signal2(signal2_input),
        .test_output(test_output)
    );

endmodule