// Test10 top level - Unicode and extreme character edge cases
module top (
    // Top-level clocks
    input wire main_clk_100mhz,
    input wire aux_clk_50mhz,
    input wire reset_n,
    
    // External signals - simplified for top level
    input wire ext_dollar_signal,
    input wire ext_hierarchical_signal,
    input wire ext_very_long_signal,
    input wire [1023:0] ext_ultra_wide_bus,
    input wire [31:0] ext_negative_range_simplified,  // Simplified from [-8:31]
    input wire ext_single_bit,
    input wire [127:0] ext_reversed_range,
    input wire ext_camel_case,
    input wire ext_snake_case,
    input wire ext_mixed_case,
    input wire ext_numeric_signal,
    input wire ext_hex_signal,
    input wire ext_octal_signal,
    
    // External outputs
    output wire ext_out_dollar,
    output wire ext_out_hierarchical,
    output wire ext_out_very_long,
    output wire [1023:0] ext_out_ultra_wide,
    output wire [31:0] ext_out_negative_simplified,
    output wire ext_out_single_bit,
    output wire [127:0] ext_out_reversed,
    output wire ext_out_camel,
    output wire ext_out_snake,
    output wire ext_out_mixed
);

    // Generate internal signals from top-level ones
    wire clk_main_domain_100mhz_primary_oscillator = main_clk_100mhz;
    wire clk_auxiliary_domain_50mhz_secondary_pll_output = aux_clk_50mhz;
    wire reset_system_wide_asynchronous_active_low_synchronized = reset_n;
    
    // Generated clock for testing
    wire \\internal_wire$with/special_chars ;
    reg clk_div = 1'b0;
    always @(posedge main_clk_100mhz or negedge reset_n) begin
        if (!reset_n)
            clk_div <= 1'b0;
        else
            clk_div <= ~clk_div;
    end
    assign \\internal_wire$with/special_chars  = clk_div;

    // Instantiate the unicode edge IP
    unicode_edge_ip ip_inst (
        // Basic clocks
        .clk_main_domain_100mhz_primary_oscillator(clk_main_domain_100mhz_primary_oscillator),
        .clk_auxiliary_domain_50mhz_secondary_pll_output(clk_auxiliary_domain_50mhz_secondary_pll_output),
        .reset_system_wide_asynchronous_active_low_synchronized(reset_system_wide_asynchronous_active_low_synchronized),
        
        // Complex identifiers - mapped from simplified external signals
        .\\signal_with_$_dollar_sign (ext_dollar_signal),
        .\\path/to/hierarchical$signal_name (ext_hierarchical_signal),
        .\\very_long_signal_name_that_exceeds_normal_limits_and_continues_for_testing_maximum_length_handling_in_parser (ext_very_long_signal),
        .\\ultra_wide_bus_signal_with_1024_bits_for_testing_maximum_width_parsing (ext_ultra_wide_bus),
        
        // Corner case ranges - note: simplified mapping for negative range
        .\\negative_range_bus_signal ({ext_negative_range_simplified, 8'b0}),  // Pad to match [-8:31] range
        .\\single_bit_range_signal (ext_single_bit),
        .\\reversed_range_signal (ext_reversed_range),
        
        // Mixed naming conventions
        .CamelCaseSignalName(ext_camel_case),
        .snake_case_signal_name(ext_snake_case),
        .\\mixed$Case/Signal_Name (ext_mixed_case),
        
        // Numeric signals
        .\\signal_123_456_789 (ext_numeric_signal),
        .\\signal_with_0x_prefix (ext_hex_signal),
        .\\signal_0123_octal_like (ext_octal_signal),
        
        // Output mappings
        .\\output_signal_with_$_chars (ext_out_dollar),
        .\\output/hierarchical$path_signal (ext_out_hierarchical),
        .\\output_very_long_signal_name_for_maximum_length_testing (ext_out_very_long),
        .\\output_ultra_wide_bus_1024_bits (ext_out_ultra_wide),
        .\\output_negative_range_bus ({ext_out_negative_simplified}),  // Only connect valid bits
        .\\output_single_bit_signal (ext_out_single_bit),
        .\\output_reversed_range_bus (ext_out_reversed),
        .OutputCamelCaseSignal(ext_out_camel),
        .output_snake_case_signal(ext_out_snake),
        .\\output$Mixed/Case_Signal (ext_out_mixed)
    );

endmodule