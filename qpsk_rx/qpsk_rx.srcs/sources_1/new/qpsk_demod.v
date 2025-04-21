module QPSK_DEMOD ( 
    input wire         clk,
    input wire         rst,
    input wire signed [15:0] i_bit,  // I component from modulator
    input wire signed [15:0] q_bit,  // Q component from modulator
    input uart_rx_indicator,
    
    output reg [6:0]seg, output reg [3:0]an
);

reg [3:0] index; // Index to track bit position (0 to 98 in steps of 2)


reg [11:0]data_out;
    always @(posedge clk) begin
    if (rst) begin
        index <= 4'b0;
        data_out <= 12'b0;
    end else begin
        if(uart_rx_indicator & (index < 11)) begin
            // Assign I and Q bits to the current and next position
            data_out[index]   <= (i_bit >= 16'sd0) ? 1'b1 : 1'b0;
            data_out[index+1] <= (q_bit >= 16'sd0) ? 1'b1 : 1'b0;
            index <= index + 2;
        end else if (index >= 11) begin
            index <= 0;
          end
        end
    end
    
    
    //-----------------------------------------------------------------------------------
        // DISPLAYING THE DATA BITS IN 7 SEGMENT DISPLAY
//-----------------------------------------------------------------------------------
//Generating a seven segment display refresh signal, we choose 60Hz
//This means we refresh 60 times every second, time perioed between refreshes  = 16.6 ms
//
reg [19:0] refresh_counter;
wire [1:0] activating_ctr;
always@(posedge clk or posedge rst) begin

if(rst==1)
refresh_counter<=1;
else 
refresh_counter<=refresh_counter+1;
end
assign activating_ctr = refresh_counter[19:18];
//-----------------------------------------------------
//Creating anode signals and updating values of 7 segment display
// data is a 16 bit number every 4 bit will be displayed on different 7 segs 

//flip flop for registering last transferred data over uart
reg [3:0]single_disp;

always @(*) begin
case (activating_ctr)
    2'b00:begin
     an = 4'b0111;
     single_disp = data_out/1000;
     end
    2'b01: begin
    an = 4'b1011;
    single_disp =(data_out % 1000)/100;
     end
    2'b10: begin
    an = 4'b1101;
    single_disp = ((data_out % 1000)%100)/10;
     end
    2'b11: begin
     an = 4'b1110;
     single_disp = ((data_out % 1000)%100)%10;
     end
//    default: begin 
//    an = 4'b0111;
//    single_disp = num_display[15:12];
//     end
    endcase
end
//-------Cathode pattern for 7 segment display---------
always@(*) begin
case(single_disp)
        4'b0000: seg = 7'b1000000; // "0"     
        4'b0001: seg = 7'b1111001; // "1" 
        4'b0010: seg = 7'b0100100; // "2" 
        4'b0011: seg = 7'b0110000; // "3" 
        4'b0100: seg = 7'b0011001; // "4" 
        4'b0101: seg = 7'b0010010; // "5" 
        4'b0110: seg = 7'b0000010; // "6" 
        4'b0111: seg = 7'b1111000; // "7" 
        4'b1000: seg = 7'b0000000; // "8"     
        4'b1001: seg = 7'b0010000; // "9" 
        default: seg = 7'b1000000; // "0"
        endcase
end

//----------------------------------------------------------------

endmodule