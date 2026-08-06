`timescale 1ns / 1ps

module top_level_tb();
    reg clk;
    reg rst;
    reg arm;
    reg motion;
    reg door;
    reg disarm_btn;

    wire led_idle;
    wire led_motion;
    wire led_door;
    wire led_alarm;
    wire led_camera;
    wire buzzer;
    wire [6:0] seg;
    wire dp;
    wire [3:0] an;

    top_level uut (
        .clk (clk),
        .rst (rst),
        .arm (arm),
        .motion (motion),
        .door (door),
        .disarm_btn (disarm_btn),
        .led_idle (led_idle),
        .led_motion (led_motion),
        .led_door (led_door),
        .led_alarm (led_alarm),
        .led_camera (led_camera),
        .buzzer (buzzer),
        .seg (seg),
        .dp (dp),
        .an (an)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        arm = 0;
        motion = 0;
        door = 0;
        disarm_btn = 0;

        #20 rst = 0;
        #20;

        $display("T1: System disarmed, sensors active - expect IDLE");
        motion = 1; door = 1;
        #20;
        motion = 0; door = 0;
        #20;

        $display("T2: Arming system - expect IDLE");
        arm = 1;
        #20;

        $display("T3: Motion detected - expect MOTION_DET, camera ON");
        motion = 1;
        #20;
        motion = 0;
        #20;

        $display("T4: Disarm button - expect IDLE");
        disarm_btn = 1;
        #20;
        disarm_btn = 0;
        #20;

        $display("T5: Door opened - expect DOOR_ALERT");
        arm = 1;
        door = 1;
        #20;

        $display("T6: Motion while door open - expect ALARM");
        motion = 1;
        #20;
        motion = 0;
        #20;

        $display("T7: Reset from ALARM - expect IDLE");
        disarm_btn = 1;
        #20;
        disarm_btn = 0;
        door = 0;
        #20;

        $display("T8: Both sensors at once - expect direct ALARM");
        arm = 1;
        motion = 1;
        door = 1;
        #20;
        motion = 0;
        door = 0;

        $display("T9: RST button - expect IDLE");
        rst = 1;
        #20;
        rst = 0;
        #20;

        $display("All tests complete.");
        $finish;
    end
endmodule