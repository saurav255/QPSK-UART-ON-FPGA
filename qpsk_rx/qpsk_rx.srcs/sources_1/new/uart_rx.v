module uartrx_dualport(
input clk, rx1, rx2, rst, output reg [15:0]RXbits2, output reg [15:0]RXbits1, output reg indicator1, output reg indicator2
    );
    // Setting baud rates and counters 
    parameter clk_speed = 100000000, baud_rate = 115200;
    parameter clk_cycles = clk_speed/baud_rate; // 863 in this case

    //state declarations 
    parameter idle1 = 3'b000;
    parameter start_bit1 = 3'b001;
    parameter data_bits1 = 3'b010;
    parameter stop_bit1 = 3'b011;
    parameter cleanup1 = 3'b100;
     
    parameter idle2 = 3'b000;
    parameter start_bit2 = 3'b001;
    parameter data_bits2 = 3'b010;
    parameter stop_bit2 = 3'b011;
    parameter cleanup2 = 3'b100;
    //variable declerations
    reg [2:0]state1 = 0;
    reg [9:0]clk_ctr1 = 0;
    reg [3:0]no_bits1 = 0;
    
    reg [2:0]state2 = 0;
    reg [9:0]clk_ctr2 = 0;
    reg [3:0]no_bits2 = 0;
    
//----------------- rx1 --------------------------------------
    
//State machine for rx1
    always@(posedge clk, posedge rst) begin
    if(rst==1) begin
        state1 <= idle1;
        clk_ctr1 <= 0;
        no_bits1 <= 0;
        RXbits1 <= 0;
        indicator1 <= 0;
    end
    else begin
    case(state1)
    // IDLE STATE 
    idle1: begin
        indicator1 <= 1'b0;
        clk_ctr1 <= 0;
        RXbits1 <= 0;
        if(rx1==1'b0)
        state1 <= start_bit1;
        else
        state1 <= idle1;
        end
    //START BIT STATE
    start_bit1: begin
        if(clk_ctr1 == ((clk_cycles-1)/2))
        begin 
        if(rx1==1'b0) begin
        clk_ctr1 <= 0;
        state1 <= data_bits1;
        end
        else 
        state1 <= idle1;
        end
        else begin
        clk_ctr1<=clk_ctr1+1;
        state1<=start_bit1;
        end
        end
        //DATA BITS STATE
        data_bits1: begin
        if(clk_ctr1 == clk_cycles-1) begin 
        RXbits1[no_bits1] <= rx1; 
        clk_ctr1 <= 0;
        if(no_bits1<15) begin
        no_bits1<=no_bits1+1;
        state1 <= data_bits1;
        end
        else begin
        state1 <= stop_bit1;
        no_bits1<=0;
        end
        end
        else begin 
        clk_ctr1 <= clk_ctr1+1;
        state1 <= data_bits1;
        end
        end
        //STOP BIT STATE
        stop_bit1: begin
        if(clk_ctr1 < clk_cycles-1) begin
        clk_ctr1<=clk_ctr1+1;
        state1<=stop_bit1;
        end
        else begin
        clk_ctr1<=0;
        indicator1 <= 1'b0;
        state1<=cleanup1;
        end
        end
        //CLEANUP STATE
        cleanup1: begin
        indicator1 <= 1'b1;
        state1 <= idle1;
        end
        default: state1 <= idle1; 
        endcase
        end
        end
//------------------- rx2 ----------------------------------
        
//State machine for rx2
    always@(posedge clk, posedge rst) begin
    if(rst==1) begin
        state2 <= idle2;
        clk_ctr2 <= 0;
        no_bits2 <= 0;
        RXbits2 <= 0;
        indicator2 <= 0;
    end
    else begin
    case(state2)
    // IDLE STATE 
    idle2: begin
        indicator2 <= 1'b0;
        clk_ctr2 <= 0;
        RXbits2 <= 0;
        if(rx2==1'b0)
        state2 <= start_bit2;
        else
        state2 <= idle2;
        end
    //START BIT STATE
    start_bit2: begin
        if(clk_ctr2 == ((clk_cycles-1)/2))
        begin 
        if(rx2==1'b0) begin
        clk_ctr2 <= 0;
        state2 <= data_bits2;
        end
        else 
        state2 <= idle2;
        end
        else begin
        clk_ctr2<=clk_ctr2+1;
        state2<=start_bit2;
        end
        end
        //DATA BITS STATE
        data_bits2: begin
        if(clk_ctr2 == clk_cycles-1) begin 
        RXbits2[no_bits2] <= rx2; 
        clk_ctr2 <= 0;
        if(no_bits2<15) begin
        no_bits2<=no_bits2+1;
        state2 <= data_bits2;
        end
        else begin
        state2 <= stop_bit2;
        no_bits2<=0;
        end
        end
        else begin 
        clk_ctr2 <= clk_ctr2+1;
        state2 <= data_bits2;
        end
        end
        //STOP BIT STATE
        stop_bit2: begin
        if(clk_ctr2 < clk_cycles-1) begin
        clk_ctr2<=clk_ctr2+1;
        state2<=stop_bit2;
        end
        else begin
        clk_ctr2<=0;
        indicator2 <= 1'b0;
        state2<=cleanup2;
        end
        end
        //CLEANUP STATE
        cleanup2: begin
        indicator2 <= 1'b1;
        state2 <= idle2;
        end
        default: state2 <= idle2; 
        endcase
        end
        end


endmodule