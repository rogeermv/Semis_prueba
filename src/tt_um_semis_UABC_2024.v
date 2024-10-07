/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_semis_UABC_2024 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    
    wire Vip, Vin, Out;

    assign Vip = ui_in[0];
    assign Vin = ui_in[1];
    
    assign uo_out[0]  = Out;  
    assign uo_out[7:1] = 7'b0000000; 

    wire INn, INp, CM, EN, not_EN, OP, ON; //internals nets
    not IV1(INn, Vip);
    not IV2(INn, CM);
    not IV3(INp, Vin);
    not IV4(INp, CM);
    not IV5(OP, INn);
    not IV6(ON, INp);
    not IV7(not_EN, EN);
    xor XOR1(EN, ON, OP);
    bufif1 BT1(Out, EN, OP);
    notif1 IT1(CM, not_EN, OP);

    // All output pins must be assigned. If not used, assign to 0.
    assign uio_out = 0;
    assign uio_oe  = 0;
    // List all unused inputs to prevent warnings
    wire _unused = &{ui_in[7:2],ena, clk, rst_n, uio_in};

endmodule
