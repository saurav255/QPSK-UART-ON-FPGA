`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.04.2025 09:16:24
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top( input clk, rst, rx1, rx2, output [3:0]an, output [6:0]seg

    );
    
    wire [15:0]RXbits1;
    wire [15:0]RXbits2;
    wire indicator1, indicator2;
    uartrx_dualport rx_inst(
.clk(clk), .rx1(rx1), .rx2(rx2), .rst(rst), .RXbits2(RXbits2), .RXbits1(RXbits1), .indicator1(indicator1), .indicator2(indicator2)
    );
    
    QPSK_DEMOD qpsk_inst(.clk(clk), .rst(rst), .i_bit(RXbits1), .q_bit(RXbits2), .uart_rx_indicator(indicator1), .seg(seg), .an(an)
);


endmodule
