`timescale 1ns / 1ps

module fsm (
    input  wire clk,
    input  wire rst,
    input  wire arm,          // SW0: system armed when HIGH
    input  wire motion,       // SW1: motion sensor
    input  wire door,         // SW2: door sensor
    input  wire disarm_btn,   // BTNL: force return to IDLE
    output reg [1:0] state    // current state output
);

    localparam IDLE        = 2'b00;
    localparam MOTION_DET  = 2'b01;
    localparam DOOR_ALERT  = 2'b10;
    localparam ALARM       = 2'b11;

    reg [1:0] next_state;
    
    // Block 1 - Sequential: state register (clocked)
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Block 2 - Combinational: next-state logic
    always @(*) begin
        next_state = state;

        // disarm_btn overrides everything → IDLE
        if (disarm_btn) begin
            next_state = IDLE;
        end 
        else begin
            case (state)
                IDLE: begin
                    if (!arm) begin
                        next_state = IDLE;
                    end 
                    else if (motion && door) begin
                        next_state = ALARM;
                    end 
                    else if (motion && !door) begin
                        next_state = MOTION_DET;
                    end 
                    else if (door && !motion) begin
                        next_state = DOOR_ALERT;
                    end
                end

                MOTION_DET: begin
                    if (door) begin
                        next_state = ALARM;
                    end 
                    else if (!motion) begin
                        next_state = IDLE;
                    end
                end

                DOOR_ALERT: begin
                    if (motion) begin
                        // Motion detected while door open → ALARM
                        next_state = ALARM;
                    end 
                    else if (!door) begin
                        // Door closed again → back to IDLE
                        next_state = IDLE;
                    end
                end

                ALARM: begin
                    next_state = ALARM;
                end

                default: next_state = IDLE;
            endcase
        end
    end
endmodule