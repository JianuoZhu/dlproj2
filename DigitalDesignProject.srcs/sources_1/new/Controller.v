`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/16 21:10:03
// Design Name: 
// Module Name: Controller
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
module Controller(
    input[7:0] inputs,
    input low_button,
    input high_button,
    input clk,
    input rst,
    input mode_switch,
    input song_switch,
    output [2:0] mode_light,
    output wire speaker,
    output reg [7:0] light,
    output reg [7:0] fin_display_segments,
    output reg [1:0]tub_sel,
    output low_light,
    output high_light,
    output zero
);      
    reg [7:0] display_segments;                 
    assign zero=1'b0;
    wire [2:0] mode;
    wire en_mode1, en_mode2, en_mode3;
    wire [3:0]  learn_note;
    reg [3:0] speaker_note, free_note;
    wire [3:0]auto_note;
    wire [7:0] light_learn;
    reg [7:0] light_free;
    wire [7:0] light_auto;
    wire [7:0] segments_learn;
    wire [7:0] segments_auto;
    wire debounced_song_switch;
    wire auto_low, auto_high;
    reg speaker_low, speaker_high;
    wire [7:0] user_display;
    Debounce debounce_song_switch(.clk(clk), .button_in(song_switch), .button_out(debounced_song_switch));
    //连接模式选择
    patterns pat(.clk(clk),.rst(rst),.mode_switch(mode_switch),.mode_light(mode_light),.en_mode1(en_mode1),.en_mode2(en_mode2),.en_mode3(en_mode3));
    Buzzer buzzer(.clk(clk), .note(speaker_note), .button_low_tone(speaker_low), .button_high_tone(speaker_high), .speaker(speaker));
    
    wire[7:0] keys [7:0];
    assign keys[0] = 8'b00000000;
    assign keys[1] = 8'b00000001; 
    assign keys[2] = 8'b00000010; 
    assign keys[3] = 8'b00000100; 
    assign keys[4] = 8'b00001000; 
    assign keys[5] = 8'b00010000; 
    assign keys[6] = 8'b00100000; 
    assign keys[7] = 8'b01000000;  
    
    integer i;
    always @(posedge clk) begin
        for(i=0;i<8;i=i+1)
        begin
            if(keys[i]==inputs)
            begin
                free_note <= i;
                light_free<=keys[i];
            end
        end
        if(mode_light==3'b001) begin
            light<=light_free;
            speaker_note<=free_note;
            display_segments <= 8'b0000_0000;
            speaker_low <= low_button;
            speaker_high <= high_button;
        end
        else if(mode_light==3'b010) begin
            light<=light_learn;
            display_segments<=segments_learn;
            speaker_note<=learn_note;
        end
        else if(mode_light==3'b100) begin
            light<=light_auto;
            display_segments<=segments_auto;
            speaker_note <= auto_note;
            speaker_low <= auto_low;
            speaker_high <= auto_high;
        end
    end
    wire finished;
    Learn learn_mode(.enable(en_mode2),.clk(clk),.rst_n(rst),.note(free_note),.music(3'b000),.max_index(7'b0001010),.light(light_learn),.low_light(low_light),.high_light(high_light),.segments(segments_learn),.finished(finished), .speaker_note(learn_note), .user_display(user_display));
    wire switch_song;
    assign switch_song = 0;
    wire tub_sel_2;
    auto_play auto_mode(.enable(en_mode3),.clk(clk),.rst(rst),.switch_song(debounced_song_switch),.seg_out(tub_sel_2),.seg_ctrl(segments_auto),.led(light_auto),.note(auto_note), .low(auto_low), .high(auto_high));
//user display
    reg [1:0] an = 2'b10;
    always @ (posedge clk) begin
        if (an == 2'b10) begin
            an <= 2'b01;
            fin_display_segments <= display_segments;
        end else begin
            an <= 2'b10;
            fin_display_segments <= user_display;
        end
    end

endmodule

module patterns(
input clk,
input rst,
input mode_switch,
output reg en_mode1,en_mode2,en_mode3,
output reg [2:0] mode_light
    );
    
    parameter MODE_1 = 2'b00, MODE_2 = 2'b01, MODE_3 = 2'b10;
    
    reg [1:0] current_mode;
    reg flag;
    wire debounced_mode_switch;
    Debounce debounce_mode_switch(.clk(clk), .button_in(mode_switch), .button_out(debounced_mode_switch));
    //assign debounced_mode_switch = mode_switch;
    always @(posedge clk , negedge rst) begin
        if (!rst) begin
            current_mode <= MODE_1;
            flag <= 1'b0;
        end else begin
            if (debounced_mode_switch && (!flag)) begin
                case (current_mode)
                    MODE_1: current_mode <= MODE_2;
                    MODE_2: current_mode <= MODE_3;
                    MODE_3: current_mode <= MODE_1;
                    default: current_mode <= MODE_1;
                endcase
                flag <= 1'b1;
            end
            if (!debounced_mode_switch) begin
                flag <= 1'b0;
            end
        end
    end
    

    always @(*) begin
        case (current_mode)
            MODE_1: 
                begin
                mode_light<=3'b001;
                en_mode1=1'b1;
                en_mode2=1'b0;
                en_mode3=1'b0;
                end
            MODE_2:
                begin
                 mode_light<=3'b010;
                 en_mode1=1'b0;
                 en_mode2=1'b1;
                 en_mode3=1'b0;
                 end
            MODE_3: 
                begin
                mode_light<=3'b100;
                en_mode1=1'b0;
                en_mode2=1'b0;
                en_mode3=1'b1;
                end
        endcase
    end
endmodule
