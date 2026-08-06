## ============================================================
## Smart Home Surveillance Controller
## Board  : Nexys A7-100T (xc7a100tcsg324-1)
## File   : nexys_a7.xdc
## ============================================================

## ── Clock ────────────────────────────────────────────────────
set_property PACKAGE_PIN E3        [get_ports clk]
set_property IOSTANDARD  LVCMOS33  [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## ── Reset (BTNC — centre button) ─────────────────────────────
set_property PACKAGE_PIN N17       [get_ports rst]
set_property IOSTANDARD  LVCMOS33  [get_ports rst]

## ── Disarm button (BTNL — left button) ───────────────────────
set_property PACKAGE_PIN P17       [get_ports disarm_btn]
set_property IOSTANDARD  LVCMOS33  [get_ports disarm_btn]

## ── Switches ─────────────────────────────────────────────────
## SW0 — arm
set_property PACKAGE_PIN J15       [get_ports arm]
set_property IOSTANDARD  LVCMOS33  [get_ports arm]

## SW1 — motion sensor
set_property PACKAGE_PIN L16       [get_ports motion]
set_property IOSTANDARD  LVCMOS33  [get_ports motion]

## SW2 — door sensor
set_property PACKAGE_PIN M13       [get_ports door]
set_property IOSTANDARD  LVCMOS33  [get_ports door]

## ── LEDs ─────────────────────────────────────────────────────
## LD0 — idle (green)
set_property PACKAGE_PIN H17       [get_ports led_idle]
set_property IOSTANDARD  LVCMOS33  [get_ports led_idle]

## LD1 — motion detected (blue)
set_property PACKAGE_PIN K15       [get_ports led_motion]
set_property IOSTANDARD  LVCMOS33  [get_ports led_motion]

## LD2 — door alert (amber)
set_property PACKAGE_PIN J13       [get_ports led_door]
set_property IOSTANDARD  LVCMOS33  [get_ports led_door]

## LD3 — alarm blinking (red)
set_property PACKAGE_PIN N14       [get_ports led_alarm]
set_property IOSTANDARD  LVCMOS33  [get_ports led_alarm]

## LD4 — camera active
set_property PACKAGE_PIN R18       [get_ports led_camera]
set_property IOSTANDARD  LVCMOS33  [get_ports led_camera]

## ── Buzzer (Pmod JA — pin 1) ─────────────────────────────────
set_property PACKAGE_PIN C17       [get_ports buzzer]
set_property IOSTANDARD  LVCMOS33  [get_ports buzzer]

## ── 7-Segment Display — Segments (active-LOW) ────────────────
## seg[6]=a  seg[5]=b  seg[4]=c  seg[3]=d
## seg[2]=e  seg[1]=f  seg[0]=g
set_property PACKAGE_PIN T10       [get_ports {seg[6]}]
set_property IOSTANDARD  LVCMOS33  [get_ports {seg[6]}]

set_property PACKAGE_PIN R10       [get_ports {seg[5]}]
set_property IOSTANDARD  LVCMOS33  [get_ports {seg[5]}]

set_property PACKAGE_PIN K16       [get_ports {seg[4]}]
set_property IOSTANDARD  LVCMOS33  [get_ports {seg[4]}]

set_property PACKAGE_PIN K13       [get_ports {seg[3]}]
set_property IOSTANDARD  LVCMOS33  [get_ports {seg[3]}]

set_property PACKAGE_PIN P15       [get_ports {seg[2]}]
set_property IOSTANDARD  LVCMOS33  [get_ports {seg[2]}]

set_property PACKAGE_PIN T11       [get_ports {seg[1]}]
set_property IOSTANDARD  LVCMOS33  [get_ports {seg[1]}]

set_property PACKAGE_PIN L18       [get_ports {seg[0]}]
set_property IOSTANDARD  LVCMOS33  [get_ports {seg[0]}]

## ── 7-Segment Display — Decimal Point ────────────────────────
set_property PACKAGE_PIN H15       [get_ports dp]
set_property IOSTANDARD  LVCMOS33  [get_ports dp]

## ── 7-Segment Display — Anodes (active-LOW) ──────────────────
## an[3]=leftmost digit   an[0]=rightmost digit
set_property PACKAGE_PIN J17       [get_ports {an[0]}]
set_property IOSTANDARD  LVCMOS33  [get_ports {an[0]}]

set_property PACKAGE_PIN J18       [get_ports {an[1]}]
set_property IOSTANDARD  LVCMOS33  [get_ports {an[1]}]

set_property PACKAGE_PIN T9        [get_ports {an[2]}]
set_property IOSTANDARD  LVCMOS33  [get_ports {an[2]}]

set_property PACKAGE_PIN J14       [get_ports {an[3]}]
set_property IOSTANDARD  LVCMOS33  [get_ports {an[3]}]

## ── Configuration ─────────────────────────────────────────────
set_property CONFIG_VOLTAGE        3.3 [current_design]
set_property CFGBVS                VCCO [current_design]
