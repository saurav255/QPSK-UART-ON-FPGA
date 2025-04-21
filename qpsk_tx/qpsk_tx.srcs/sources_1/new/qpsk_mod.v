`timescale 1ns / 1ps
module qpsk_mod (
    input  wire        clk,
    input  wire        rst,
    input  wire [11:0]  data_in, 
    input button_in, 
    input uart_tx_ready,

    output reg signed [15:0] i_bit,  // I component (Even bits)
    output reg signed [15:0] q_bit,  // Q component (Odd bits)
    output reg trig
);
reg [3:0]i;

reg last_button_state;
reg debounced_button;
always@(posedge clk) begin
    if(rst) begin
        last_button_state <= 0;
    end else begin
        if(button_in & ~last_button_state) begin
            debounced_button <= 1'b1;
        end
        else begin
            debounced_button <= 1'b0;
        end
        last_button_state <= button_in;
    end
end


reg state;
localparam IDLE = 1'b0, TX = 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            i <= 0;
            trig<=1'b0;
            i_bit <= 16'sd0;
            q_bit <= 16'sd0;
            state<=IDLE;
        end else begin
            case(state)
            IDLE : begin
                i<=0;
                trig<=1'b0;
                if(debounced_button) begin
                    state<=TX;
                end 
                else begin
                    state<=IDLE;
                end
            end
            TX : begin
                if (i == 0) begin
                    trig<=1'b1;
                    i_bit <= (data_in[i]) ? 16'sd1 : -16'sd1;
                    q_bit <= (data_in[i+1]) ? 16'sd1 : -16'sd1;
                    i = i+2;
                    state<=TX;
                end else if(i<11 & uart_tx_ready) begin
                    trig<=1'b1;
                    i_bit <= (data_in[i]) ? 16'sd1 : -16'sd1;
                    q_bit <= (data_in[i+1]) ? 16'sd1 : -16'sd1; 
                    i = i+2;
                    state<=TX;
                end
                else if (i<11 & (~uart_tx_ready)) begin
                    trig<=1'b0;
                end 
                else if(i>11) begin
                    trig<=1'b0;
                    state<=IDLE;
                end          
            end
            default : begin
                state<=IDLE;
                i<=0;
                trig<=1'b0;
            end
            endcase
        end
    end

endmodule
