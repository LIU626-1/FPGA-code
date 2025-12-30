`timescale 1ns / 1ps

module vga_pic_start(
    input  wire        vga_clk,
    input  wire        sys_rst_n,
    input  wire [9:0]  pix_x,
    input  wire [9:0]  pix_y,
    output reg  [15:0] pix_data
);


    localparam H_DISP = 640;
    localparam V_DISP = 480;

    localparam BIT_W   = 80;
    localparam BIT_H   = 16;
    localparam SCALE   = 4;

    localparam CHAR_W  = BIT_W * SCALE;
    localparam CHAR_H  = BIT_H * SCALE;

    localparam CHAR_X  = (H_DISP - CHAR_W) / 2;
    localparam CHAR_Y  = (V_DISP - CHAR_H) / 2;

    reg [4:0] bitmap_mem [0:255];

    initial begin
        bitmap_mem[0]  = 5'b00000; bitmap_mem[1]  = 5'b00000;
        bitmap_mem[2]  = 5'b00000; bitmap_mem[3]  = 5'b00000;
        bitmap_mem[4]  = 5'b00000; bitmap_mem[5]  = 5'b00000;
        bitmap_mem[6]  = 5'b00000; bitmap_mem[7]  = 5'b00000;
        bitmap_mem[8]  = 5'b00000; bitmap_mem[9]  = 5'b00000;
        bitmap_mem[10] = 5'b00000; bitmap_mem[11] = 5'b00000;
        bitmap_mem[12] = 5'b00000; bitmap_mem[13] = 5'b00000;
        bitmap_mem[14] = 5'b00000; bitmap_mem[15] = 5'b00000;

        bitmap_mem[16] = 5'b00000; bitmap_mem[17] = 5'b00000;
        bitmap_mem[18] = 5'b00000; bitmap_mem[19] = 5'b00000;
        bitmap_mem[20] = 5'b00000; bitmap_mem[21] = 5'b00000;
        bitmap_mem[22] = 5'b00000; bitmap_mem[23] = 5'b00000;
        bitmap_mem[24] = 5'b11100; bitmap_mem[25] = 5'b00000;
        bitmap_mem[26] = 5'b00000; bitmap_mem[27] = 5'b00000;
        bitmap_mem[28] = 5'b00000; bitmap_mem[29] = 5'b00000;
        bitmap_mem[30] = 5'b00000; bitmap_mem[31] = 5'b00000;

        bitmap_mem[32] = 5'b11111; bitmap_mem[33] = 5'b00000;
        bitmap_mem[34] = 5'b00000; bitmap_mem[35] = 5'b00000;
        bitmap_mem[36] = 5'b00000; bitmap_mem[37] = 5'b00000;
        bitmap_mem[38] = 5'b00000; bitmap_mem[39] = 5'b00000;
        bitmap_mem[40] = 5'b11100; bitmap_mem[41] = 5'b00000;
        bitmap_mem[42] = 5'b00000; bitmap_mem[43] = 5'b00000;
        bitmap_mem[44] = 5'b00000; bitmap_mem[45] = 5'b00000;
        bitmap_mem[46] = 5'b01100; bitmap_mem[47] = 5'b00000;

        bitmap_mem[48] = 5'b11111; bitmap_mem[49] = 5'b00000;
        bitmap_mem[50] = 5'b00000; bitmap_mem[51] = 5'b00000;
        bitmap_mem[52] = 5'b00000; bitmap_mem[53] = 5'b00000;
        bitmap_mem[54] = 5'b00000; bitmap_mem[55] = 5'b00000;
        bitmap_mem[56] = 5'b01100; bitmap_mem[57] = 5'b00000;
        bitmap_mem[58] = 5'b00000; bitmap_mem[59] = 5'b00000;
        bitmap_mem[60] = 5'b00000; bitmap_mem[61] = 5'b00000;
        bitmap_mem[62] = 5'b01100; bitmap_mem[63] = 5'b00000;

        bitmap_mem[64] = 5'b01001; bitmap_mem[65] = 5'b10000;
        bitmap_mem[66] = 5'b11111; bitmap_mem[67] = 5'b10000;
        bitmap_mem[68] = 5'b01111; bitmap_mem[69] = 5'b00000;
        bitmap_mem[70] = 5'b01111; bitmap_mem[71] = 5'b00000;
        bitmap_mem[72] = 5'b01111; bitmap_mem[73] = 5'b10000;
        bitmap_mem[74] = 5'b01111; bitmap_mem[75] = 5'b00000;
        bitmap_mem[76] = 5'b11011; bitmap_mem[77] = 5'b00000;
        bitmap_mem[78] = 5'b11111; bitmap_mem[79] = 5'b00000;

        bitmap_mem[80] = 5'b01001; bitmap_mem[81] = 5'b10000;
        bitmap_mem[82] = 5'b11111; bitmap_mem[83] = 5'b10000;
        bitmap_mem[84] = 5'b11111; bitmap_mem[85] = 5'b00000;
        bitmap_mem[86] = 5'b01111; bitmap_mem[87] = 5'b00000;
        bitmap_mem[88] = 5'b01111; bitmap_mem[89] = 5'b10000;
        bitmap_mem[90] = 5'b01111; bitmap_mem[91] = 5'b00000;
        bitmap_mem[92] = 5'b11011; bitmap_mem[93] = 5'b00000;
        bitmap_mem[94] = 5'b11111; bitmap_mem[95] = 5'b00000;

        bitmap_mem[96] = 5'b01111; bitmap_mem[97] = 5'b00000;
        bitmap_mem[98] = 5'b01111; bitmap_mem[99] = 5'b10000;
        bitmap_mem[100]= 5'b11011; bitmap_mem[101]= 5'b10000;
        bitmap_mem[102]= 5'b00011; bitmap_mem[103]= 5'b00000;
        bitmap_mem[104]= 5'b01111; bitmap_mem[105]= 5'b00000;
        bitmap_mem[106]= 5'b11111; bitmap_mem[107]= 5'b10000;
        bitmap_mem[108]= 5'b01001; bitmap_mem[109]= 5'b00000;
        bitmap_mem[110]= 5'b01100; bitmap_mem[111]= 5'b00000;

        bitmap_mem[112]= 5'b01111; bitmap_mem[113]= 5'b10000;
        bitmap_mem[114]= 5'b01110; bitmap_mem[115]= 5'b00000;
        bitmap_mem[116]= 5'b11001; bitmap_mem[117]= 5'b10000;
        bitmap_mem[118]= 5'b00001; bitmap_mem[119]= 5'b00000;
        bitmap_mem[120]= 5'b01111; bitmap_mem[121]= 5'b00000;
        bitmap_mem[122]= 5'b11001; bitmap_mem[123]= 5'b10000;
        bitmap_mem[124]= 5'b01001; bitmap_mem[125]= 5'b00000;
        bitmap_mem[126]= 5'b01100; bitmap_mem[127]= 5'b00000;

        bitmap_mem[128]= 5'b01001; bitmap_mem[129]= 5'b10000;
        bitmap_mem[130]= 5'b01100; bitmap_mem[131]= 5'b00000;
        bitmap_mem[132]= 5'b11111; bitmap_mem[133]= 5'b10000;
        bitmap_mem[134]= 5'b11111; bitmap_mem[135]= 5'b00000;
        bitmap_mem[136]= 5'b01110; bitmap_mem[137]= 5'b00000;
        bitmap_mem[138]= 5'b11001; bitmap_mem[139]= 5'b10000;
        bitmap_mem[140]= 5'b01001; bitmap_mem[141]= 5'b00000;
        bitmap_mem[142]= 5'b01100; bitmap_mem[143]= 5'b00000;

        bitmap_mem[144]= 5'b01001; bitmap_mem[145]= 5'b10000;
        bitmap_mem[146]= 5'b01100; bitmap_mem[147]= 5'b00000;
        bitmap_mem[148]= 5'b11000; bitmap_mem[149]= 5'b00000;
        bitmap_mem[150]= 5'b11001; bitmap_mem[151]= 5'b00000;
        bitmap_mem[152]= 5'b01111; bitmap_mem[153]= 5'b00000;
        bitmap_mem[154]= 5'b11001; bitmap_mem[155]= 5'b10000;
        bitmap_mem[156]= 5'b01001; bitmap_mem[157]= 5'b00000;
        bitmap_mem[158]= 5'b01100; bitmap_mem[159]= 5'b00000;

        bitmap_mem[160]= 5'b01001; bitmap_mem[161]= 5'b10000;
        bitmap_mem[162]= 5'b01100; bitmap_mem[163]= 5'b00000;
        bitmap_mem[164]= 5'b11101; bitmap_mem[165]= 5'b10000;
        bitmap_mem[166]= 5'b11011; bitmap_mem[167]= 5'b00000;
        bitmap_mem[168]= 5'b01111; bitmap_mem[169]= 5'b00000;
        bitmap_mem[170]= 5'b11001; bitmap_mem[171]= 5'b10000;
        bitmap_mem[172]= 5'b01011; bitmap_mem[173]= 5'b00000;
        bitmap_mem[174]= 5'b01101; bitmap_mem[175]= 5'b10000;

        bitmap_mem[176]= 5'b11111; bitmap_mem[177]= 5'b10000;
        bitmap_mem[178]= 5'b11111; bitmap_mem[179]= 5'b00000;
        bitmap_mem[180]= 5'b01111; bitmap_mem[181]= 5'b10000;
        bitmap_mem[182]= 5'b11111; bitmap_mem[183]= 5'b10000;
        bitmap_mem[184]= 5'b11111; bitmap_mem[185]= 5'b10000;
        bitmap_mem[186]= 5'b01111; bitmap_mem[187]= 5'b00000;
        bitmap_mem[188]= 5'b01111; bitmap_mem[189]= 5'b10000;
        bitmap_mem[190]= 5'b01111; bitmap_mem[191]= 5'b10000;

        bitmap_mem[192]= 5'b00000; bitmap_mem[193]= 5'b00000;
        bitmap_mem[194]= 5'b00000; bitmap_mem[195]= 5'b00000;
        bitmap_mem[196]= 5'b00000; bitmap_mem[197]= 5'b00000;
        bitmap_mem[198]= 5'b00000; bitmap_mem[199]= 5'b00000;
        bitmap_mem[200]= 5'b00000; bitmap_mem[201]= 5'b00000;
        bitmap_mem[202]= 5'b00000; bitmap_mem[203]= 5'b00000;
        bitmap_mem[204]= 5'b00000; bitmap_mem[205]= 5'b00000;
        bitmap_mem[206]= 5'b00000; bitmap_mem[207]= 5'b00000;

        bitmap_mem[208]= 5'b00000; bitmap_mem[209]= 5'b00000;
        bitmap_mem[210]= 5'b00000; bitmap_mem[211]= 5'b00000;
        bitmap_mem[212]= 5'b00000; bitmap_mem[213]= 5'b00000;
        bitmap_mem[214]= 5'b00000; bitmap_mem[215]= 5'b00000;
        bitmap_mem[216]= 5'b00000; bitmap_mem[217]= 5'b00000;
        bitmap_mem[218]= 5'b00000; bitmap_mem[219]= 5'b00000;
        bitmap_mem[220]= 5'b00000; bitmap_mem[221]= 5'b00000;
        bitmap_mem[222]= 5'b00000; bitmap_mem[223]= 5'b00000;

        bitmap_mem[224]= 5'b00000; bitmap_mem[225]= 5'b00000;
        bitmap_mem[226]= 5'b00000; bitmap_mem[227]= 5'b00000;
        bitmap_mem[228]= 5'b00000; bitmap_mem[229]= 5'b00000;
        bitmap_mem[230]= 5'b00000; bitmap_mem[231]= 5'b00000;
        bitmap_mem[232]= 5'b00000; bitmap_mem[233]= 5'b00000;
        bitmap_mem[234]= 5'b00000; bitmap_mem[235]= 5'b00000;
        bitmap_mem[236]= 5'b00000; bitmap_mem[237]= 5'b00000;
        bitmap_mem[238]= 5'b00000; bitmap_mem[239]= 5'b00000;

        bitmap_mem[240]= 5'b00000; bitmap_mem[241]= 5'b00000;
        bitmap_mem[242]= 5'b00000; bitmap_mem[243]= 5'b00000;
        bitmap_mem[244]= 5'b00000; bitmap_mem[245]= 5'b00000;
        bitmap_mem[246]= 5'b00000; bitmap_mem[247]= 5'b00000;
        bitmap_mem[248]= 5'b00000; bitmap_mem[249]= 5'b00000;
        bitmap_mem[250]= 5'b00000; bitmap_mem[251]= 5'b00000;
        bitmap_mem[252]= 5'b00000; bitmap_mem[253]= 5'b00000;
        bitmap_mem[254]= 5'b00000; bitmap_mem[255]= 5'b00000;
    end

    integer sx, sy;
    integer bx, by;
    integer idx;
    integer bit_x;

    always @(*) begin
        pix_data = 16'h0000;

        if ( (pix_x >= CHAR_X) && (pix_x < CHAR_X + CHAR_W) &&
             (pix_y >= CHAR_Y) && (pix_y < CHAR_Y + CHAR_H) ) begin

            sx = pix_x - CHAR_X;
            sy = pix_y - CHAR_Y;

            bx = sx / SCALE;
            by = sy / SCALE;

            idx   = by * 16 + (bx / 5);
            bit_x = bx % 5;

            if (bitmap_mem[idx][4 - bit_x])
                pix_data = 16'hFFFF;
        end
    end

endmodule
