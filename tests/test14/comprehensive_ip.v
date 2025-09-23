// Comprehensive IP module for integration testing
module comprehensive_ip (
    // Clock inputs
    input clk_main_200mhz,
    input clk_mem_400mhz,
    input clk_pcie_125mhz,
    input clk_usb_60mhz,
    input reset_n,
    
    // GPIO interface
    input [31:0] gpio_input_data,
    output [31:0] gpio_output_data,
    
    // Memory controller interface
    output [31:0] mem_addr_bus,
    output [127:0] mem_write_data,
    input [127:0] mem_read_data,
    output mem_write_enable,
    output mem_read_enable,
    input mem_ready,
    
    // High-speed serial interface
    input [7:0] serial_rx_data,
    output [7:0] serial_tx_data,
    input serial_rx_valid,
    output serial_tx_valid,
    input serial_rx_ready,
    output serial_tx_ready,
    
    // Control and status
    input [15:0] control_register,
    output [15:0] status_register,
    output interrupt_signal,
    
    // Performance monitoring
    output [31:0] performance_counter_0,
    output [31:0] performance_counter_1,
    output [31:0] performance_counter_2,
    output [31:0] performance_counter_3
);

    // Internal registers and logic
    reg [31:0] gpio_output_reg;
    reg [31:0] mem_addr_reg;
    reg [127:0] mem_data_reg;
    reg mem_wr_en_reg, mem_rd_en_reg;
    reg [7:0] serial_tx_reg;
    reg serial_tx_valid_reg, serial_tx_ready_reg;
    reg [15:0] status_reg;
    reg interrupt_reg;
    reg [31:0] perf_counter_0, perf_counter_1, perf_counter_2, perf_counter_3;
    
    // Clock domain logic
    always @(posedge clk_main_200mhz or negedge reset_n) begin
        if (!reset_n) begin
            gpio_output_reg <= 32'b0;
            status_reg <= 16'b0;
            interrupt_reg <= 1'b0;
            perf_counter_0 <= 32'b0;
        end else begin
            gpio_output_reg <= gpio_input_data ^ control_register[15:0];
            status_reg <= {gpio_input_data[15:0]} ^ control_register;
            interrupt_reg <= |gpio_input_data;
            perf_counter_0 <= perf_counter_0 + 1;
        end
    end
    
    // Memory clock domain
    always @(posedge clk_mem_400mhz or negedge reset_n) begin
        if (!reset_n) begin
            mem_addr_reg <= 32'b0;
            mem_data_reg <= 128'b0;
            mem_wr_en_reg <= 1'b0;
            mem_rd_en_reg <= 1'b0;
            perf_counter_1 <= 32'b0;
        end else begin
            mem_addr_reg <= {gpio_input_data[15:0], control_register};
            mem_data_reg <= {4{gpio_input_data}};
            mem_wr_en_reg <= control_register[0];
            mem_rd_en_reg <= control_register[1];
            perf_counter_1 <= perf_counter_1 + mem_ready;
        end
    end
    
    // PCIe clock domain
    always @(posedge clk_pcie_125mhz or negedge reset_n) begin
        if (!reset_n) begin
            serial_tx_reg <= 8'b0;
            serial_tx_valid_reg <= 1'b0;
            serial_tx_ready_reg <= 1'b0;
            perf_counter_2 <= 32'b0;
        end else begin
            serial_tx_reg <= serial_rx_data ^ control_register[7:0];
            serial_tx_valid_reg <= serial_rx_valid;
            serial_tx_ready_reg <= serial_rx_ready;
            perf_counter_2 <= perf_counter_2 + serial_rx_valid;
        end
    end
    
    // USB clock domain
    always @(posedge clk_usb_60mhz or negedge reset_n) begin
        if (!reset_n) begin
            perf_counter_3 <= 32'b0;
        end else begin
            perf_counter_3 <= perf_counter_3 + control_register[0];
        end
    end
    
    // Output assignments
    assign gpio_output_data = gpio_output_reg;
    assign mem_addr_bus = mem_addr_reg;
    assign mem_write_data = mem_data_reg;
    assign mem_write_enable = mem_wr_en_reg;
    assign mem_read_enable = mem_rd_en_reg;
    assign serial_tx_data = serial_tx_reg;
    assign serial_tx_valid = serial_tx_valid_reg;
    assign serial_tx_ready = serial_tx_ready_reg;
    assign status_register = status_reg;
    assign interrupt_signal = interrupt_reg;
    assign performance_counter_0 = perf_counter_0;
    assign performance_counter_1 = perf_counter_1;
    assign performance_counter_2 = perf_counter_2;
    assign performance_counter_3 = perf_counter_3;

endmodule