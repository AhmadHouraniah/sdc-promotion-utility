module top (
    input  [3:0] top_in,
    output [3:0] top_out
);

    wire [3:0] ip_din_test;
    wire [3:0] ip_dout_test;

    assign ip_din_test = top_in;

    ip ip_inst (
        .din(ip_din_test),
        .dout(ip_dout_test)
    );

    assign top_out = ip_dout_test;
endmodule
