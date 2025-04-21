`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.04.2025 13:54:22
// Design Name: 
// Module Name: source
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


module source(
input clk, rst, trig, output reg [11:0]data_o
    );
    reg [11:0]data;
    always@(posedge clk) begin
        if(rst) begin
            data_o <=0;
            data <= 12'b101011001110;
        end
        else begin
            if(trig) begin
                data_o <= data;
                data <= {(data[0]^data[1]),data[10:0]};
            end
        end
    end
endmodule
