`timescale 1ns/1ps
`default_nettype none

module tb_SM_top;
    reg         sys_clk;
    reg         sys_rst_n;
    reg         key_n;

    wire        h_sync;
    wire        v_sync;
    wire [15:0] rgb;

    SM_top dut (
        .sys_clk   (sys_clk),
        .sys_rst_n (sys_rst_n),
        .key_n     (key_n),
        .h_sync    (h_sync),
        .v_sync    (v_sync),
        .rgb       (rgb)
    );

    localparam integer CLK_HALF_NS = 10;
    initial begin
        sys_clk = 1'b0;
        forever #(CLK_HALF_NS) sys_clk = ~sys_clk;
    end

    task automatic press_key_n(input integer pulse_ns, input integer gap_ns);
    begin
        key_n = 1'b0;
        #(pulse_ns);
        key_n = 1'b1;
        #(gap_ns);
    end
    endtask

    task automatic tap_reset(input integer reset_len_ns, input integer wait_after_ns);
    begin
        sys_rst_n = 1'b0;
        #(reset_len_ns);
        sys_rst_n = 1'b1;
        #(wait_after_ns);
    end
    endtask

    initial begin
        sys_rst_n = 1'b0;
        key_n     = 1'b1;

        $dumpfile("tb_SM_top.vcd");
        $dumpvars(0, tb_SM_top);

        #20000;
        sys_rst_n = 1'b1;

        #100_00000;


        press_key_n(5_000, 50_000); 

        #200_00000;

        press_key_n(5_000, 50_000);

        #200_00000;

        tap_reset(2_000, 100_000);

        #200_00000;

        $finish;
    end

endmodule

`default_nettype wire
