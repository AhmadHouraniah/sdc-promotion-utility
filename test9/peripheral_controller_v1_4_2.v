// Peripheral controller v1.4.2 - Same as test8 but in test9 directory
module peripheral_controller_v1_4_2 (
    // Clocks - multiple clock domains typical in DC netlists
    input clk_periph_100mhz,
    input clk_periph_50mhz,
    input \\clk_periph_25mhz/generated ,
    input \\rst_periph_domain_n$sync ,
    
    // APB interface - standard but with DC naming
    input [31:0] \\apb_if_v2_1/paddr[31:0] ,
    input \\apb_if_v2_1/psel_qualified ,
    input \\apb_if_v2_1/penable_sync ,
    input \\apb_if_v2_1/pwrite_direction ,
    input [31:0] \\apb_if_v2_1/pwdata[31:0] ,
    output [31:0] \\apb_if_v2_1/prdata[31:0] ,
    output \\apb_if_v2_1/pready_response ,
    output \\apb_if_v2_1/pslverr_indicator ,
    
    // GPIO interface - various widths and naming patterns
    input [31:0] \\gpio_bank_A/input_pins[31:0] ,
    output [31:0] \\gpio_bank_A/output_pins[31:0] ,
    output [31:0] \\gpio_bank_A/output_enable[31:0] ,
    input [15:0] \\gpio_bank_B/input_pins[15:0] ,
    output [15:0] \\gpio_bank_B/output_pins[15:0] ,
    output [15:0] \\gpio_bank_B/output_enable[15:0] ,
    
    // SPI interfaces - multiple instances with version numbers
    output \\spi_master_v3_1_inst0/sclk_out ,
    output \\spi_master_v3_1_inst0/mosi_data ,
    input \\spi_master_v3_1_inst0/miso_data ,
    output [7:0] \\spi_master_v3_1_inst0/cs_n[7:0] ,
    
    output \\spi_master_v3_1_inst1/sclk_out ,
    output \\spi_master_v3_1_inst1/mosi_data ,
    input \\spi_master_v3_1_inst1/miso_data ,
    output [3:0] \\spi_master_v3_1_inst1/cs_n[3:0] ,
    
    // UART interfaces - legacy naming mixed with modern
    input uart0_rxd_input_synchronized,
    output uart0_txd_output_registered,
    output uart0_rts_n_flow_control,
    input uart0_cts_n_external,
    
    input \\uart1_if_v2_3/rxd_in_qualified ,
    output \\uart1_if_v2_3/txd_out_buffered ,
    output \\uart1_if_v2_3/rts_n_generated ,
    input \\uart1_if_v2_3/cts_n_filtered ,
    
    // Timer interfaces - multiple instances
    output [31:0] \\timer_block_0/compare_value[31:0] ,
    output [31:0] \\timer_block_0/current_count[31:0] ,
    output \\timer_block_0/overflow_flag ,
    output \\timer_block_0/match_interrupt ,
    
    output [31:0] \\timer_block_1/compare_value[31:0] ,
    output [31:0] \\timer_block_1/current_count[31:0] ,
    output \\timer_block_1/overflow_flag ,
    output \\timer_block_1/match_interrupt ,
    
    // PWM outputs - multiple channels
    output [7:0] \\pwm_module/channel_output[7:0] ,
    output [7:0] \\pwm_module/channel_enable[7:0] ,
    output \\pwm_module/sync_pulse ,
    
    // DMA interface for memory transfers
    output [31:0] \\dma_controller/source_addr[31:0] ,
    output [31:0] \\dma_controller/dest_addr[31:0] ,
    output [15:0] \\dma_controller/transfer_count[15:0] ,
    output \\dma_controller/transfer_start ,
    input \\dma_controller/transfer_done ,
    input \\dma_controller/transfer_error ,
    
    // Interrupt aggregation
    output [15:0] \\interrupt_ctrl/pending_mask[15:0] ,
    output [15:0] \\interrupt_ctrl/enable_mask[15:0] ,
    output \\interrupt_ctrl/global_interrupt ,
    
    // Test and debug interface
    input \\test_debug/scan_enable ,
    input [31:0] \\test_debug/scan_in[31:0] ,
    output [31:0] \\test_debug/scan_out[31:0] 
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
    
    // Main peripheral logic
    always @(posedge clk_periph_100mhz or negedge \\rst_periph_domain_n$sync ) begin
        if (!\\rst_periph_domain_n$sync ) begin
            gpio_a_output_reg <= 32'b0;
            gpio_a_enable_reg <= 32'b0;
            gpio_b_output_reg <= 16'b0;
            gpio_b_enable_reg <= 16'b0;
            apb_read_data_reg <= 32'b0;
            apb_ready_reg <= 1'b0;
            apb_error_reg <= 1'b0;
            timer0_compare_reg <= 32'hFFFFFFFF;
            timer0_count_reg <= 32'b0;
            timer1_compare_reg <= 32'hFFFFFFFF;
            timer1_count_reg <= 32'b0;
            timer0_overflow <= 1'b0;
            timer0_match <= 1'b0;
            timer1_overflow <= 1'b0;
            timer1_match <= 1'b0;
            pwm_output_reg <= 8'b0;
            pwm_enable_reg <= 8'b0;
            pwm_sync_reg <= 1'b0;
            dma_src_reg <= 32'b0;
            dma_dst_reg <= 32'b0;
            dma_count_reg <= 16'b0;
            dma_start_reg <= 1'b0;
            irq_pending_reg <= 16'b0;
            irq_enable_reg <= 16'b0;
            global_irq_reg <= 1'b0;
            scan_out_reg <= 32'b0;
        end else begin
            // APB write operations
            if (\\apb_if_v2_1/psel_qualified  && \\apb_if_v2_1/penable_sync  && \\apb_if_v2_1/pwrite_direction ) begin
                case (\\apb_if_v2_1/paddr[31:0] [7:0])
                    8'h00: gpio_a_output_reg <= \\apb_if_v2_1/pwdata[31:0] ;
                    8'h04: gpio_a_enable_reg <= \\apb_if_v2_1/pwdata[31:0] ;
                    8'h08: gpio_b_output_reg <= \\apb_if_v2_1/pwdata[31:0] [15:0];
                    8'h0C: gpio_b_enable_reg <= \\apb_if_v2_1/pwdata[31:0] [15:0];
                    8'h10: timer0_compare_reg <= \\apb_if_v2_1/pwdata[31:0] ;
                    8'h18: timer1_compare_reg <= \\apb_if_v2_1/pwdata[31:0] ;
                    8'h20: pwm_enable_reg <= \\apb_if_v2_1/pwdata[31:0] [7:0];
                    8'h30: dma_src_reg <= \\apb_if_v2_1/pwdata[31:0] ;
                    8'h34: dma_dst_reg <= \\apb_if_v2_1/pwdata[31:0] ;
                    8'h38: dma_count_reg <= \\apb_if_v2_1/pwdata[31:0] [15:0];
                    8'h3C: dma_start_reg <= \\apb_if_v2_1/pwdata[31:0] [0];
                    8'h40: irq_enable_reg <= \\apb_if_v2_1/pwdata[31:0] [15:0];
                endcase
                apb_ready_reg <= 1'b1;
                apb_error_reg <= 1'b0;
            end
            // APB read operations
            else if (\\apb_if_v2_1/psel_qualified  && \\apb_if_v2_1/penable_sync  && !\\apb_if_v2_1/pwrite_direction ) begin
                case (\\apb_if_v2_1/paddr[31:0] [7:0])
                    8'h00: apb_read_data_reg <= \\gpio_bank_A/input_pins[31:0] ;
                    8'h04: apb_read_data_reg <= gpio_a_enable_reg;
                    8'h08: apb_read_data_reg <= {16'b0, \\gpio_bank_B/input_pins[15:0] };
                    8'h0C: apb_read_data_reg <= {16'b0, gpio_b_enable_reg};
                    8'h14: apb_read_data_reg <= timer0_count_reg;
                    8'h1C: apb_read_data_reg <= timer1_count_reg;
                    8'h24: apb_read_data_reg <= {24'b0, pwm_output_reg};
                    8'h44: apb_read_data_reg <= {16'b0, irq_pending_reg};
                    default: apb_read_data_reg <= 32'hDEADBEEF;
                endcase
                apb_ready_reg <= 1'b1;
                apb_error_reg <= 1'b0;
            end else begin
                apb_ready_reg <= 1'b0;
                apb_error_reg <= 1'b0;
            end
            
            // Timer counters
            timer0_count_reg <= timer0_count_reg + 1;
            timer1_count_reg <= timer1_count_reg + 1;
            timer0_overflow <= (timer0_count_reg == 32'hFFFFFFFF);
            timer1_overflow <= (timer1_count_reg == 32'hFFFFFFFF);
            timer0_match <= (timer0_count_reg == timer0_compare_reg);
            timer1_match <= (timer1_count_reg == timer1_compare_reg);
            
            // PWM generation (simple)
            pwm_output_reg <= timer0_count_reg[7:0] & pwm_enable_reg;
            pwm_sync_reg <= timer0_overflow;
            
            // Interrupt handling
            irq_pending_reg <= {14'b0, timer1_match, timer0_match};
            global_irq_reg <= |(irq_pending_reg & irq_enable_reg);
            
            // Scan chain
            scan_out_reg <= \\test_debug/scan_enable  ? \\test_debug/scan_in[31:0]  : scan_out_reg;
        end
    end
    
    // Output assignments
    assign \\apb_if_v2_1/prdata[31:0]  = apb_read_data_reg;
    assign \\apb_if_v2_1/pready_response  = apb_ready_reg;
    assign \\apb_if_v2_1/pslverr_indicator  = apb_error_reg;
    assign \\gpio_bank_A/output_pins[31:0]  = gpio_a_output_reg;
    assign \\gpio_bank_A/output_enable[31:0]  = gpio_a_enable_reg;
    assign \\gpio_bank_B/output_pins[15:0]  = gpio_b_output_reg;
    assign \\gpio_bank_B/output_enable[15:0]  = gpio_b_enable_reg;
    assign \\spi_master_v3_1_inst0/sclk_out  = clk_periph_50mhz;
    assign \\spi_master_v3_1_inst0/mosi_data  = gpio_a_output_reg[0];
    assign \\spi_master_v3_1_inst0/cs_n[7:0]  = ~gpio_a_output_reg[7:0];
    assign \\spi_master_v3_1_inst1/sclk_out  = clk_periph_25mhz;
    assign \\spi_master_v3_1_inst1/mosi_data  = gpio_b_output_reg[0];
    assign \\spi_master_v3_1_inst1/cs_n[3:0]  = ~gpio_b_output_reg[3:0];
    assign uart0_txd_output_registered = gpio_a_output_reg[8];
    assign uart0_rts_n_flow_control = ~gpio_a_output_reg[9];
    assign \\uart1_if_v2_3/txd_out_buffered  = gpio_b_output_reg[8];
    assign \\uart1_if_v2_3/rts_n_generated  = ~gpio_b_output_reg[9];
    assign \\timer_block_0/compare_value[31:0]  = timer0_compare_reg;
    assign \\timer_block_0/current_count[31:0]  = timer0_count_reg;
    assign \\timer_block_0/overflow_flag  = timer0_overflow;
    assign \\timer_block_0/match_interrupt  = timer0_match;
    assign \\timer_block_1/compare_value[31:0]  = timer1_compare_reg;
    assign \\timer_block_1/current_count[31:0]  = timer1_count_reg;
    assign \\timer_block_1/overflow_flag  = timer1_overflow;
    assign \\timer_block_1/match_interrupt  = timer1_match;
    assign \\pwm_module/channel_output[7:0]  = pwm_output_reg;
    assign \\pwm_module/channel_enable[7:0]  = pwm_enable_reg;
    assign \\pwm_module/sync_pulse  = pwm_sync_reg;
    assign \\dma_controller/source_addr[31:0]  = dma_src_reg;
    assign \\dma_controller/dest_addr[31:0]  = dma_dst_reg;
    assign \\dma_controller/transfer_count[15:0]  = dma_count_reg;
    assign \\dma_controller/transfer_start  = dma_start_reg;
    assign \\interrupt_ctrl/pending_mask[15:0]  = irq_pending_reg;
    assign \\interrupt_ctrl/enable_mask[15:0]  = irq_enable_reg;
    assign \\interrupt_ctrl/global_interrupt  = global_irq_reg;
    assign \\test_debug/scan_out[31:0]  = scan_out_reg;

endmodule