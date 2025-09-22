// IP2: Simple ALU with Pipeline
module ip2 (
    input  clk,
    input  rst_n,
    input  [15:0] operand_a,
    input  [15:0] operand_b,
    input  [2:0] alu_op,
    input  valid_in,
    output reg [15:0] result,
    output reg valid_out,
    output reg overflow
);

    reg [15:0] stage1_a, stage1_b;
    reg [2:0] stage1_op;
    reg stage1_valid;
    
    // Pipeline Stage 1: Register inputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_a <= 16'b0;
            stage1_b <= 16'b0;
            stage1_op <= 3'b0;
            stage1_valid <= 1'b0;
        end else begin
            stage1_a <= operand_a;
            stage1_b <= operand_b;
            stage1_op <= alu_op;
            stage1_valid <= valid_in;
        end
    end
    
    // Pipeline Stage 2: Compute result
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 16'b0;
            valid_out <= 1'b0;
            overflow <= 1'b0;
        end else begin
            valid_out <= stage1_valid;
            overflow <= 1'b0;
            
            case (stage1_op)
                3'b000: result <= stage1_a + stage1_b;  // ADD
                3'b001: result <= stage1_a - stage1_b;  // SUB
                3'b010: result <= stage1_a & stage1_b;  // AND
                3'b011: result <= stage1_a | stage1_b;  // OR
                3'b100: result <= stage1_a ^ stage1_b;  // XOR
                3'b101: result <= stage1_a << 1;        // SHL
                3'b110: result <= stage1_a >> 1;        // SHR
                default: result <= 16'b0;
            endcase
            
            // Check for overflow on ADD/SUB
            if (stage1_op == 3'b000 || stage1_op == 3'b001) begin
                overflow <= (stage1_a[15] == stage1_b[15]) && 
                           (result[15] != stage1_a[15]);
            end
        end
    end
    
endmodule
