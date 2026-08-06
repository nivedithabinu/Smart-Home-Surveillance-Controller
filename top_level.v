`timescale 1ns / 1ps
module top_level (
    input  wire clk,          // 100 MHz onboard clock  (E3)
    input  wire rst,          // BTNC - async reset      (N17)
    input  wire arm,          // SW0  - arm system       (J15)
    input  wire motion,       // SW1  - motion sensor    (L16)
    input  wire door,         // SW2  - door sensor      (M13)
    input  wire disarm_btn,   // BTNL - disarm/reset     (P17)

    // Status LEDs
    output wire led_idle,     // LD0  (H17)
    output wire led_motion,   // LD1  (K15)
    output wire led_door,     // LD2  (J13)
    output wire led_alarm,    // LD3  (N14)
    output wire led_camera,   // LD4  (R18)

    output wire buzzer,       // JA1  (C17)

    // 7-Segment display
    output wire [6:0] seg,
    output wire dp,
    output wire [3:0] an
);

    wire [1:0] state;
    wire clk_1hz;
    wire clk_1khz;

    clk_divider u_clk_div (
        .clk_100mhz (clk),
        .rst (rst),
        .clk_1hz (clk_1hz),
        .clk_1khz (clk_1khz)
    );

    fsm u_fsm (
        .clk (clk),
        .rst (rst),
        .arm (arm),
        .motion (motion),
        .door (door),
        .disarm_btn (disarm_btn),
        .state (state)
    );

    led_controller u_led (
        .clk_1hz (clk_1hz),
        .state (state),
        .led_idle (led_idle),
        .led_motion (led_motion),
        .led_door (led_door),
        .led_alarm (led_alarm),
        .led_camera (led_camera),
        .buzzer (buzzer)
    );

    seg7_controller u_seg7 (
        .clk_1khz (clk_1khz),
        .rst (rst),
        .state (state),
        .seg (seg),
        .dp (dp),
        .an (an)
    );
endmodule