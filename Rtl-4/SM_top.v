module SM_top (
    input  wire        sys_clk,
    input  wire        sys_rst_n,
    input  wire        key_n,
    output wire        h_sync,
    output wire        v_sync,
    output wire [15:0] rgb
);

    wire vga_clk;
    pll pll_inst (
        .sys_clk   (sys_clk),
        .sys_rst_n (sys_rst_n),
        .vga_clk   (vga_clk)
    );

    wire btn_pressed;
    btn_debouncer #(.CNTR_BITS(18))
    u_db (
        .clk     (vga_clk),
        .rst_n   (sys_rst_n),
        .btn_n   (key_n),
        .pressed (btn_pressed)
    );

    localparam [1:0] S_COLOR = 2'd0,
                     S_MUST  = 2'd1,
                     S_END   = 2'd2;

    reg [1:0] state, state_n;
    always @(posedge vga_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) state <= S_COLOR;
        else            state <= state_n;
    end
    always @* begin
        state_n = state;
        if (btn_pressed) begin
            case (state)
                S_COLOR: state_n = S_MUST;
                S_MUST : state_n = S_END;
                S_END  : state_n = S_COLOR;
                default: state_n = S_COLOR;
            endcase
        end
    end

    wire [9:0]  pix_x, pix_y;
    wire [15:0] pix_data_color;
    wire [15:0] pix_data_must;
    wire [15:0] pix_data_end;
    reg  [15:0] pix_data_mux;

    vga_pic_color u_color (
        .vga_clk  (vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_x    (pix_x),
        .pix_y    (pix_y),
        .pix_data (pix_data_color)
    );
    vga_pic u_must (
        .vga_clk  (vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_x    (pix_x),
        .pix_y    (pix_y),
        .pix_data (pix_data_must)
    );
    vga_pic_end u_end (
        .vga_clk  (vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_x    (pix_x),
        .pix_y    (pix_y),
        .pix_data (pix_data_end)
    );

    always @* begin
        case (state)
            S_COLOR: pix_data_mux = pix_data_color;
            S_MUST : pix_data_mux = pix_data_must;
            S_END  : pix_data_mux = pix_data_end;
            default: pix_data_mux = 16'h0000;
        endcase
    end

    vga_ctrl u_vga (
        .vga_clk  (vga_clk),
        .sys_rst_n(sys_rst_n),
        .pix_data (pix_data_mux),
        .pix_x    (pix_x),
        .pix_y    (pix_y),
        .hsync    (h_sync),
        .vsync    (v_sync),
        .rgb      (rgb)
    );
endmodule

module btn_debouncer #(
    parameter integer CNTR_BITS = 16
)(
    input  wire clk,
    input  wire rst_n,
    input  wire btn_n,
    output wire pressed
);

    reg btn_sync0, btn_sync1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            btn_sync0 <= 1'b1;
            btn_sync1 <= 1'b1;
        end else begin
            btn_sync0 <= btn_n;
            btn_sync1 <= btn_sync0;
        end
    end
	 
    reg [CNTR_BITS-1:0] db_cnt;
    reg stable_level;
    wire btn_level = btn_sync1;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            db_cnt       <= {CNTR_BITS{1'b0}};
            stable_level <= 1'b1;
        end else if (btn_level != stable_level) begin
            db_cnt <= db_cnt + 1'b1;
            if (&db_cnt) begin
                stable_level <= btn_level;
                db_cnt       <= {CNTR_BITS{1'b0}};
            end
        end else begin
            db_cnt <= {CNTR_BITS{1'b0}};
        end
    end
    reg stable_level_d;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) stable_level_d <= 1'b1;
        else        stable_level_d <= stable_level;
    end
    assign pressed = (stable_level_d == 1'b1) && (stable_level == 1'b0);
endmodule