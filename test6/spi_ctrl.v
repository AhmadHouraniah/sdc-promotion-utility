// SPI Controller IP with multiple clock domains
module spi_ctrl (
    // Clock and reset
    input  core_clk,        // Main processing clock
    input  sclk_out,        // SPI serial clock output
    input  sclk_in,         // SPI serial clock input (for slave mode)
    input  arst_n,          // Async reset
    
    // Control interface
    input  enable,
    input  mode_sel,        // 0=master, 1=slave
    input  [1:0] cpol_cpha, // Clock polarity and phase
    input  [7:0] div_ratio, // Clock divider for master mode
    
    // Data interface
    input  [31:0] tx_data,
    input  tx_valid,
    output tx_ready,
    output [31:0] rx_data,
    output rx_valid,
    input  rx_ready,
    
    // SPI physical interface
    output spi_cs_n,
    output spi_mosi,
    input  spi_miso,
    output spi_sclk,
    
    // Status
    output busy,
    output [3:0] error_flags,
    
    // Debug interface (internal only)
    input  debug_enable,
    output [1:0] debug_status
);

    // Internal registers
    reg [31:0] tx_shift_reg;
    reg [31:0] rx_shift_reg;
    reg [5:0] bit_counter;
    reg [7:0] clk_div_counter;
    reg spi_active;
    reg [1:0] state;
    
    // Clock domain crossing
    reg enable_sync1, enable_sync2;
    reg tx_valid_sync1, tx_valid_sync2;
    
    // Core clock domain logic
    always @(posedge core_clk or negedge arst_n) begin
        if (!arst_n) begin
            enable_sync1 <= 1'b0;
            enable_sync2 <= 1'b0;
            tx_valid_sync1 <= 1'b0;
            tx_valid_sync2 <= 1'b0;
            state <= 2'b00;
        end else begin
            enable_sync1 <= enable;
            enable_sync2 <= enable_sync1;
            tx_valid_sync1 <= tx_valid;
            tx_valid_sync2 <= tx_valid_sync1;
            
            // State machine logic here
            case (state)
                2'b00: if (enable_sync2 && tx_valid_sync2) state <= 2'b01;
                2'b01: if (bit_counter == 6'd32) state <= 2'b10;
                2'b10: state <= 2'b00;
                default: state <= 2'b00;
            endcase
        end
    end
    
    // SPI clock domain logic
    always @(posedge sclk_out or negedge arst_n) begin
        if (!arst_n) begin
            tx_shift_reg <= 32'b0;
            rx_shift_reg <= 32'b0;
            bit_counter <= 6'b0;
            spi_active <= 1'b0;
        end else begin
            if (spi_active) begin
                tx_shift_reg <= {tx_shift_reg[30:0], 1'b0};
                rx_shift_reg <= {rx_shift_reg[30:0], spi_miso};
                bit_counter <= bit_counter + 1;
                if (bit_counter == 6'd31) spi_active <= 1'b0;
            end else if (state == 2'b01) begin
                tx_shift_reg <= tx_data;
                spi_active <= 1'b1;
                bit_counter <= 6'b0;
            end
        end
    end
    
    // Output assignments
    assign tx_ready = (state == 2'b00) && !spi_active;
    assign rx_data = rx_shift_reg;
    assign rx_valid = (state == 2'b10);
    assign spi_mosi = tx_shift_reg[31];
    assign spi_cs_n = !spi_active;
    assign spi_sclk = sclk_out & spi_active;
    assign busy = spi_active || (state != 2'b00);
    assign error_flags = 4'b0; // Simplified
    
    // Debug outputs (internal use only)
    assign debug_status = {debug_enable, spi_active};
    
endmodule