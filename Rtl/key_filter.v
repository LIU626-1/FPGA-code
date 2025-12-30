`timescale 1ns/1ns
module key_filter #(
    parameter integer CNT_MAX   = 1_000_000,
    parameter integer CNT_WIDTH = 20
)(
    input  wire clk,
    input  wire rst_n,
    input  wire key_n,
    output reg  key_state,
    output reg  key_flag
);

    reg [CNT_WIDTH-1:0] cnt;
    reg key_n_last;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            key_n_last <= 1'b1;
            cnt        <= {CNT_WIDTH{1'b0}};
            key_state  <= 1'b0;
            key_flag   <= 1'b0;
        end else begin
            key_flag <= 1'b0;

            if (key_n == key_n_last) begin
                if (cnt < CNT_MAX - 1)
                    cnt <= cnt + 1'b1;
                else begin
                    cnt <= {CNT_WIDTH{1'b0}};
                    if (key_state != ~key_n) begin
                        key_state <= ~key_n;
                        if (~key_n == 1'b1)
                            key_flag <= 1'b1;
                    end
                end
            end else begin
                key_n_last <= key_n;
                cnt        <= {CNT_WIDTH{1'b0}};
            end
        end
    end

endmodule
