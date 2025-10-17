module trace_blackhole (
    input  wire        trace_clk,
    input  wire [31:0] trace_data,
    input  wire        trace_ctl
);

    // Consume the inputs so they are not optimized away
    reg [31:0] dummy_data;
    reg        dummy_ctl;

    always @(posedge trace_clk) begin
        dummy_data <= trace_data;
        dummy_ctl  <= trace_ctl;
    end

endmodule