`timescale 1ns / 1ps

module led_controller (
    input  wire clk_1hz,     // 1 Hz clock for alarm blink
    input  wire [1:0] state,       // FSM state

    output reg led_idle,    // LD0
    output reg led_motion,  // LD1
    output reg led_door,    // LD2
    output reg led_alarm,   // LD3 (blinks in ALARM)
    output reg led_camera,  // LD4
    output reg buzzer       // Pmod JA1
);

    localparam IDLE        = 2'b00;
    localparam MOTION_DET  = 2'b01;
    localparam DOOR_ALERT  = 2'b10;
    localparam ALARM       = 2'b11;

    always @(*) begin
        // Defaults - everything off
        led_idle   = 1'b0;
        led_motion = 1'b0;
        led_door   = 1'b0;
        led_alarm  = 1'b0;
        led_camera = 1'b0;
        buzzer     = 1'b0;

        case (state)
            IDLE: begin
                led_idle = 1'b1;
            end

            MOTION_DET: begin
                led_motion = 1'b1;
                led_camera = 1'b1;   // camera indicator ON
            end

            DOOR_ALERT: begin
                led_door = 1'b1;
            end

            ALARM: begin
                led_alarm  = clk_1hz; // blink at 1 Hz using divided clock
                led_camera = 1'b1;    // camera stays on during alarm
                buzzer     = 1'b1;    // continuous buzzer
            end

            default: begin
                led_idle = 1'b1;
            end
        endcase
    end
endmodule