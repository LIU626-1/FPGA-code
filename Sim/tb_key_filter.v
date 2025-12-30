`timescale 1ns/1ns
module tb_key_filter;

  reg clk;
  reg rst_n;
  reg key_n;

  wire key_state;
  wire key_flag;

  key_filter dut (
    .clk(clk),
    .rst_n(rst_n),
    .key_n(key_n),
    .key_state(key_state),
    .key_flag(key_flag)
  );

  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
  end

  initial begin
    rst_n = 1'b0;
    key_n = 1'b1;
    #200;
    rst_n = 1'b1;
  end

  initial begin
    $timeformat(-3, 3, " ms", 10);
  end

  always @(posedge clk) begin
    if (key_flag) $display("%t  key_flag=1  key_state=%b  cnt=%0d", $realtime, key_state, dut.cnt);
  end

  always @(key_state) begin
    if (rst_n) $display("%t  key_state->%b  cnt=%0d", $realtime, key_state, dut.cnt);
  end

  task wait_ms;
    input integer ms;
    time t;
    begin
      t = ms * 1_000_000;
      #(t);
    end
  endtask

  task bounce_to_ms;
    input target;
    input integer bounce_ms;
    integer i;
    begin
      for (i = 0; i < bounce_ms; i = i + 1) begin
        #200_000 key_n = ~key_n;
        #200_000 key_n = ~key_n;
        #300_000 key_n = ~key_n;
        #300_000 key_n = ~key_n;
      end
      key_n = target;
    end
  endtask

  task press_with_bounce;
    input integer bounce_ms;
    input integer hold_ms;
    begin
      bounce_to_ms(1'b0, bounce_ms);
      wait_ms(hold_ms);
    end
  endtask

  task release_with_bounce;
    input integer bounce_ms;
    input integer hold_ms;
    begin
      bounce_to_ms(1'b1, bounce_ms);
      wait_ms(hold_ms);
    end
  endtask

  task press_short;
    input integer bounce_ms;
    input integer hold_ms;
    begin
      bounce_to_ms(1'b0, bounce_ms);
      wait_ms(hold_ms);
      bounce_to_ms(1'b1, bounce_ms);
    end
  endtask

  initial begin
    wait(rst_n);

    wait_ms(5);

    press_with_bounce(2, 30);
    release_with_bounce(2, 25);

    press_with_bounce(3, 40);
    release_with_bounce(2, 20);

    press_short(2, 10);
    wait_ms(20);

    press_with_bounce(2, 35);
    release_with_bounce(3, 25);

    wait_ms(200);
    $finish;
  end

endmodule
