module Uart_transmitter( input trig, input [15:0]txbits1, input [15:0]txbits2, input clk, output reg tx1, tx2, output reg done

    );
    parameter clk_speed = 100000000, baud_rate = 115200;
    parameter clk_cycles = clk_speed/baud_rate; // 863 in this case
    parameter Idle = 3'b000, Start = 3'b001, Data_bits = 3'b010, Stop = 3'b011, Cleanup = 3'b100;
    reg active;
    reg [2:0]state;
    reg [9:0]ctr; // needs to count untill 863 atleast
    reg [15:0]txbits1_reg; 
    reg [15:0]txbits2_reg;
    reg [3:0]bitctr;
    
    
    
    //uart state machine
    always@(posedge clk) begin
        case(state)
        Idle: begin
            ctr<=0;
            tx1<=1'b1;
            tx2<=1'b1;
            done<=1'b0;
            if(trig==1'b1) begin
                active<=1'b1;
                state<=Start;
                txbits1_reg<=txbits1;
                txbits2_reg<=txbits2;
            end
        end
        Start: begin
            tx1<=1'b0;
            tx2<=1'b0;
            //count 1 perioed and keep the signal low for that time
            if(ctr<clk_cycles) begin
                ctr<=ctr+1;
                state<=Start;
            end
            else begin
            ctr<=0;
            state<=Data_bits;
            end
        end
        Data_bits: begin
            tx1<=txbits1_reg[bitctr];
            tx2<=txbits2_reg[bitctr];
            //count for 1 perioed and then go to the next bit
            if(ctr<clk_cycles) begin
                ctr<=ctr+1;
                state<=Data_bits;
            end
            else begin
            ctr<=0;
            if(bitctr<15) begin
            bitctr<=bitctr+1;
            state<=Data_bits;
            end
            else begin
            ctr<=0;
            state<=Stop;
            end
            end
        end
        Stop: begin
        tx1<=1'b1;
        tx2<=1'b1;
        if(ctr<clk_cycles) begin
            ctr<=ctr+1;
            bitctr<=0;
            state<=Stop;
        end
        else begin
        ctr<=0;
        state<=Cleanup;
        active<=1'b0;
        done<=1'b0;
        end
        end
        Cleanup: begin
            done<=1'b1;
            state<=Idle;
        end
        default: state<=Idle;
    endcase
    end
    
endmodule
