module tpiu_to_axi (
    input  wire [31:0] IN_DATA,
    input  wire        ACLK,
    input  wire        ARESETN,
    input  wire        TREADY,
    output reg  [31:0] TDATA,
    output reg         TVALID,
    output reg         TLAST,
    output reg         DROPPED
);

    // Constants for synchronization packets
    localparam [31:0] SYNCH_PACKET      = 32'h7FFFFFFF;
    localparam [31:0] HALF_SYNCH_PACKET = 32'h7FFF7FFF;

    reg last_synch;
    reg [2:0] beat_count; // 3-bit counter for 8 beats = 2 frames

    always @(posedge ACLK) begin
        if (!ARESETN) begin
            last_synch <= 1'b0;
            TVALID     <= 1'b0;
            TDATA      <= 32'b0;
            TLAST      <= 1'b0;
            DROPPED    <= 1'b0;
            beat_count <= 3'b0;
        end else begin
            TLAST <= 1'b0; // default

            if (TREADY) begin
                // Forward only non-synch data
                if (IN_DATA != SYNCH_PACKET && IN_DATA != HALF_SYNCH_PACKET) begin
                    TDATA  <= IN_DATA;
                    TVALID <= 1'b1;
                    last_synch <= 1'b0;

                    if (beat_count == 3'b111) begin // TLAST every 2 frames (8 beats)
                        TLAST      <= 1'b1;
                        beat_count <= 3'b0;
                    end else begin
                        beat_count <= beat_count + 1;
                    end
                end
                else begin
                    DROPPED <= 1'b1;
                    TVALID  <= 1'b0;
                end
            end else begin
                TVALID <= 1'b0;
            end
        end
    end

endmodule