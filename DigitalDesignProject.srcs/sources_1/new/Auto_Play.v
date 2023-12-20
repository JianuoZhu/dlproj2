module auto_play(
    input clk,
    input enable,
    input rst,
    input switch_song,
    output seg_out,
    output reg [7:0] seg_ctrl,
    output reg [7:0] led,
    output [3:0] note,
    output low,
    output high
//    output speaker
    );
    reg [2:0] music = 3'b000;
    reg [7:0] index = 8'b00000000;
    wire debounced_switch_song;
    Debounce debounce_switch_song(.clk(clk), .button_in(switch_song), .button_out(debounced_switch_song));
    lib lib1(.music(music),.index(index),.note(note), .low(low), .high(high));
//    buzzer buz1(.clk(clk),.note(note),.button_low_tone(low),.button_high_tone(high),.speaker(speaker));
    parameter TIME = 50000000;//单个音符长短,或许存在lib输出
    reg [31:0] cnt;
    reg flag = 1'b0;
    always @(posedge clk, negedge rst) begin
        if(!rst) begin
            music <= 3'b000;
            index <= 8'b00000000;
            flag <= 1'b0;
            cnt <= 32'd0;
        end
        else if(enable) begin
            case(note)
                4'b0000: led <= 8'b00000000;
                4'b0001: led <= 8'b00000001;
                4'b0010: led <= 8'b00000010;
                4'b0011: led <= 8'b00000100;
                4'b0100: led <= 8'b00001000;
                4'b0101: led <= 8'b00010000;
                4'b0110: led <= 8'b00100000;
                4'b0111: led <= 8'b01000000;
                default: led <= 8'b00000000;
            endcase
            if (debounced_switch_song && (!flag)) begin
                index <= 8'b00000000;
                case(music)
                    3'b000: music <= 3'b001;
                    3'b001: music <= 3'b000;
                endcase
                flag <= 1'b1;
            end
            else if (!debounced_switch_song) begin
                flag <= 1'b0;
            end
            if(cnt < TIME) begin
                cnt = cnt + 1;
            end
            else begin
                cnt = 32'd0;
                if(index == 8'b11111111)begin
                    index <= 8'b00000000; 
                end
                else begin
                    index <= index + 1'b1; 
                end
            end        
        end
    end
    
    assign seg_out = 1'b1;
    always @(music) begin
        case(music)
            3'b000:
                seg_ctrl <= 8'b01100000;
            3'b001:
                seg_ctrl <= 8'b11011010;
            default:
                seg_ctrl <= 8'b00000000;
        endcase
        //显示曲目？多个seg显示名字？
    end
endmodule