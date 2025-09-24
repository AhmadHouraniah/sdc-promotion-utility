// Test12 top level - Large scale performance test with clean implementation
module top (
    // Top-level clocks
    input wire main_clk_200mhz,
    input wire aux_clk_100mhz,
    input wire slow_clk_25mhz,
    input wire reset_n,
    
    // Wide data interface
    input wire [511:0] ext_data_in,
    output wire [511:0] ext_data_out,
    
    // Control and address
    input wire [31:0] ext_addr,
    input wire [15:0] ext_control,
    output wire [15:0] ext_status,
    
    // Channel interfaces
    input wire [31:0] ext_ch0_data,
    input wire [31:0] ext_ch1_data,
    input wire [31:0] ext_ch2_data,
    input wire [31:0] ext_ch3_data,
    
    output wire [31:0] ext_ch0_result,
    output wire [31:0] ext_ch1_result,
    output wire [31:0] ext_ch2_result,
    output wire [31:0] ext_ch3_result,
    
    // System status
    output wire ext_system_error,
    output wire [7:0] ext_error_code,
    
    // Performance monitoring
    output wire [31:0] ext_perf_counter_0,
    output wire [31:0] ext_perf_counter_1
);

    // Internal signals for IP connection
    wire [31:0] input_data_buses [0:15];
    wire [63:0] memory_bank_addrs [0:7];
    wire [255:0] memory_bank_data_out [0:7];
    wire [127:0] vector_unit_inputs [0:3];
    wire [127:0] vector_unit_outputs [0:3];
    wire [255:0] l1_cache_lines [0:3];
    wire [255:0] l2_cache_lines [0:3];
    
    // Generate input data buses from wide input
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : gen_input_buses
            assign input_data_buses[i] = ext_data_in[(i*32)+31:(i*32)];
        end
    endgenerate
    
    // Generate memory bank addresses
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_memory_addrs
            assign memory_bank_addrs[i] = {ext_addr, ext_addr};
        end
    endgenerate
    
    // Generate vector unit inputs
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_vector_inputs
            assign vector_unit_inputs[i] = ext_data_in[(i*128)+127:(i*128)];
        end
    endgenerate
    
    // Generate cache lines
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_cache_lines
            assign l1_cache_lines[i] = ext_data_in[(i*256)+255:(i*256)];
        end
    endgenerate
    
    // Large scale IP instantiation
    large_scale_ip u_large_scale_ip (
        .clk_main_200mhz(main_clk_200mhz),
        .clk_aux_100mhz(aux_clk_100mhz),
        .clk_slow_25mhz(slow_clk_25mhz),
        .reset_n(reset_n),
        
        .data_in_wide(ext_data_in),
        .data_out_wide(ext_data_out),
        
        .input_data_bus_0000(input_data_buses[0]),
        .input_data_bus_0001(input_data_buses[1]),
        .input_data_bus_0002(input_data_buses[2]),
        .input_data_bus_0003(input_data_buses[3]),
        .input_data_bus_0004(input_data_buses[4]),
        .input_data_bus_0005(input_data_buses[5]),
        .input_data_bus_0006(input_data_buses[6]),
        .input_data_bus_0007(input_data_buses[7]),
        .input_data_bus_0008(input_data_buses[8]),
        .input_data_bus_0009(input_data_buses[9]),
        .input_data_bus_0010(input_data_buses[10]),
        .input_data_bus_0011(input_data_buses[11]),
        .input_data_bus_0012(input_data_buses[12]),
        .input_data_bus_0013(input_data_buses[13]),
        .input_data_bus_0014(input_data_buses[14]),
        .input_data_bus_0015(input_data_buses[15]),
        
        .addr_bus(ext_addr),
        .control_bus(ext_control),
        .status_bus(ext_status),
        
        .channel_0_data(ext_ch0_data),
        .channel_1_data(ext_ch1_data),
        .channel_2_data(ext_ch2_data),
        .channel_3_data(ext_ch3_data),
        .channel_0_result(ext_ch0_result),
        .channel_1_result(ext_ch1_result),
        .channel_2_result(ext_ch2_result),
        .channel_3_result(ext_ch3_result),
        
        .memory_bank_0_addr(memory_bank_addrs[0]),
        .memory_bank_1_addr(memory_bank_addrs[1]),
        .memory_bank_2_addr(memory_bank_addrs[2]),
        .memory_bank_3_addr(memory_bank_addrs[3]),
        .memory_bank_4_addr(memory_bank_addrs[4]),
        .memory_bank_5_addr(memory_bank_addrs[5]),
        .memory_bank_6_addr(memory_bank_addrs[6]),
        .memory_bank_7_addr(memory_bank_addrs[7]),
        
        .memory_bank_0_data(memory_bank_data_out[0]),
        .memory_bank_1_data(memory_bank_data_out[1]),
        .memory_bank_2_data(memory_bank_data_out[2]),
        .memory_bank_3_data(memory_bank_data_out[3]),
        .memory_bank_4_data(memory_bank_data_out[4]),
        .memory_bank_5_data(memory_bank_data_out[5]),
        .memory_bank_6_data(memory_bank_data_out[6]),
        .memory_bank_7_data(memory_bank_data_out[7]),
        
        .vector_unit_0_input(vector_unit_inputs[0]),
        .vector_unit_1_input(vector_unit_inputs[1]),
        .vector_unit_2_input(vector_unit_inputs[2]),
        .vector_unit_3_input(vector_unit_inputs[3]),
        .vector_unit_0_output(vector_unit_outputs[0]),
        .vector_unit_1_output(vector_unit_outputs[1]),
        .vector_unit_2_output(vector_unit_outputs[2]),
        .vector_unit_3_output(vector_unit_outputs[3]),
        
        .pipeline_stage_0_valid(1'b1),
        .pipeline_stage_1_valid(1'b1),
        .pipeline_stage_2_valid(1'b1),
        .pipeline_stage_3_valid(1'b1),
        .pipeline_stage_4_valid(1'b1),
        .pipeline_stage_5_valid(1'b1),
        .pipeline_stage_6_valid(1'b1),
        .pipeline_stage_7_valid(1'b1),
        
        .pipeline_stage_0_ready(),
        .pipeline_stage_1_ready(),
        .pipeline_stage_2_ready(),
        .pipeline_stage_3_ready(),
        .pipeline_stage_4_ready(),
        .pipeline_stage_5_ready(),
        .pipeline_stage_6_ready(),
        .pipeline_stage_7_ready(),
        
        .l1_cache_line_0(l1_cache_lines[0]),
        .l1_cache_line_1(l1_cache_lines[1]),
        .l1_cache_line_2(l1_cache_lines[2]),
        .l1_cache_line_3(l1_cache_lines[3]),
        .l2_cache_line_0(l2_cache_lines[0]),
        .l2_cache_line_1(l2_cache_lines[1]),
        .l2_cache_line_2(l2_cache_lines[2]),
        .l2_cache_line_3(l2_cache_lines[3]),
        
        .dma_ch0_src_addr(32'h1000),
        .dma_ch0_dst_addr(32'h2000),
        .dma_ch0_length(16'h100),
        .dma_ch0_start(1'b0),
        .dma_ch0_done(),
        
        .dma_ch1_src_addr(32'h3000),
        .dma_ch1_dst_addr(32'h4000),
        .dma_ch1_length(16'h200),
        .dma_ch1_start(1'b0),
        .dma_ch1_done(),
        
        .dma_ch2_src_addr(32'h5000),
        .dma_ch2_dst_addr(32'h6000),
        .dma_ch2_length(16'h300),
        .dma_ch2_start(1'b0),
        .dma_ch2_done(),
        
        .dma_ch3_src_addr(32'h7000),
        .dma_ch3_dst_addr(32'h8000),
        .dma_ch3_length(16'h400),
        .dma_ch3_start(1'b0),
        .dma_ch3_done(),
        
        .network_packet_in(64'h0),
        .network_packet_valid(1'b0),
        .network_packet_ready(),
        
        .network_packet_out(),
        .network_packet_out_valid(),
        .network_packet_out_ready(1'b1),
        
        .debug_scan_enable(1'b0),
        .debug_scan_in(128'h0),
        .debug_scan_out(),
        
        .performance_counter_0(ext_perf_counter_0),
        .performance_counter_1(ext_perf_counter_1),
        .performance_counter_2(),
        .performance_counter_3(),
        
        .system_error(ext_system_error),
        .error_code(ext_error_code),
        
        .power_down_request(1'b0),
        .power_down_ack(),
        .voltage_level(2'b11)
    );

endmodule