module auto_play(
    input clk,
    input enable,
    input rst,
    input switch_song,
    input start,
    input speedup,
    output seg_out,
    output reg [7:0] seg_ctrl,
    output reg [7:0] led,
    output reg [3:0] note_out,
    output low,
    output high
    );

    `include "parameter.v"
    reg [2:0] music = song1;
    reg [7:0] index = index0;
    wire [3:0] note_lib;
    wire debounced_switch_song;
    wire debounced_start;
    wire gap;
    Debounce debounce_start(.clk(clk), .button_in(start), .button_out(debounced_start));
    Debounce debounce_switch_song(.clk(clk), .button_in(switch_song), .button_out(debounced_switch_song));
    lib lib1(.music(music),.index(index),.note(note_lib), .low(low), .high(high),.gap(gap));
//    buzzer buz1(.clk(clk),.note(note),.button_low_tone(low),.button_high_tone(high),.speaker(speaker));
    
    reg [31:0] cnt;
    reg [31:0] cnt2;
    reg flag = set0;
    reg flag2 = set0;
    reg play = set0;
    reg [31:0] Time;
    reg [31:0] Gap;
    
    always @(posedge clk, negedge rst) begin
        if(!rst) begin
            music <= song1;
            index <= index0;
            flag <= set0;
            flag2 <= set0;
            cnt <= cnt0;
            cnt2 <= cnt0;
            play <= set0;
        end
        else if(enable) begin
            case(note_out)
                stop: led <= lstop;
                do: led <= ldo;
                re: led <= lre;
                mi: led <= lmi;
                fa: led <= lfa;
                so: led <= lsi;
                la: led <= lla;
                si: led <= lsi;
                default: led <= lstop;
            endcase
            if(speedup) begin
                Time <= TIME>>1;
                Gap <= GAP>>1;
            end
            else begin
                Time <= TIME;
                Gap <= GAP;
            end
            if (debounced_switch_song && (!flag)) begin
                index <= index0;
                play <= set0;
                case(music)
                    song1: music <= song2;
                    song2: music <= song3;
                    song3: music <= song1;
                endcase
                flag <= set1;
            end
            else if (!debounced_switch_song) begin
                flag <= set0;
            end
            if (debounced_start && (!flag2)) begin
                play <= set1;
                index <= index0;
                cnt <= cnt0;
                cnt2 <= cnt0;
                flag2 <= set1;
            end
            else if (!debounced_start) begin
                flag2 <= set0;
            end
            if(play) begin
                if(cnt < Time) begin
                    cnt <= cnt + set1;
                end
                else begin
                    if(gap & cnt2 < Gap) begin
                        cnt2 <= cnt2 + set1;
                    end
                    else begin
                        cnt <= cnt0;
                        cnt2 <= cnt0;
                        if(index == indexfull)begin
                            play <= set0;
                            index <= index0; 
                        end
                        else begin
                            index <= index + set1; 
                        end
                    end
                end
            end
        end
    end
    
    assign seg_out = set1;
    always @(posedge clk)begin
        if(play && (cnt2 == cnt0))begin
            note_out <= note_lib;
        end
        else begin
            note_out <= stop;
        end
    end
    always @(music) begin
        case(music)
            song1:
                seg_ctrl <= seg1;
            song2:
                seg_ctrl <= seg2;
            song3:
                seg_ctrl <= seg3;
            default:
                seg_ctrl <= segnull;
        endcase
    end
endmodule