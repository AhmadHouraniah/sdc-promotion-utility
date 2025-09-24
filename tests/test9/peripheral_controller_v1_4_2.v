// Peripheral controller v1.4.2 - Clean Verilog implementation
module peripheral_controller_v1_4_2 (
    // Clocks - multiple clock domains
    input clk_periph_100mhz,
    input clk_periph_50mhz,
    input clk_periph_25mhz_generated,
    input rst_periph_domain_n_sync,
    
    // APB interface - standard
    input [31:0] apb_paddr,
    input apb_psel_qualified,
    input apb_penable_sync,
    input apb_pwrite_direction,
    input [31:0] apb_pwdata,
    output [31:0] apb_prdata,
    output apb_pready_response,
    output apb_pslverr_indicator,
    
    // GPIO interface - various widths
    input [31:0] gpio_bank_a_input_pins,
    output [31:0] gpio_bank_a_output_pins,
    output [31:0] gpio_bank_a_output_enable,
    input [15:0] gpio_bank_b_input_pins,
    output [15:0] gpio_bank_b_output_pins,
    output [15:0] gpio_bank_b_output_enable,
    
    // SPI interfaces - multiple instances
    output spi_master_inst0_sclk_out,
    output spi_master_inst0_mosi_data,
    input spi_master_inst0_miso_data,
    output [7:0] spi_master_inst0_cs_n,
    
    output spi_master_inst1_sclk_out,
    output spi_master_inst1_mosi_data,
    input spi_master_inst1_miso_data,
    output [3:0] spi_master_inst1_cs_n,
    
    // UART interfaces
    input uart0_rxd_input_synchronized,
    output uart0_txd_output_registered,
    output uart0_rts_n_flow_control,
    input uart0_cts_n_external,
    
    input uart1_rxd_in_qualified,
    output uart1_txd_out_buffered,
    output uart1_rts_n_generated,
    input uart1_cts_n_filtered,
    
    // Timer interfaces - multiple instances
    output [31:0] timer_block_0_compare_value,
    output [31:0] timer_block_0_current_count,
    output timer_block_0_overflow_flag,
    output timer_block_0_match_interrupt,
    
    output [31:0] timer_block_1_compare_value,
    output [31:0] timer_block_1_current_count,
    output timer_block_1_overflow_flag,
    output timer_block_1_match_interrupt,
    
    // PWM outputs - multiple channels
    output [7:0] pwm_module_channel_output,
    output [7:0] pwm_module_channel_enable,
    output pwm_module_sync_pulse,
    
    // DMA interface for memory transfers
    output [31:0] dma_controller_source_addr,
    output [31:0] dma_controller_dest_addr,
    output [15:0] dma_controller_transfer_count,
    output dma_controller_transfer_start,
    input dma_controller_transfer_done,
    input dma_controller_transfer_error,
    
    // Interrupt aggregation
    output [15:0] interrupt_ctrl_pending_mask,
    output [15:0] interrupt_ctrl_enable_mask,
    output interrupt_ctrl_global_interrupt,
    
    // Test and debug interface
    input test_debug_scan_enable,
    input [31:0] test_debug_scan_in,
    output [31:0] test_debug_scan_out
);

    // Internal register bank
    reg [31:0] gpio_a_output_reg, gpio_a_enable_reg;
    reg [15:0] gpio_b_output_reg, gpio_b_enable_reg;
    reg [31:0] apb_read_data_reg;
    reg apb_ready_reg, apb_error_reg;
    reg [31:0] timer0_compare_reg, timer0_count_reg;
    reg [31:0] timer1_compare_reg, timer1_count_reg;
    reg timer0_overflow, timer0_match, timer1_overflow, timer1_match;
    reg [7:0] pwm_output_reg, pwm_enable_reg;
    reg pwm_sync_reg;
    reg [31:0] dma_src_reg, dma_dst_reg;
    reg [15:0] dma_count_reg;
    reg dma_start_reg;
    reg [15:0] irq_pending_reg, irq_enable_reg;
    reg global_irq_reg;
    reg [31:0] scan_out_reg;
    
    // APB register access logic
    always @(posedge clk_periph_100mhz or negedge rst_periph_domain_n_sync) begin
        if (!rst_periph_domain_n_sync) begin
            gpio_a_output_reg <= 32'h0;
            gpio_a_enable_reg <= 32'h0;
            gpio_b_output_reg <= 16'h0;
            gpio_b_enable_reg <= 16'h0;
            apb_read_data_reg <= 32'h0;
            apb_ready_reg <= 1'b0;
            apb_error_reg <= 1'b0;
            timer0_compare_reg <= 32'h0;
            timer0_count_reg <= 32'h0;
            timer1_compare_reg <= 32'h0;
            timer1_count_reg <= 32'h0;
            timer0_overflow <= 1'b0;
            timer0_match <= 1'b0;
            timer1_overflow <= 1'b0;
            timer1_match <= 1'b0;
            pwm_output_reg <= 8'h0;
            pwm_enable_reg <= 8'h0;
            pwm_sync_reg <= 1'b0;
            dma_src_reg <= 32'h0;
            dma_dst_reg <= 32'h0;
            dma_count_reg <= 16'h0;
            dma_start_reg <= 1'b0;
            irq_pending_reg <= 16'h0;
            irq_enable_reg <= 16'h0;
            global_irq_reg <= 1'b0;
            scan_out_reg <= 32'h0;
        end else begin
            // APB write access
            if (apb_psel_qualified && apb_penable_sync && apb_pwrite_direction) begin
                case (apb_paddr[7:0])
                    8'h00: gpio_a_output_reg <= apb_pwdata;
                    8'h04: gpio_a_enable_reg <= apb_pwdata;
                    8'h08: gpio_b_output_reg <= apb_pwdata[15:0];
                    8'h0C: gpio_b_enable_reg <= apb_pwdata[15:0];
                    8'h10: timer0_compare_reg <= apb_pwdata;
                    8'h14: timer1_compare_reg <= apb_pwdata;
                    8'h20: pwm_output_reg <= apb_pwdata[7:0];
                    8'h24: pwm_enable_reg <= apb_pwdata[7:0];
                    8'h30: dma_src_reg <= apb_pwdata;
                    8'h34: dma_dst_reg <= apb_pwdata;
                    8'h38: dma_count_reg <= apb_pwdata[15:0];
                    8'h3C: dma_start_reg <= apb_pwdata[0];
                    8'h40: irq_enable_reg <= apb_pwdata[15:0];
                    default: apb_error_reg <= 1'b1;
                endcase
                apb_ready_reg <= 1'b1;
            end
            // APB read access
            else if (apb_psel_qualified && apb_penable_sync && !apb_pwrite_direction) begin
                case (apb_paddr[7:0])
                    8'h00: apb_read_data_reg <= gpio_a_output_reg;
                    8'h04: apb_read_data_reg <= gpio_a_enable_reg;
                    8'h08: apb_read_data_reg <= {16'h0, gpio_b_output_reg};
                    8'h0C: apb_read_data_reg <= {16'h0, gpio_b_enable_reg};
                    8'h10: apb_read_data_reg <= timer0_compare_reg;
                    8'h14: apb_read_data_reg <= timer1_compare_reg;
                    8'h18: apb_read_data_reg <= timer0_count_reg;
                    8'h1C: apb_read_data_reg <= timer1_count_reg;
                    8'h20: apb_read_data_reg <= {24'h0, pwm_output_reg};
                    8'h24: apb_read_data_reg <= {24'h0, pwm_enable_reg};
                    8'h30: apb_read_data_reg <= dma_src_reg;
                    8'h34: apb_read_data_reg <= dma_dst_reg;
                    8'h38: apb_read_data_reg <= {16'h0, dma_count_reg};
                    8'h40: apb_read_data_reg <= {16'h0, irq_enable_reg};
                    8'h44: apb_read_data_reg <= {16'h0, irq_pending_reg};
                    default: begin
                        apb_read_data_reg <= 32'h0;
                        apb_error_reg <= 1'b1;
                    end
                endcase
                apb_ready_reg <= 1'b1;
            end else begin
                apb_ready_reg <= 1'b0;
                apb_error_reg <= 1'b0;
            end
            
            // Timer logic
            timer0_count_reg <= timer0_count_reg + 1;
            timer1_count_reg <= timer1_count_reg + 1;
            
            if (timer0_count_reg >= timer0_compare_reg) begin
                timer0_match <= 1'b1;
                timer0_count_reg <= 32'h0;
            end else begin
                timer0_match <= 1'b0;
            end
            
            if (timer1_count_reg >= timer1_compare_reg) begin
                timer1_match <= 1'b1;
                timer1_count_reg <= 32'h0;
            end else begin
                timer1_match <= 1'b0;
            end
            
            // PWM sync pulse generation
            pwm_sync_reg <= ~pwm_sync_reg;
            
            // Interrupt aggregation
            irq_pending_reg[0] <= timer0_match;
            irq_pending_reg[1] <= timer1_match;
            irq_pending_reg[2] <= dma_controller_transfer_done;
            irq_pending_reg[3] <= dma_controller_transfer_error;
            
            global_irq_reg <= |(irq_pending_reg & irq_enable_reg);
            
            // Test scan chain
            if (test_debug_scan_enable) begin
                scan_out_reg <= test_debug_scan_in;
            end else begin
                scan_out_reg <= {scan_out_reg[30:0], 1'b0};
            end
        end
    end
    
    // Output assignments
    assign gpio_bank_a_output_pins = gpio_a_output_reg;
    assign gpio_bank_a_output_enable = gpio_a_enable_reg;
    assign gpio_bank_b_output_pins = gpio_b_output_reg;
    assign gpio_bank_b_output_enable = gpio_b_enable_reg;
    
    assign apb_prdata = apb_read_data_reg;
    assign apb_pready_response = apb_ready_reg;
    assign apb_pslverr_indicator = apb_error_reg;
    
    assign timer_block_0_compare_value = timer0_compare_reg;
    assign timer_block_0_current_count = timer0_count_reg;
    assign timer_block_0_overflow_flag = timer0_overflow;
    assign timer_block_0_match_interrupt = timer0_match;
    
    assign timer_block_1_compare_value = timer1_compare_reg;
    assign timer_block_1_current_count = timer1_count_reg;
    assign timer_block_1_overflow_flag = timer1_overflow;
    assign timer_block_1_match_interrupt = timer1_match;
    
    assign pwm_module_channel_output = pwm_output_reg;
    assign pwm_module_channel_enable = pwm_enable_reg;
    assign pwm_module_sync_pulse = pwm_sync_reg;
    
    assign dma_controller_source_addr = dma_src_reg;
    assign dma_controller_dest_addr = dma_dst_reg;
    assign dma_controller_transfer_count = dma_count_reg;
    assign dma_controller_transfer_start = dma_start_reg;
    
    assign interrupt_ctrl_pending_mask = irq_pending_reg;
    assign interrupt_ctrl_enable_mask = irq_enable_reg;
    assign interrupt_ctrl_global_interrupt = global_irq_reg;
    
    assign test_debug_scan_out = scan_out_reg;
    
    // SPI and UART simple connections (placeholder logic)
    assign spi_master_inst0_sclk_out = clk_periph_50mhz;
    assign spi_master_inst0_mosi_data = gpio_a_output_reg[0];
    assign spi_master_inst0_cs_n = ~pwm_output_reg;
    
    assign spi_master_inst1_sclk_out = clk_periph_25mhz_generated;
    assign spi_master_inst1_mosi_data = gpio_a_output_reg[1];
    assign spi_master_inst1_cs_n = ~pwm_output_reg[3:0];
    
    assign uart0_txd_output_registered = gpio_a_output_reg[2];
    assign uart0_rts_n_flow_control = ~gpio_a_output_reg[3];
    
    assign uart1_txd_out_buffered = gpio_a_output_reg[4];
    assign uart1_rts_n_generated = ~gpio_a_output_reg[5];

endmodule