`timescale 1ns / 1ps

module clk_divider (
    input  wire clk_100mhz,
    input  wire rst,
    output reg  clk_1hz,
    output reg  clk_1khz
);

    reg [25:0] cnt_1hz;

    always @(posedge clk_100mhz or posedge rst) begin
        if (rst) begin
            cnt_1hz <= 0;
            clk_1hz <= 0;
        end else if (cnt_1hz == 26'd49_999_999) begin
            cnt_1hz <= 0;
            clk_1hz <= ~clk_1hz;
        end else begin
            cnt_1hz <= cnt_1hz + 1;
        end
    end

    reg [16:0] cnt_1khz;

    always @(posedge clk_100mhz or posedge rst) begin
        if (rst) begin
            cnt_1khz <= 0;
            clk_1khz <= 0;
        end else if (cnt_1khz == 17'd49_999) begin
            cnt_1khz <= 0;
            clk_1khz <= ~clk_1khz;
        end else begin
            cnt_1khz <= cnt_1khz + 1;
        end
    end
endmodule