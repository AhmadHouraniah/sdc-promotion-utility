// DDR Memory Controller IP
module mem_ctrl (
    // Clock domains
    input  sys_clk,         // System interface clock
    input  ddr_clk,         // DDR interface clock (higher frequency)
    input  ref_clk,         // Reference clock for refresh
    input  rst_n,           // Reset
    
    // System interface
    input  [31:0] cmd_addr,
    input  [2:0] cmd_type,  // 000=read, 001=write, 010=refresh
    input  cmd_valid,
    output cmd_ready,
    input  [127:0] wr_data,
    input  [15:0] wr_mask,
    input  wr_valid,
    output wr_ready,
    output [127:0] rd_data,
    output rd_valid,
    input  rd_ready,
    
    // DDR interface
    output [13:0] ddr_addr,
    output [2:0] ddr_ba,
    output ddr_cas_n,
    output ddr_ras_n,
    output ddr_we_n,
    output ddr_cs_n,
    output ddr_cke,
    output ddr_odt,
    inout  [63:0] ddr_dq,
    inout  [7:0] ddr_dm,
    inout  [7:0] ddr_dqs,
    
    // Status and control
    output init_done,
    output [3:0] error_status,
    input  [7:0] timing_params
);

    // State machines
    reg [3:0] init_state;
    reg [2:0] cmd_state;
    reg [2:0] ddr_state;
    reg init_done_reg;  // Internal register for init_done output
    
    // Command buffer
    reg [31:0] cmd_buffer_addr [0:7];
    reg [2:0] cmd_buffer_type [0:7];
    reg [2:0] cmd_wr_ptr, cmd_rd_ptr;
    reg [3:0] cmd_count;
    
    // Data buffers
    reg [127:0] wr_data_buffer [0:3];
    reg [127:0] rd_data_buffer [0:3];
    reg [2:0] wr_buf_ptr, rd_buf_ptr;
    
    // Timing counters
    reg [7:0] refresh_counter;
    reg [4:0] cas_latency_cnt;
    reg [3:0] precharge_cnt;
    reg [5:0] activate_cnt;
    
    // Clock domain crossing registers
    reg cmd_valid_sync1, cmd_valid_sync2;
    reg wr_valid_sync1, wr_valid_sync2;
    reg rd_ready_sync1, rd_ready_sync2;
    
    // System clock domain
    always @(posedge sys_clk or negedge rst_n) begin
        if (!rst_n) begin
            cmd_state <= 3'b000;
            cmd_wr_ptr <= 3'b000;
            cmd_count <= 4'b0000;
            cmd_valid_sync1 <= 1'b0;
            cmd_valid_sync2 <= 1'b0;
        end else begin
            // Synchronize control signals
            cmd_valid_sync1 <= cmd_valid;
            cmd_valid_sync2 <= cmd_valid_sync1;
            
            // Command buffer management
            if (cmd_valid_sync2 && cmd_ready && cmd_count < 4'd8) begin
                cmd_buffer_addr[cmd_wr_ptr] <= cmd_addr;
                cmd_buffer_type[cmd_wr_ptr] <= cmd_type;
                cmd_wr_ptr <= cmd_wr_ptr + 1;
                cmd_count <= cmd_count + 1;
            end
            
            if (cmd_rd_ptr != cmd_wr_ptr && cmd_count > 0) begin
                // Process commands
                cmd_count <= cmd_count - 1;
            end
        end
    end
    
    // DDR clock domain
    always @(posedge ddr_clk or negedge rst_n) begin
        if (!rst_n) begin
            init_state <= 4'b0000;
            ddr_state <= 3'b000;
            refresh_counter <= 8'b0;
            cas_latency_cnt <= 5'b0;
            init_done_reg <= 1'b0;
        end else begin
            // Initialization sequence
            case (init_state)
                4'b0000: begin
                    if (refresh_counter == 8'd200) init_state <= 4'b0001;
                    refresh_counter <= refresh_counter + 1;
                end
                4'b0001: begin
                    // Precharge all
                    init_state <= 4'b0010;
                end
                4'b0010: begin
                    // Mode register set
                    init_state <= 4'b0011;
                end
                4'b0011: begin
                    init_done_reg <= 1'b1;
                    init_state <= 4'b0100;
                end
                default: begin
                    // Normal operation
                    refresh_counter <= refresh_counter + 1;
                    if (refresh_counter == 8'd255) begin
                        // Auto refresh needed
                        refresh_counter <= 8'b0;
                    end
                end
            endcase
            
            // DDR state machine
            case (ddr_state)
                3'b000: begin // IDLE
                    if (cmd_count > 0 && init_done_reg) ddr_state <= 3'b001;
                end
                3'b001: begin // ACTIVATE
                    activate_cnt <= activate_cnt + 1;
                    if (activate_cnt == 5'd15) ddr_state <= 3'b010;
                end
                3'b010: begin // READ/WRITE
                    cas_latency_cnt <= cas_latency_cnt + 1;
                    if (cas_latency_cnt == 5'd6) ddr_state <= 3'b011;
                end
                3'b011: begin // DATA
                    ddr_state <= 3'b100;
                end
                3'b100: begin // PRECHARGE
                    precharge_cnt <= precharge_cnt + 1;
                    if (precharge_cnt == 4'd8) ddr_state <= 3'b000;
                end
                default: ddr_state <= 3'b000;
            endcase
        end
    end
    
    // Reference clock domain for refresh timing
    always @(posedge ref_clk or negedge rst_n) begin
        if (!rst_n) begin
            // Refresh timing logic
        end else begin
            // Auto-refresh timing management
        end
    end
    
    // Output assignments
    assign cmd_ready = (cmd_count < 4'd7) && init_done_reg;
    assign wr_ready = (ddr_state == 3'b010) && (cmd_buffer_type[cmd_rd_ptr] == 3'b001);
    assign rd_valid = (ddr_state == 3'b011) && (cmd_buffer_type[cmd_rd_ptr] == 3'b000);
    assign rd_data = rd_data_buffer[rd_buf_ptr];
    
    // DDR control signals
    assign ddr_cs_n = !init_done_reg;
    assign ddr_cke = init_done_reg;
    assign ddr_ras_n = !(ddr_state == 3'b001);
    assign ddr_cas_n = !(ddr_state == 3'b010);
    assign ddr_we_n = !(ddr_state == 3'b010 && cmd_buffer_type[cmd_rd_ptr] == 3'b001);
    assign ddr_addr = cmd_buffer_addr[cmd_rd_ptr][13:0];
    assign ddr_ba = cmd_buffer_addr[cmd_rd_ptr][16:14];
    assign error_status = 4'b0000; // Simplified
    
    // Connect internal register to output port
    assign init_done = init_done_reg;
    
endmodule