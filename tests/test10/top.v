// Test10 top level - Unicode and extreme character edge cases - Clean implementation
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
    input wire [31:0] ext_negative_range_simplified,
    input wire ext_single_bit,
    input wire [127:0] ext_reversed_range,
    input wire ext_camel_case,
    input wire ext_snake_case,
    input wire ext_mixed_case,
    input wire ext_numeric_signal,
    input wire ext_hex_signal,
    input wire ext_octal_signal,
    
    // External outputs
    output wire [1023:0] ext_out_ultra_wide,
    output wire ext_out_complex_signal,
    output wire [31:0] ext_out_negative_simplified,
    
    // Bidirectional
    inout wire [127:0] ext_bidir_bus,
    inout wire ext_bidir_single
);

    // Internal signals
    wire internal_wire_with_special_chars;
    wire [39:0] extended_negative_range;
    
    // Extend input to match IP requirements
    assign extended_negative_range = {8'b0, ext_negative_range_simplified};
    
    // IP instantiation
    unicode_edge_ip u_unicode_edge_ip (
        .clk_main_domain_100mhz_primary_oscillator(main_clk_100mhz),
        .clk_auxiliary_domain_50mhz_secondary_pll_output(aux_clk_50mhz),
        .reset_system_wide_asynchronous_active_low_synchronized(reset_n),
        
        .signal_with_dollar_sign(ext_dollar_signal),
        .path_to_hierarchical_signal_name(ext_hierarchical_signal),
        .very_long_signal_name_that_exceeds_normal_limits_and_continues_for_testing_maximum_length_handling_in_parser(ext_very_long_signal),
        .ultra_wide_bus_signal_with_1024_bits_for_testing_maximum_length_handling_in_parser(ext_ultra_wide_bus),
        
        .negative_range_bus_signal(extended_negative_range),
        .single_bit_range_signal(ext_single_bit),
        .reversed_range_signal(ext_reversed_range),
        
        .CamelCaseSignalName(ext_camel_case),
        .snake_case_signal_name(ext_snake_case),
        .mixed_case_signal_name(ext_mixed_case),
        
        .signal_123_456_789(ext_numeric_signal),
        .signal_with_0x_prefix(ext_hex_signal),
        .signal_0123_octal_like(ext_octal_signal),
        
        .output_ultra_wide_bus_1024_bits(ext_out_ultra_wide),
        .complex_output_signal_path(ext_out_complex_signal),
        .negative_output_range(ext_out_negative_simplified),
        
        .bidirectional_bus_with_long_name_for_testing_parser_limits(ext_bidir_bus),
        .bidir_special_char_signal(ext_bidir_single)
    );

endmodule