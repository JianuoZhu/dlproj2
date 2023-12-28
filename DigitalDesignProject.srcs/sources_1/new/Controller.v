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
    input start_button,
    input [1:0] user_select,
    output [4:0] mode_light,
    output wire speaker,
    output reg [7:0] light,
    output reg [7:0] fin_display_segments,
    output reg [1:0]tub_sel,
    output reg low_light,
    output reg high_light
);      
    reg [7:0] display_segments; 
    reg [7:0] user_display; 
    wire [7:0] learn_user_display;
    wire [7:0] race_user_display;
    wire en_mode1, en_mode2, en_mode3, en_mode4, en_mode5;
    wire [3:0]  learn_note;
    wire [3:0] race_note;
    reg [3:0] speaker_note, free_note;
    wire [3:0]auto_note;
    wire [3:0]adjust_note;
    wire [7:0] light_learn;
    reg [7:0] light_free;
    wire [7:0] light_auto;
    wire [7:0] light_race;
    wire [7:0] light_adjust;
    wire [7:0] segments_learn;
    wire [7:0] segments_auto;
    wire [7:0] segments_race;
    wire debounced_song_switch;
    wire auto_low, auto_high;
    reg speaker_low, speaker_high;
    //按键消抖
    Debounce debounce_song_switch(.clk(clk), .button_in(song_switch), .button_out(debounced_song_switch));
    //连接模式选择
    patterns pat(.clk(clk),.rst(rst),.mode_switch(mode_switch),.mode_light(mode_light),.en_mode1(en_mode1),.en_mode2(en_mode2),.en_mode3(en_mode3), .en_mode4(en_mode4), .en_mode5(en_mode5));
    Buzzer buzzer(.clk(clk), .note(speaker_note), .button_low_tone(speaker_low), .button_high_tone(speaker_high), .speaker(speaker));
    reg r_enable, w_enable;
    reg [7:0] keys [7:0];
    reg [2:0] clk_counter = 0;
    reg [2:0] m_address = 0;
    reg [2:0] m_address_counter = 0;
    reg [7:0] m_in;
    wire [7:0] tmp_key;
    wire [2:0] adj_addr;
    wire [7:0] adj_key;
    reg prev_r_enable;
    /*generate
    genvar i;
    for (i = 0; i < 8; i = i + 1) begin : mem_gen
        memory_module memory(
            .clk(clk),
            .reset(rst),
            .addr(i[2:0]),
            .data_in(m_in),
            .data_out(keys[i]),
            .write_enable(w_enable),
            .read_enable(r_enable)
        );
    end
    endgenerate*/
    integer _i;
    //连接RAM，实现换按键功能
    memory_module memory(
            .clk(clk),
            .reset(rst),
            .addr(m_address),
            .data_in(m_in),
            .data_out(tmp_key),
            .write_enable(w_enable),
            .read_enable(r_enable)
        );
    always @(posedge clk) begin
        //简易分频，读写分离
        clk_counter <= clk_counter + 1;
        if(clk_counter % 2 == 0)begin
            r_enable <= 1'b1;
            w_enable <= 1'b0;
        end
        else begin
            keys[m_address] <= tmp_key;
            r_enable <= 1'b0;
            w_enable <= 1'b1;
        end
        if (prev_r_enable) begin
            keys[m_address] <= tmp_key;
        end
        prev_r_enable <= r_enable;
        if (clk_counter % 2 == 0) begin
            m_address_counter <= m_address_counter + 1;
            m_address <= m_address_counter;
        end else begin
            m_in <= adj_key;
            m_address <= adj_addr;
        end
        //得到按键对应的音符
        for(_i=0;_i<8;_i=_i+1)
        begin
            if(keys[_i]==inputs)
            begin
                free_note <= _i;
                light_free<=keys[_i];
            end
        end
        //绑定不同模式的输出
        if(mode_light==5'b00001) begin
            light<=light_free;
            speaker_note<=free_note;
            display_segments <= 8'b0000_0000;
            speaker_low <= low_button;
            speaker_high <= high_button;
        end
        else if(mode_light==5'b00010) begin
            user_display <= learn_user_display;
            light<=light_learn;
            display_segments<=segments_learn;
            speaker_note<=learn_note;
            speaker_low <= learn_low_light;
            speaker_high <= learn_high_light;
            low_light <= low_button;
            high_light <= high_button;
        end
        else if(mode_light==5'b00100) begin
            light<=light_auto;
            display_segments<=segments_auto;
            speaker_note <= auto_note;
            speaker_low <= auto_low;
            speaker_high <= auto_high;
            low_light <= auto_low;
            high_light <= auto_high;
        end
        else if(mode_light==5'b01000)begin
            user_display <= race_user_display;
            light <= light_race;
            display_segments <= segments_race;
            speaker_note <= race_note;
            speaker_low = race_low_light;
            speaker_high = race_high_light;
            low_light <= low_button;
            high_light <= high_button;
        end
        else if(mode_light==5'b10000)begin
            light <= light_adjust;
            display_segments <= 8'b0000_0000;
            speaker_note <= adjust_note;
            speaker_low <= low_button;
            speaker_high <= high_button;
            low_light <= low_button;
            high_light <= high_button;
        end
    end
    wire finished;    
    wire switch_song;
    wire tub_sel_2;
    //连接各个模式
    Learn learn_mode(.enable(en_mode2),.clk(clk),.rst_n(rst),.note(free_note),.switch_song(debounced_song_switch),.user_select(user_select),.light(light_learn),.low_light(learn_low_light),.high_light(learn_high_light),.segments(segments_learn),.finished(finished), .speaker_note(learn_note), .user_display(learn_user_display));
    auto_play auto_mode(.enable(en_mode3),.clk(clk),.rst(rst),.switch_song(debounced_song_switch), .start(start_button), .speedup(inputs[7]),.seg_out(tub_sel_2),.seg_ctrl(segments_auto),.led(light_auto),.note_out(auto_note), .low(auto_low), .high(auto_high));
    Race_Mode race_mode(.enable(en_mode4),.clk(clk),.rst_n(rst),.note(free_note),.switch_song(debounced_song_switch),.user_select(user_select),.light(light_race),.low_light(race_low_light),.high_light(race_high_light),.segments(segments_race),.finished(0), .speaker_note(race_note), .user_display(race_user_display));
    Adjust_Mode adjust_mode(.enable(en_mode5),.clk(clk),.rst_n(rst),.inputs(inputs), .light(light_adjust), .note(adjust_note), .adj_addr(adj_addr), .adj_key(adj_key));
//user display
    reg [17:0] clk_divider = 0;
    wire slow_clk = clk_divider[17];
    //慢时钟用来显示评级和用户
    always @(posedge clk) begin
        clk_divider <= clk_divider + 1;
    end
    always @ (posedge slow_clk) begin
        if (tub_sel == 2'b10) begin
            tub_sel <= 2'b01;
            fin_display_segments <= display_segments;
        end else begin
            tub_sel <= 2'b10;
            if(mode_light == 5'b00010 || mode_light == 5'b01000)fin_display_segments <= learn_user_display;
            else fin_display_segments <= 8'b0000_0000;
        end
    end

endmodule

module patterns(
input clk,
input rst,
input mode_switch,
output reg en_mode1,en_mode2,en_mode3, en_mode4, en_mode5,
output reg [4:0] mode_light
    );
    
    parameter MODE_1 = 3'b000, MODE_2 = 3'b001, MODE_3 = 3'b010, MODE_4 = 3'b011, MODE_5 = 3'b100;
    
    reg [2:0] current_mode;
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
                    MODE_3: current_mode <= MODE_4;
                    MODE_4: current_mode <= MODE_5;
                    MODE_5: current_mode <= MODE_1;
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
                mode_light<=5'b00001;
                en_mode1=1'b1;
                en_mode2=1'b0;
                en_mode3=1'b0;
                en_mode4=1'b0;
                en_mode5=1'b0;
                end
            MODE_2:
                begin
                mode_light<=5'b00010;
                en_mode1=1'b0;
                en_mode2=1'b1;
                en_mode3=1'b0;
                en_mode4=1'b0;
                en_mode5=1'b0;
                 end
            MODE_3: 
                begin
                mode_light<=5'b00100;
                en_mode1=1'b0;
                en_mode2=1'b0;
                en_mode3=1'b1;
                en_mode4=1'b0;
                en_mode5=1'b0;
                end
            MODE_4:
                begin
                mode_light<=5'b01000;
                en_mode1=1'b0;
                en_mode2=1'b0;
                en_mode3=1'b0;
                en_mode4=1'b1;
                en_mode5=1'b0;
                end
            MODE_5:
                begin
                mode_light<=5'b10000;
                en_mode1=1'b0;
                en_mode2=1'b0;
                en_mode3=1'b0;
                en_mode4=1'b0;
                en_mode5=1'b1;
                end
        endcase
    end
endmodule
