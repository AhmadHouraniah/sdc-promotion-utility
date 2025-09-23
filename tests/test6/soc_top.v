// Top-level SoC design integrating SPI and Memory controllers
module soc_top (
    // Primary clocks
    input  osc_100m,        // 100MHz oscillator
    input  osc_200m,        // 200MHz oscillator  
    input  osc_25m,         // 25MHz reference
    input  por_n,           // Power-on reset
    
    // SPI external interface
    input  spi_enable_pin,
    input  spi_mode_pin,
    input  [1:0] spi_config,
    input  [7:0] div_setting,
    input  [31:0] tx_fifo_in,
    input  tx_push,
    output tx_full_flag,
    output [31:0] rx_fifo_out,
    output rx_data_avail,
    input  rx_pop,
    output spi_cs_ext,
    output spi_mosi_ext,
    input  spi_miso_ext,
    output spi_sclk_ext,
    output spi_busy_flag,
    output [3:0] spi_err,
    
    // Memory interface
    input  [31:0] host_addr,
    input  [2:0] host_cmd,
    input  host_req,
    output host_ack,
    input  [127:0] host_wdata,
    input  [15:0] host_wmask,
    input  host_wvalid,
    output host_wready,
    output [127:0] host_rdata,
    output host_rvalid,
    input  host_rready,
    
    // DDR3 physical interface
    output [13:0] dram_addr,
    output [2:0] dram_bank,
    output dram_cas,
    output dram_ras,
    output dram_we,
    output dram_cs,
    output dram_cke,
    output dram_odt,
    inout  [63:0] dram_data,
    inout  [7:0] dram_mask,
    inout  [7:0] dram_strobe,
    
    // System status
    output mem_init_complete,
    output [3:0] mem_error_code,
    input  [7:0] ddr_timing_cfg
);

    // Internal clock and reset distribution
    wire core_clock_int;        // SPI core clock
    wire serial_tx_clk;         // SPI serial transmit clock
    wire serial_rx_clk;         // SPI serial receive clock
    wire system_reset_n;        // Internal reset
    
    wire memory_sys_clk;        // Memory system clock
    wire dram_if_clk;          // DDR interface clock
    wire refresh_timing_clk;    // Memory refresh clock
    wire memory_reset_n;        // Memory reset
    
    // Clock generation and distribution
    assign core_clock_int = osc_100m;       // SPI gets 100MHz
    assign serial_tx_clk = osc_25m;         // SPI serial at 25MHz
    assign serial_rx_clk = osc_25m;         // SPI receive at 25MHz
    assign system_reset_n = por_n;
    
    assign memory_sys_clk = osc_100m;       // Memory system at 100MHz
    assign dram_if_clk = osc_200m;         // DDR interface at 200MHz
    assign refresh_timing_clk = osc_25m;    // Refresh timing at 25MHz
    assign memory_reset_n = por_n;
    
    // SPI Controller instance
    spi_ctrl u_serial_interface (
        .core_clk(core_clock_int),
        .sclk_out(serial_tx_clk),
        .sclk_in(serial_rx_clk),
        .arst_n(system_reset_n),
        
        .enable(spi_enable_pin),
        .mode_sel(spi_mode_pin),
        .cpol_cpha(spi_config),
        .div_ratio(div_setting),
        
        .tx_data(tx_fifo_in),
        .tx_valid(tx_push),
        .tx_ready(tx_full_flag),
        .rx_data(rx_fifo_out),
        .rx_valid(rx_data_avail),
        .rx_ready(rx_pop),
        
        .spi_cs_n(spi_cs_ext),
        .spi_mosi(spi_mosi_ext),
        .spi_miso(spi_miso_ext),
        .spi_sclk(spi_sclk_ext),
        
        .busy(spi_busy_flag),
        .error_flags(spi_err)
    );
    
    // Memory Controller instance
    mem_ctrl u_dram_interface (
        .sys_clk(memory_sys_clk),
        .ddr_clk(dram_if_clk),
        .ref_clk(refresh_timing_clk),
        .rst_n(memory_reset_n),
        
        .cmd_addr(host_addr),
        .cmd_type(host_cmd),
        .cmd_valid(host_req),
        .cmd_ready(host_ack),
        .wr_data(host_wdata),
        .wr_mask(host_wmask),
        .wr_valid(host_wvalid),
        .wr_ready(host_wready),
        .rd_data(host_rdata),
        .rd_valid(host_rvalid),
        .rd_ready(host_rready),
        
        .ddr_addr(dram_addr),
        .ddr_ba(dram_bank),
        .ddr_cas_n(dram_cas),
        .ddr_ras_n(dram_ras),
        .ddr_we_n(dram_we),
        .ddr_cs_n(dram_cs),
        .ddr_cke(dram_cke),
        .ddr_odt(dram_odt),
        .ddr_dq(dram_data),
        .ddr_dm(dram_mask),
        .ddr_dqs(dram_strobe),
        
        .init_done(mem_init_complete),
        .error_status(mem_error_code),
        .timing_params(ddr_timing_cfg)
    );

endmodule