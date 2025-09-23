// Fixed IP module for malformed constraints test
// This module works properly - the test focuses on malformed SDC constraints
module malformed_test_ip_fixed (
    // Properly defined clock and reset
    input wire clk,
    input wire rst_n,
    
    // Data bus with proper direction
    input wire [7:0] data_bus,
    output wire [7:0] data_output,
    
    // Properly closed bracket signal
    input wire [15:0] bracket_signal,
    
    // Valid range signal
    input wire [7:0] range_signal,
    
    // Valid signals with proper syntax
    input wire valid_signal,
    output wire valid_output,
    
    // Properly escaped special characters
    input wire \\signal$with$escaped$dollars ,
    input wire \\signal/with/escaped/slashes ,
    
    // Properly separated signals
    input wire signal1,
    input wire signal2,
    
    // Additional outputs for testing
    output wire test_output
);

    // Simple logic for testing
    reg [7:0] data_reg;
    reg output_reg;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 8'b0;
            output_reg <= 1'b0;
        end else begin
            data_reg <= data_bus ^ range_signal;
            output_reg <= valid_signal & signal1 & signal2;
        end
    end
    
    assign data_output = data_reg;
    assign valid_output = output_reg;
    assign test_output = |bracket_signal;

endmodule