# 🏠 Smart Home Surveillance Controller using Verilog HDL on Nexys A7 FPGA

A hardware-based smart home surveillance system implemented in **Verilog HDL** on the **Nexys A7 FPGA**. The project uses a **Finite State Machine (FSM)** to monitor motion and door sensor inputs, detect intrusion scenarios, and provide real-time visual and audio alerts through LEDs, a buzzer, and a seven-segment display.

The system follows a modular hardware design consisting of dedicated modules for clock division, state management, LED control, and seven-segment display control. The design was verified through behavioral simulation in **Vivado** and successfully implemented on the **Nexys A7 FPGA board**, demonstrating reliable operation under multiple security scenarios.

## ✨ Features

1. 🔄 Four-state Finite State Machine (FSM) based surveillance controller
2. Motion detection and 🚪 door intrusion monitoring
3. 🚨 Automatic alarm escalation for intrusion scenarios
4. 🔴 Real-time LED status indicators
5. 📟 Seven-segment display for system state visualization
6. 🔊 Buzzer output for alarm indication
7. ⏱️ Clock divider for 1 Hz alarm blinking and 1 kHz display multiplexing
8. 🧩 Modular Verilog HDL design for easy maintenance and scalability
9. ✅ Behavioral simulation and FPGA hardware validation

## 🛠️ Hardware & Software

### Hardware
1. Nexys A7 FPGA Board (Artix-7 XC7A100T)
2. On-board LEDs
3. Push Buttons
4. Slide Switches
5. Four-Digit Seven Segment Display
6. Pmod Buzzer

### Software
1. Verilog HDL
2. Xilinx Vivado Design Suite 2025.1
