// Top-level design with multiple instances - Design Compiler style
// IP1 instantiated twice (inst1, inst2)  
// IP2 instantiated once (inst1)

module top (
    // Top-level clocks
    input wire main_clk_200mhz,
    input wire periph_clk_100mhz,
    input wire memory_clk_400mhz,
    input wire debug_clk_external,
    
    // Top-level resets
    input wire system_reset_n_external,
    input wire debug_reset_n_external,
    input wire power_on_reset_n,
    
    // External memory interface (shared by both processor cores)
    output wire [31:0] ext_ddr4_addr,
    output wire [511:0] ext_ddr4_wdata,
    output wire [63:0] ext_ddr4_wstrb,
    output wire ext_ddr4_cmd_valid,
    output wire ext_ddr4_cmd_we,
    input wire ext_ddr4_cmd_ready,
    input wire [511:0] ext_ddr4_rdata,
    input wire ext_ddr4_rdata_valid,
    
    // External AXI interface for processor core 1
    input wire [127:0] ext_axi_proc1_wdata,
    input wire [15:0] ext_axi_proc1_wstrb,
    input wire ext_axi_proc1_wvalid,
    output wire ext_axi_proc1_wready,
    
    input wire [63:0] ext_axi_proc1_araddr,
    input wire [7:0] ext_axi_proc1_arlen,
    input wire [2:0] ext_axi_proc1_arsize,
    input wire [1:0] ext_axi_proc1_arburst,
    input wire ext_axi_proc1_arvalid,
    output wire ext_axi_proc1_arready,
    
    output wire [127:0] ext_axi_proc1_rdata,
    output wire [1:0] ext_axi_proc1_rresp,
    output wire ext_axi_proc1_rlast,
    output wire ext_axi_proc1_rvalid,
    input wire ext_axi_proc1_rready,
    
    // External AXI interface for processor core 2
    input wire [127:0] ext_axi_proc2_wdata,
    input wire [15:0] ext_axi_proc2_wstrb,
    input wire ext_axi_proc2_wvalid,
    output wire ext_axi_proc2_wready,
    
    input wire [63:0] ext_axi_proc2_araddr,
    input wire [7:0] ext_axi_proc2_arlen,
    input wire [2:0] ext_axi_proc2_arsize,
    input wire [1:0] ext_axi_proc2_arburst,
    input wire ext_axi_proc2_arvalid,
    output wire ext_axi_proc2_arready,
    
    output wire [127:0] ext_axi_proc2_rdata,
    output wire [1:0] ext_axi_proc2_rresp,
    output wire ext_axi_proc2_rlast,
    output wire ext_axi_proc2_rvalid,
    input wire ext_axi_proc2_rready,
    
    // External peripheral interfaces
    input wire [31:0] ext_periph_gpio_a_in,
    output wire [31:0] ext_periph_gpio_a_out,
    output wire [31:0] ext_periph_gpio_a_oe,
    
    input wire [15:0] ext_periph_gpio_b_in,
    output wire [15:0] ext_periph_gpio_b_out,
    output wire [15:0] ext_periph_gpio_b_oe,
    
    // External SPI interfaces  
    output wire ext_spi0_sclk,
    output wire ext_spi0_mosi,
    input wire ext_spi0_miso,
    output wire [7:0] ext_spi0_cs_n,
    
    output wire ext_spi1_sclk,
    output wire ext_spi1_mosi,
    input wire ext_spi1_miso,
    output wire [3:0] ext_spi1_cs_n,
    
    // External UART interfaces
    input wire ext_uart0_rxd,
    output wire ext_uart0_txd,
    output wire ext_uart0_rts_n,
    input wire ext_uart0_cts_n,
    
    input wire ext_uart1_rxd,
    output wire ext_uart1_txd,
    output wire ext_uart1_rts_n,
    input wire ext_uart1_cts_n,
    
    // External I2C interface
    inout wire ext_i2c_sda,
    inout wire ext_i2c_scl,
    
    // External debug interface
    input wire ext_jtag_tck,
    input wire ext_jtag_tms,
    input wire ext_jtag_tdi,
    input wire ext_jtag_trst_n,
    output wire ext_jtag_tdo,
    
    // External test interface
    input wire ext_scan_enable,
    input wire ext_scan_clk,
    input wire ext_scan_in,
    output wire ext_scan_out,
    
    // External interrupts and control
    input wire [31:0] ext_irq_vector_proc1,
    input wire [31:0] ext_irq_vector_proc2,
    input wire [15:0] ext_periph_irq_vector,
    
    // Power management
    input wire ext_power_good_core,
    input wire ext_power_good_io,
    input wire ext_power_good_memory,
    output wire ext_power_req_shutdown,
    output wire ext_power_req_retention
);

    // Internal signal declarations
    // Processor 1 control signals
    wire [31:0] proc1_ctrl_config_0;
    wire [31:0] proc1_ctrl_config_1;
    wire [31:0] proc1_ctrl_config_2;
    wire [31:0] proc1_status_0;
    wire [31:0] proc1_status_1;
    wire [31:0] proc1_status_2;
    
    // Processor 2 control signals  
    wire [31:0] proc2_ctrl_config_0;
    wire [31:0] proc2_ctrl_config_1;
    wire [31:0] proc2_ctrl_config_2;
    wire [31:0] proc2_status_0;
    wire [31:0] proc2_status_1;
    wire [31:0] proc2_status_2;

    // Shared memory interface mux signals
    wire [31:0] mem_mux_addr;
    wire [511:0] mem_mux_wdata;
    wire [63:0] mem_mux_wstrb;
    wire mem_mux_cmd_valid;
    wire mem_mux_cmd_we;
    wire mem_mux_cmd_ready;
    wire [511:0] mem_mux_rdata;
    wire mem_mux_rdata_valid;

    // Peripheral APB interface
    wire [31:0] periph_paddr;
    wire periph_psel;
    wire periph_penable;
    wire periph_pwrite;
    wire [31:0] periph_pwdata;
    wire [31:0] periph_prdata;
    wire periph_pready;
    wire periph_pslverr;

    // ===== PROCESSOR CORE 1 INSTANCE (IP1 inst1) =====
    processor_core_v2_1_3 u_processor_core_inst1 (
        // Clock and reset connections
        .clk_i(main_clk_200mhz),
        .\rst_n_async/sync_combo (system_reset_n_external),
        .\pwr_on_rst_n$functional (power_on_reset_n),
        
        // AXI slave interface connections
        .\axi4_slave_if/s_axi_wdata[127:0] (ext_axi_proc1_wdata),
        .\axi4_slave_if/s_axi_wstrb[15:0] (ext_axi_proc1_wstrb),
        .\axi4_slave_if/s_axi_wvalid_qualified (ext_axi_proc1_wvalid),
        .\axi4_slave_if/s_axi_wready_internal (ext_axi_proc1_wready),
        
        .\axi4_slave_if/s_axi_araddr[63:0] (ext_axi_proc1_araddr),
        .\axi4_slave_if/s_axi_arlen[7:0] (ext_axi_proc1_arlen),
        .\axi4_slave_if/s_axi_arsize[2:0] (ext_axi_proc1_arsize),
        .\axi4_slave_if/s_axi_arburst[1:0] (ext_axi_proc1_arburst),
        .\axi4_slave_if/s_axi_arvalid_sync (ext_axi_proc1_arvalid),
        .\axi4_slave_if/s_axi_arready_comb (ext_axi_proc1_arready),
        
        .\axi4_slave_if/s_axi_rdata[127:0] (ext_axi_proc1_rdata),
        .\axi4_slave_if/s_axi_rresp[1:0] (ext_axi_proc1_rresp),
        .\axi4_slave_if/s_axi_rlast_generated (ext_axi_proc1_rlast),
        .\axi4_slave_if/s_axi_rvalid_final (ext_axi_proc1_rvalid),
        .\axi4_slave_if/s_axi_rready_external (ext_axi_proc1_rready),
        
        // Memory interface connections (shared through mux)
        .\mem_subsys/ddr4_ctrl_v1_2/addr_out[31:0] (/* connected through memory arbiter */),
        .\mem_subsys/ddr4_ctrl_v1_2/wdata_out[511:0] (/* connected through memory arbiter */),
        .\mem_subsys/ddr4_ctrl_v1_2/wstrb_out[63:0] (/* connected through memory arbiter */),
        .\mem_subsys/ddr4_ctrl_v1_2/cmd_valid_o (/* connected through memory arbiter */),
        .\mem_subsys/ddr4_ctrl_v1_2/cmd_we_o (/* connected through memory arbiter */),
        .\mem_subsys/ddr4_ctrl_v1_2/cmd_ready_i (mem_mux_cmd_ready),
        .\mem_subsys/ddr4_ctrl_v1_2/rdata_in[511:0] (mem_mux_rdata),
        .\mem_subsys/ddr4_ctrl_v1_2/rdata_valid_i (mem_mux_rdata_valid),
        
        // Control and status registers
        .ctrl_reg_bank_0_config_word_primary(proc1_ctrl_config_0),
        .\ctrl_reg_bank_1/config_word_secondary[31:0] (proc1_ctrl_config_1),
        .CTRL_REG_BANK_2_CONFIG_WORD_TERTIARY(proc1_ctrl_config_2),
        
        .status_reg_bank_0_output_primary(proc1_status_0),
        .\status_reg_bank_1/output_secondary[31:0] (proc1_status_1),
        .STATUS_REG_BANK_2_OUTPUT_TERTIARY(proc1_status_2),
        
        // Interrupt interface
        .\irq_controller_v3_1/irq_vector_in[31:0] (ext_irq_vector_proc1),
        .\irq_controller_v3_1/irq_priority[7:0] (8'h00), // Default priority
        .\irq_controller_v3_1/irq_ack_out[31:0] (/* internal connection */),
        .\irq_controller_v3_1/irq_service_active (/* internal connection */),
        
        // Debug interface
        .\debug_if_v2_3/jtag_tck_buffered$gated (ext_jtag_tck),
        .\debug_if_v2_3/jtag_tms_synchronized (ext_jtag_tms),
        .\debug_if_v2_3/jtag_tdi_qualified (ext_jtag_tdi),
        .\debug_if_v2_3/jtag_trst_n_async$filtered (ext_jtag_trst_n),
        .\debug_if_v2_3/jtag_tdo_registered (ext_jtag_tdo),
        
        // Test interface
        .\test_ctrl_v1_5/scan_enable_mode$functional (ext_scan_enable),
        .\test_ctrl_v1_5/scan_clk_gated$test_mode (ext_scan_clk),
        .\test_ctrl_v1_5/scan_in_primary_chain (ext_scan_in),
        .\test_ctrl_v1_5/scan_out_primary_chain (/* daisy chained to proc2 */),
        .\test_ctrl_v1_5/scan_chain_select[7:0] (8'h01), // Chain 1
        
        // Performance monitoring (internal connections)
        .\perf_monitor_subsys_v4_2_1/cycle_count_main_core[63:0] (/* internal */),
        .\perf_monitor_subsys_v4_2_1/instruction_count_pipeline[63:0] (/* internal */),
        .\perf_monitor_subsys_v4_2_1/cache_miss_count_l1_data[31:0] (/* internal */),
        .\perf_monitor_subsys_v4_2_1/cache_miss_count_l1_instruction[31:0] (/* internal */),
        .\perf_monitor_subsys_v4_2_1/pipeline_stall_count_total[31:0] (/* internal */),
        
        // Power management
        .\pwr_mgmt_v2_1/power_good_vdd_core (ext_power_good_core),
        .\pwr_mgmt_v2_1/power_good_vdd_io (ext_power_good_io),
        .\pwr_mgmt_v2_1/power_good_vdd_memory (ext_power_good_memory),
        .\pwr_mgmt_v2_1/power_req_shutdown_core (ext_power_req_shutdown),
        .\pwr_mgmt_v2_1/power_req_retention_mode (ext_power_req_retention),
        .\pwr_mgmt_v2_1/voltage_level_indicator[3:0] (4'b1111), // Full voltage
        
        // Clock control
        .\clk_ctrl_v3_2/clk_gate_enable_main_domain (1'b1),
        .\clk_ctrl_v3_2/clk_gate_enable_peripheral_domain (1'b1),
        .\clk_ctrl_v3_2/clk_gate_enable_memory_domain (1'b1),
        .\clk_ctrl_v3_2/clk_domain_crossing_req_main_to_periph (/* internal */),
        .\clk_ctrl_v3_2/clk_domain_crossing_req_main_to_mem (/* internal */),
        .\clk_ctrl_v3_2/clk_domain_crossing_ack_periph_to_main (1'b1),
        .\clk_ctrl_v3_2/clk_domain_crossing_ack_mem_to_main (1'b1)
    );

    // ===== PROCESSOR CORE 2 INSTANCE (IP1 inst2) =====
    processor_core_v2_1_3 u_processor_core_inst2 (
        // Clock and reset connections
        .clk_i(main_clk_200mhz),
        .\rst_n_async/sync_combo (system_reset_n_external),
        .\pwr_on_rst_n$functional (power_on_reset_n),
        
        // AXI slave interface connections
        .\axi4_slave_if/s_axi_wdata[127:0] (ext_axi_proc2_wdata),
        .\axi4_slave_if/s_axi_wstrb[15:0] (ext_axi_proc2_wstrb),
        .\axi4_slave_if/s_axi_wvalid_qualified (ext_axi_proc2_wvalid),
        .\axi4_slave_if/s_axi_wready_internal (ext_axi_proc2_wready),
        
        .\axi4_slave_if/s_axi_araddr[63:0] (ext_axi_proc2_araddr),
        .\axi4_slave_if/s_axi_arlen[7:0] (ext_axi_proc2_arlen),
        .\axi4_slave_if/s_axi_arsize[2:0] (ext_axi_proc2_arsize),
        .\axi4_slave_if/s_axi_arburst[1:0] (ext_axi_proc2_arburst),
        .\axi4_slave_if/s_axi_arvalid_sync (ext_axi_proc2_arvalid),
        .\axi4_slave_if/s_axi_arready_comb (ext_axi_proc2_arready),
        
        .\axi4_slave_if/s_axi_rdata[127:0] (ext_axi_proc2_rdata),
        .\axi4_slave_if/s_axi_rresp[1:0] (ext_axi_proc2_rresp),
        .\axi4_slave_if/s_axi_rlast_generated (ext_axi_proc2_rlast),
        .\axi4_slave_if/s_axi_rvalid_final (ext_axi_proc2_rvalid),
        .\axi4_slave_if/s_axi_rready_external (ext_axi_proc2_rready),
        
        // Memory interface connections (shared through mux)
        .\mem_subsys/ddr4_ctrl_v1_2/addr_out[31:0] (/* connected through memory arbiter */),
        .\mem_subsys/ddr4_ctrl_v1_2/wdata_out[511:0] (/* connected through memory arbiter */),
        .\mem_subsys/ddr4_ctrl_v1_2/wstrb_out[63:0] (/* connected through memory arbiter */),
        .\mem_subsys/ddr4_ctrl_v1_2/cmd_valid_o (/* connected through memory arbiter */),
        .\mem_subsys/ddr4_ctrl_v1_2/cmd_we_o (/* connected through memory arbiter */),
        .\mem_subsys/ddr4_ctrl_v1_2/cmd_ready_i (mem_mux_cmd_ready),
        .\mem_subsys/ddr4_ctrl_v1_2/rdata_in[511:0] (mem_mux_rdata),
        .\mem_subsys/ddr4_ctrl_v1_2/rdata_valid_i (mem_mux_rdata_valid),
        
        // Control and status registers
        .ctrl_reg_bank_0_config_word_primary(proc2_ctrl_config_0),
        .\ctrl_reg_bank_1/config_word_secondary[31:0] (proc2_ctrl_config_1),
        .CTRL_REG_BANK_2_CONFIG_WORD_TERTIARY(proc2_ctrl_config_2),
        
        .status_reg_bank_0_output_primary(proc2_status_0),
        .\status_reg_bank_1/output_secondary[31:0] (proc2_status_1),
        .STATUS_REG_BANK_2_OUTPUT_TERTIARY(proc2_status_2),
        
        // Interrupt interface
        .\irq_controller_v3_1/irq_vector_in[31:0] (ext_irq_vector_proc2),
        .\irq_controller_v3_1/irq_priority[7:0] (8'h00), // Default priority
        .\irq_controller_v3_1/irq_ack_out[31:0] (/* internal connection */),
        .\irq_controller_v3_1/irq_service_active (/* internal connection */),
        
        // Debug interface (shared/daisy-chained)
        .\debug_if_v2_3/jtag_tck_buffered$gated (ext_jtag_tck),
        .\debug_if_v2_3/jtag_tms_synchronized (ext_jtag_tms),
        .\debug_if_v2_3/jtag_tdi_qualified (/* from proc1 jtag chain */),
        .\debug_if_v2_3/jtag_trst_n_async$filtered (ext_jtag_trst_n),
        .\debug_if_v2_3/jtag_tdo_registered (/* to periph controller */),
        
        // Test interface (daisy chained)
        .\test_ctrl_v1_5/scan_enable_mode$functional (ext_scan_enable),
        .\test_ctrl_v1_5/scan_clk_gated$test_mode (ext_scan_clk),
        .\test_ctrl_v1_5/scan_in_primary_chain (/* from proc1 scan chain */),
        .\test_ctrl_v1_5/scan_out_primary_chain (/* to periph controller */),
        .\test_ctrl_v1_5/scan_chain_select[7:0] (8'h02), // Chain 2
        
        // Performance monitoring (internal connections)
        .\perf_monitor_subsys_v4_2_1/cycle_count_main_core[63:0] (/* internal */),
        .\perf_monitor_subsys_v4_2_1/instruction_count_pipeline[63:0] (/* internal */),
        .\perf_monitor_subsys_v4_2_1/cache_miss_count_l1_data[31:0] (/* internal */),
        .\perf_monitor_subsys_v4_2_1/cache_miss_count_l1_instruction[31:0] (/* internal */),
        .\perf_monitor_subsys_v4_2_1/pipeline_stall_count_total[31:0] (/* internal */),
        
        // Power management (shared)
        .\pwr_mgmt_v2_1/power_good_vdd_core (ext_power_good_core),
        .\pwr_mgmt_v2_1/power_good_vdd_io (ext_power_good_io),
        .\pwr_mgmt_v2_1/power_good_vdd_memory (ext_power_good_memory),
        .\pwr_mgmt_v2_1/power_req_shutdown_core (/* OR-ed with proc1 */),
        .\pwr_mgmt_v2_1/power_req_retention_mode (/* OR-ed with proc1 */),
        .\pwr_mgmt_v2_1/voltage_level_indicator[3:0] (4'b1111), // Full voltage
        
        // Clock control
        .\clk_ctrl_v3_2/clk_gate_enable_main_domain (1'b1),
        .\clk_ctrl_v3_2/clk_gate_enable_peripheral_domain (1'b1),
        .\clk_ctrl_v3_2/clk_gate_enable_memory_domain (1'b1),
        .\clk_ctrl_v3_2/clk_domain_crossing_req_main_to_periph (/* internal */),
        .\clk_ctrl_v3_2/clk_domain_crossing_req_main_to_mem (/* internal */),
        .\clk_ctrl_v3_2/clk_domain_crossing_ack_periph_to_main (1'b1),
        .\clk_ctrl_v3_2/clk_domain_crossing_ack_mem_to_main (1'b1)
    );

    // ===== PERIPHERAL CONTROLLER INSTANCE (IP2 inst1) =====
    peripheral_controller_v1_4_2 u_peripheral_controller_inst1 (
        // Clock connections
        .clk_periph_100mhz(periph_clk_100mhz),
        .clk_periph_50mhz(/* derived from periph_clk_100mhz */),
        .\clk_periph_25mhz/generated (/* derived from periph_clk_100mhz */),
        .\rst_periph_domain_n$sync (system_reset_n_external),
        
        // APB interface (connected to processors via bridge)
        .\apb_if_v2_1/paddr[31:0] (periph_paddr),
        .\apb_if_v2_1/psel_qualified (periph_psel),
        .\apb_if_v2_1/penable_sync (periph_penable),
        .\apb_if_v2_1/pwrite_direction (periph_pwrite),
        .\apb_if_v2_1/pwdata[31:0] (periph_pwdata),
        .\apb_if_v2_1/prdata[31:0] (periph_prdata),
        .\apb_if_v2_1/pready_response (periph_pready),
        .\apb_if_v2_1/pslverr_indicator (periph_pslverr),
        
        // GPIO interfaces
        .\gpio_bank_A/input_pins[31:0] (ext_periph_gpio_a_in),
        .\gpio_bank_A/output_pins[31:0] (ext_periph_gpio_a_out),
        .\gpio_bank_A/output_enable[31:0] (ext_periph_gpio_a_oe),
        .\gpio_bank_B/input_pins[15:0] (ext_periph_gpio_b_in),
        .\gpio_bank_B/output_pins[15:0] (ext_periph_gpio_b_out),
        .\gpio_bank_B/output_enable[15:0] (ext_periph_gpio_b_oe),
        
        // SPI interfaces
        .\spi_master_v3_1_inst0/sclk_out (ext_spi0_sclk),
        .\spi_master_v3_1_inst0/mosi_data (ext_spi0_mosi),
        .\spi_master_v3_1_inst0/miso_data (ext_spi0_miso),
        .\spi_master_v3_1_inst0/cs_n[7:0] (ext_spi0_cs_n),
        
        .\spi_master_v3_1_inst1/sclk_out (ext_spi1_sclk),
        .\spi_master_v3_1_inst1/mosi_data (ext_spi1_mosi),
        .\spi_master_v3_1_inst1/miso_data (ext_spi1_miso),
        .\spi_master_v3_1_inst1/cs_n[3:0] (ext_spi1_cs_n),
        
        // UART interfaces
        .uart0_rxd_input_synchronized(ext_uart0_rxd),
        .uart0_txd_output_registered(ext_uart0_txd),
        .uart0_rts_n_flow_control(ext_uart0_rts_n),
        .uart0_cts_n_external(ext_uart0_cts_n),
        
        .\uart1_if_v2_3/rxd_in_qualified (ext_uart1_rxd),
        .\uart1_if_v2_3/txd_out_buffered (ext_uart1_txd),
        .\uart1_if_v2_3/rts_n_generated (ext_uart1_rts_n),
        .\uart1_if_v2_3/cts_n_filtered (ext_uart1_cts_n),
        
        // I2C interface
        .\i2c_master_v4_1/sda_bidir$pad_control (ext_i2c_sda),
        .\i2c_master_v4_1/scl_bidir$pad_control (ext_i2c_scl),
        .\i2c_master_v4_1/sda_out_enable_drive (/* internal pad control */),
        .\i2c_master_v4_1/scl_out_enable_drive (/* internal pad control */),
        .\i2c_master_v4_1/sda_in_synchronized (/* internal from pad */),
        .\i2c_master_v4_1/scl_in_synchronized (/* internal from pad */),
        
        // Timer interfaces (internal register access)
        .\timer_subsys_v2_4/timer0_count_value[31:0] (/* internal */),
        .\timer_subsys_v2_4/timer0_overflow_flag (/* internal interrupt */),
        .\timer_subsys_v2_4/timer0_compare_match (/* internal interrupt */),
        .\timer_subsys_v2_4/timer0_compare_value[31:0] (/* internal register */),
        .\timer_subsys_v2_4/timer0_enable_control (/* internal register */),
        
        .\timer_subsys_v2_4/timer1_count_value[31:0] (/* internal */),
        .\timer_subsys_v2_4/timer1_overflow_flag (/* internal interrupt */),
        .\timer_subsys_v2_4/timer1_compare_match (/* internal interrupt */),
        .\timer_subsys_v2_4/timer1_compare_value[31:0] (/* internal register */),
        .\timer_subsys_v2_4/timer1_enable_control (/* internal register */),
        
        // PWM outputs (external connections would be added)
        .\pwm_controller_v1_3/pwm_out_channels[7:0] (/* external PWM pins */),
        .\pwm_controller_v1_3/pwm_sync_pulse (/* external sync */),
        .\pwm_controller_v1_3/pwm_duty_cycle_ch0[7:0] (/* internal register */),
        .\pwm_controller_v1_3/pwm_duty_cycle_ch1[7:0] (/* internal register */),
        .\pwm_controller_v1_3/pwm_duty_cycle_ch2[7:0] (/* internal register */),
        .\pwm_controller_v1_3/pwm_duty_cycle_ch3[7:0] (/* internal register */),
        
        // DMA interface (connected to system bus)
        .\dma_engine_v3_2_1/master_axi_awaddr[31:0] (/* to system AXI interconnect */),
        .\dma_engine_v3_2_1/master_axi_awlen[7:0] (/* to system AXI interconnect */),
        .\dma_engine_v3_2_1/master_axi_awsize[2:0] (/* to system AXI interconnect */),
        .\dma_engine_v3_2_1/master_axi_awvalid_req (/* to system AXI interconnect */),
        .\dma_engine_v3_2_1/master_axi_awready_ack (/* from system AXI interconnect */),
        
        .\dma_engine_v3_2_1/master_axi_wdata[63:0] (/* to system AXI interconnect */),
        .\dma_engine_v3_2_1/master_axi_wstrb[7:0] (/* to system AXI interconnect */),
        .\dma_engine_v3_2_1/master_axi_wlast_indicator (/* to system AXI interconnect */),
        .\dma_engine_v3_2_1/master_axi_wvalid_strobe (/* to system AXI interconnect */),
        .\dma_engine_v3_2_1/master_axi_wready_response (/* from system AXI interconnect */),
        
        // Interrupt outputs
        .\periph_irq_controller/irq_out_vector[15:0] (ext_periph_irq_vector),
        .\periph_irq_controller/irq_out_level_active (/* to system interrupt controller */),
        .\periph_irq_controller/irq_mask_register[15:0] (/* internal register */),
        
        // Test and debug (daisy chained from proc2)
        .\periph_test_ctrl/scan_enable_periph_domain (ext_scan_enable),
        .\periph_test_ctrl/scan_clk_periph_gated (ext_scan_clk),
        .\periph_test_ctrl/scan_in_periph_chain (/* from proc2 scan out */),
        .\periph_test_ctrl/scan_out_periph_chain (ext_scan_out)
    );

    // Additional top-level logic for memory arbitration, 
    // interrupt routing, clock generation, etc. would go here

endmodule