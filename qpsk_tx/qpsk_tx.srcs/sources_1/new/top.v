`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2025 14:45:47
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


module top( input clk, rst, button, input [11:0]sw, output tx1, tx2 

    );
    wire uart_tx_ready;
    wire [15:0]txbits1;
    wire [15:0]txbits2; 
    wire trig_qpsk_mod;
    
    qpsk_mod mod_inst(
    .clk(clk), .rst(rst), .data_in(sw), .button_in(button), .uart_tx_ready(uart_tx_ready), .i_bit(txbits1), .q_bit(txbits2), .trig(trig_qpsk_mod)
);
    
    Uart_transmitter tx_inst( .trig(trig_qpsk_mod), .txbits1(txbits1), .txbits2(txbits2), .clk(clk), .tx1(tx1), .tx2(tx2), .done(uart_tx_ready));
    
    
endmodule
