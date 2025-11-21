module tpiu_sync_detect (
    input  wire        ACLK,
    input  wire        ARESETN,
    input  wire [31:0] IN_DATA,
    output reg         ce_out
);

    localparam [31:0] SYNCH_PACKET      = 32'h7FFFFFFF;
    localparam [31:0] HALF_SYNCH_PACKET = 32'h7FFF7FFF;

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            ce_out <= 1'b0;
        end else begin
            if (IN_DATA == SYNCH_PACKET || IN_DATA == HALF_SYNCH_PACKET)
                ce_out <= 1'b1;
            else
                ce_out <= 1'b0;
        end
    end

endmodule
