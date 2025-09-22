module top_full (
    input  [7:0] top_in1,
    input  [3:0] top_in2,
    output [7:0] top_out1,
    output [3:0] top_out2,
    output top_ready
);

    wire [7:0] ip_din_a_test;
    wire [3:0] ip_din_b_test;
    wire [7:0] ip_dout_a_test;
    wire [3:0] ip_dout_b_test;
    wire ip_ready_test;

    assign ip_din_a_test = top_in1;
    assign ip_din_b_test = top_in2;

    ip_full ip_inst (
        .din_a(ip_din_a_test),
        .din_b(ip_din_b_test),
        .dout_a(ip_dout_a_test),
        .dout_b(ip_dout_b_test),
        .ready(ip_ready_test)
    );

    assign top_out1 = ip_dout_a_test;
    assign top_out2 = ip_dout_b_test;
    assign top_ready = ip_ready_test;

endmodule
