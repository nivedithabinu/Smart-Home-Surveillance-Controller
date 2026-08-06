`timescale 1ns / 1ps

module seg7_controller (
    input  wire clk_1khz,
    input  wire rst,
    input  wire [1:0] state,
    
    output reg  [6:0] seg,   // segments [a:g], active-LOW
    output wire dp,          // decimal point off
    output reg [3:0] an      // digit anodes, active-LOW
);

    assign dp = 1'b1; // decimal point always OFF

    localparam IDLE        = 2'b00;
    localparam MOTION_DET  = 2'b01;
    localparam DOOR_ALERT  = 2'b10;
    localparam ALARM       = 2'b11;

    // 7-segment character codes (active-LOW, segments a-g)
    localparam SEG_I = 7'b1111001;

    // Active-HIGH segment patterns {a,b,c,d,e,f,g}
    localparam H_I = 7'b0110000; // I  (segments b,c)
    localparam H_d = 7'b1011110; // d  (segments b,c,d,e,g)
    localparam H_L = 7'b0111000; // L  (segments d,e,f)  - wait, L = f,e,d → {a=0,b=0,c=0,d=1,e=1,f=1,g=0}
    localparam H_E = 7'b1111001; // E  {a,b=0,c=0,d,e,f,g} → a,d,e,f,g = {1,0,0,1,1,1,1}
    localparam H_M = 7'b1110110; // M  - not standard 7seg; use H for wide feel: {a,b,c,d=0,e=0,f,g=0} →use closest
    localparam H_o = 7'b1011100; // o  (segments c,d,e,g) lowercase
    localparam H_t = 7'b0111000; // t  (segments d,e,f,g) - {0,0,0,1,1,1,1} note: f=1,e=1,d=1,g=1
    localparam H_n = 7'b0010100; // n  (segments c,e,g)
    localparam H_A = 7'b1110111; // A  {a,b,c,d=0,e,f,g}
    localparam H_r = 7'b0000101; // r  (segments e,g)
    localparam H_H = 7'b0110110; // H  (segments b,c,e,f,g)

    // Redefine cleanly using standard 7-seg:
    //  a=top, b=top-right, c=bot-right, d=bot, e=bot-left, f=top-left, g=mid
    //  Bit order in our reg: {a,b,c,d,e,f,g} = bits [6:0]

    // Character   a b c d e f g
    // I           0 1 1 0 0 0 0   = 7'b0110000
    // d           0 1 1 1 1 0 1   = 7'b0111101  (lowercase d)
    // L           0 0 0 1 1 1 0   = 7'b0001110
    // E           1 0 0 1 1 1 1   = 7'b1001111
    // n           0 0 1 0 1 0 1   = 7'b0010101
    // o           0 0 1 1 1 0 1   = 7'b0011101  (lowercase o)
    // t           0 0 0 1 1 1 1   = 7'b0001111
    // A           1 1 1 0 1 1 1   = 7'b1110111
    // r           0 0 0 0 1 0 1   = 7'b0000101
    // H           0 1 1 0 1 1 1   = 7'b0110111
    // M  (use 5-seg approximation: like two bumps)
    //             1 1 1 0 1 1 0   = 7'b1110110   (looks like capital M)

    // ── digit patterns (active-HIGH; we invert below) ──
    localparam [6:0] CH_I = 7'b0110000;
    localparam [6:0] CH_d = 7'b0111101;
    localparam [6:0] CH_L = 7'b0001110;
    localparam [6:0] CH_E = 7'b1001111;
    localparam [6:0] CH_n = 7'b0010101;
    localparam [6:0] CH_o = 7'b0011101;
    localparam [6:0] CH_t = 7'b0001111;
    localparam [6:0] CH_A = 7'b1110111;
    localparam [6:0] CH_r = 7'b0000101;
    localparam [6:0] CH_H = 7'b0110111;
    localparam [6:0] CH_M = 7'b1110110;

    //----------------------------------------------------------
    // Digit mux counter (2-bit → 4 digits)
    //----------------------------------------------------------
    reg [1:0] digit_sel;

    always @(posedge clk_1khz or posedge rst) begin
        if (rst)
            digit_sel <= 2'b00;
        else
            digit_sel <= digit_sel + 1;
    end

    // Digit content arrays for each state
    // Index 0 = leftmost digit (AN3), index 3 = rightmost (AN0)
    reg [6:0] disp [0:3];

    always @(*) begin
        case (state)
            // "IdLE"
            IDLE: begin
                disp[3] = CH_I;
                disp[2] = CH_d;
                disp[1] = CH_L;
                disp[0] = CH_E;
            end
            // "Motion"
            MOTION_DET: begin
                disp[3] = CH_M;
                disp[2] = CH_o;
                disp[1] = CH_t;
                disp[0] = CH_n;
            end
            // "door"
            DOOR_ALERT: begin
                disp[3] = CH_d;
                disp[2] = CH_o;
                disp[1] = CH_o;
                disp[0] = CH_r;
            end
            // "ALrH"
            ALARM: begin
                disp[3] = CH_A;
                disp[2] = CH_L;
                disp[1] = CH_r;
                disp[0] = CH_H;
            end
            default: begin
                disp[3] = CH_I;
                disp[2] = CH_d;
                disp[1] = CH_L;
                disp[0] = CH_E;
            end
        endcase
    end

    // Mux: select active digit and drive anode + segments
    always @(*) begin
        case (digit_sel)
            2'b00: begin an = 4'b1110; seg = ~disp[0]; end // rightmost
            2'b01: begin an = 4'b1101; seg = ~disp[1]; end
            2'b10: begin an = 4'b1011; seg = ~disp[2]; end
            2'b11: begin an = 4'b0111; seg = ~disp[3]; end // leftmost
            default: begin an = 4'b1111; seg = 7'b1111111; end
        endcase
    end
endmodule