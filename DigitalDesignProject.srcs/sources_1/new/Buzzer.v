`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/16 21:05:48
// Design Name: 
// Module Name: Buzzer
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


module Buzzer(
input wire clk , 
input wire [3:0] note,
input wire button_low_tone,
input wire button_high_tone,
output wire speaker
    );
    wire [31:0] notes1 [7:0];
    wire [31:0] notes0 [7:0];
    wire [31:0] notes2 [7:0];
    reg [31:0] counter ;
    reg pwm ;
    assign notes0 [1]=764467; 
    assign notes0 [2]=681059; 
    assign notes0 [3]=606759; 
    assign notes0 [4]=572704; 
    assign notes0 [5]=510204; 
    assign notes0 [6]=454545; 
    assign notes0 [7]=404956;
    assign notes1 [1]=381680; 
    assign notes1 [2]=340136; 
    assign notes1 [3]=303030; 
    assign notes1 [4]=285714; 
    assign notes1 [5]=255102; 
    assign notes1 [6]=227273; 
    assign notes1 [7]=202429;
    assign notes2 [1]=191113; 
    assign notes2 [2]=170262; 
    assign notes2 [3]=151685; 
    assign notes2 [4]=143172; 
    assign notes2 [5]=127552; 
    assign notes2 [6]=113636; 
    assign notes2 [7]=101238;
    wire low_button, high_button;
    Debounce debounce_low_tone(.clk(clk), .button_in(button_low_tone), .button_out(low_button));
    Debounce debounce_high_tone(.clk(clk), .button_in(button_high_tone), .button_out(high_button));
    initial 
    begin 
        pwm =0; 
    end 
    reg [31:0] notes [7:0];
    integer i;
    reg [1:0]tone;
    always @ ( posedge clk ) begin 
        tone <= {low_button, high_button};
        case( tone ) 
            2'b00:
                for (i = 0; i < 8; i = i + 1) begin
                    notes[i] <= notes1[i];
                end
            2'b10:
                for (i = 0; i < 8; i = i + 1) begin
                    notes[i] <= notes0[i];
                end
            2'b01:
                for (i = 0; i < 8; i = i + 1) begin
                    notes[i] <= notes2[i];
                end
            default:
                for (i = 0; i < 8; i = i + 1) begin
                    notes[i] <= notes1[i];
                end
        endcase
        if ( counter < notes [ note ]|| note ==1'b0 ) 
        begin 
            counter <= counter + 1'b1 ;
        end 
        else begin 
            pwm =~ pwm ;
            counter <= 0; 
        end 
    end 
    assign speaker = pwm ;

endmodule
