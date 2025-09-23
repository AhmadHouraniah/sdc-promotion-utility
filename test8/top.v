// Test8 top level - Design Compiler style peripheral controller
module top (
    // Top-level clocks
    input wire main_clk_100mhz,
    input wire aux_clk_50mhz,
    input wire reset_n,
    
    // External APB interface
    input wire [31:0] ext_apb_addr,
    input wire ext_apb_sel,
    input wire ext_apb_enable,
    input wire ext_apb_write,
    input wire [31:0] ext_apb_wdata,
    output wire [31:0] ext_apb_rdata,
    output wire ext_apb_ready,
    output wire ext_apb_slverr,
    
    // External GPIO banks
    input wire [31:0] ext_gpio_a_inputs,
    output wire [31:0] ext_gpio_a_outputs,
    output wire [31:0] ext_gpio_a_enables,
    input wire [15:0] ext_gpio_b_inputs,
    output wire [15:0] ext_gpio_b_outputs,
    output wire [15:0] ext_gpio_b_enables,
    
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
    input wire ext_uart1_cts_n
);

    // Generate internal clocks from top-level clocks
    wire clk_periph_100mhz = main_clk_100mhz;
    wire clk_periph_50mhz = aux_clk_50mhz;
    wire \clk_periph_25mhz/generated ;
    wire \rst_periph_domain_n$sync  = reset_n;

    // Simple clock divider for 25MHz
    reg clk_div_reg = 1'b0;
    always @(posedge clk_periph_50mhz or negedge reset_n) begin
        if (!reset_n)
            clk_div_reg <= 1'b0;
        else
            clk_div_reg <= ~clk_div_reg;
    end
    assign \clk_periph_25mhz/generated  = clk_div_reg;

    // Instantiate the peripheral controller IP
    peripheral_controller_v1_4_2 ip_inst (
        // Clocks
        .clk_periph_100mhz(clk_periph_100mhz),
        .clk_periph_50mhz(clk_periph_50mhz),
        .\clk_periph_25mhz/generated (\clk_periph_25mhz/generated ),
        .\rst_periph_domain_n$sync (\rst_periph_domain_n$sync ),
        
        // APB interface
        .\apb_if_v2_1/paddr[31:0] (ext_apb_addr),
        .\apb_if_v2_1/psel_qualified (ext_apb_sel),
        .\apb_if_v2_1/penable_sync (ext_apb_enable),
        .\apb_if_v2_1/pwrite_direction (ext_apb_write),
        .\apb_if_v2_1/pwdata[31:0] (ext_apb_wdata),
        .\apb_if_v2_1/prdata[31:0] (ext_apb_rdata),
        .\apb_if_v2_1/pready_response (ext_apb_ready),
        .\apb_if_v2_1/pslverr_indicator (ext_apb_slverr),
        
        // GPIO interfaces
        .\gpio_bank_A/input_pins[31:0] (ext_gpio_a_inputs),
        .\gpio_bank_A/output_pins[31:0] (ext_gpio_a_outputs),
        .\gpio_bank_A/output_enable[31:0] (ext_gpio_a_enables),
        .\gpio_bank_B/input_pins[15:0] (ext_gpio_b_inputs),
        .\gpio_bank_B/output_pins[15:0] (ext_gpio_b_outputs),
        .\gpio_bank_B/output_enable[15:0] (ext_gpio_b_enables),
        
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
        .\uart1_if_v2_3/cts_n_filtered (ext_uart1_cts_n)
    );

endmodule