module Learn(
    input enable,
    input clk,
    input rst_n,
    input [3:0]note,
    input switch_song,
    input [1:0] user_select,
    output reg [7:0] light,
    output low_light,
    output high_light,
    output reg [7:0] segments,
    output reg finished,
    output reg [3:0] speaker_note,
    output reg [7:0] user_display
);
    `include "parameter.v"
    parameter A_segment = 8'b11101110, B_segment = 8'b00111110, C_segment = 8'b10011100, D_segment = 8'b01111010, E_segment = 8'b10011110;
    wire [7:0] max_index[1:0];
    assign max_index[0] = 8'b0010_1111;
    assign max_index[1] = 8'b0010_0011;
    assign max_index[2] = 8'b0001_1111;
    wire[7:0] keys [7:0];
    assign keys[0] = 8'b00000000;
    assign keys[1] = 8'b00000001; 
    assign keys[2] = 8'b00000010; 
    assign keys[3] = 8'b00000100; 
    assign keys[4] = 8'b00001000; 
    assign keys[5] = 8'b00010000; 
    assign keys[6] = 8'b00100000; 
    assign keys[7] = 8'b01000000;
    reg [2:0] music;  
    parameter WAITING = 2'b00, PLAYING = 2'b01, FINISHED = 2'b10, zeros = 7'b0000_000, a_sec = 100000000;
    reg [1:0] current_state;
    reg [7:0] index;
    wire [3:0] supposed_note;
    reg [31:0] time_counter;
    lib slib(.music(music), .index(index), .note(supposed_note), .low(low_light), .high(high_light));
    reg press_flag;
    reg [7:0] wrong_counter;
    reg [1:0] former_user_select;
    reg switch_flag;
    wire debounced_switch_song;
    Debounce debounce_switch_song(.clk(clk), .button_in(switch_song), .button_out(debounced_switch_song));
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)begin
            former_user_select <= user_select;
            finished <= 1'b0;
            segments <= 8'b0000_0000;
            press_flag <= 1'b0;
            wrong_counter <= 0;
            current_state <= WAITING;
            index <= 8'b0000_0000;
            time_counter <= 0;
            user_display <= 8'b0000_0000;
            switch_flag <= 1'b0;
            music <= song1;
        end
        else if(enable)begin
            case(user_select)
                2'b00: user_display <= A_segment;
                2'b01: user_display <= B_segment;
                2'b10: user_display <= C_segment;
                2'b11: user_display <= D_segment;
            endcase
            case (current_state)
                    WAITING: begin
                    if(former_user_select != user_select)begin
                        former_user_select <= user_select;
                        user_display <= 8'b0000_0000;
                        finished <= 1'b0;
                        segments <= 8'b0000_0000;
                        press_flag <= 1'b0;
                        wrong_counter <= 0;
                        current_state <= WAITING;
                        index <= 8'b0000_0000;
                        time_counter <= 0;
                        former_user_select <= user_select;
                    end
                    else if(note > 0 && note != supposed_note && !press_flag) begin
                        press_flag <= 1'b1;
                        wrong_counter <= wrong_counter + 1;
                        current_state <= WAITING;
                        light <= keys[supposed_note];
                    end
                    else if (debounced_switch_song && (!switch_flag)) begin
                        index <= index0;
                        case(music)
                            song1: music <= song2;
                            song2: music <= song3;
                            song3: music <= song1;
                        endcase
                        switch_flag <= set1;
                    end
                    else if(note == 0) begin
                        press_flag <= 1'b0;
                        current_state <= WAITING;
                        light <= keys[supposed_note];
                    end
                    else if (note == supposed_note) begin
                        current_state <= PLAYING;
                        time_counter <= 0;
                        light <= zeros;
                    end
                    
                    else begin
                        current_state <= WAITING;
                        light <= keys[supposed_note];
                    end
                    if (!debounced_switch_song) begin
                        switch_flag <= set0;
                    end
                end
                PLAYING: begin
                    if (time_counter < a_sec) begin
                        time_counter <= time_counter + 1;
                        speaker_note <= supposed_note;
                    end else begin
                        light <= zeros;
                        speaker_note <= 4'b0000;
                        time_counter <= 0;
                        index <= index + 1;
                        if (index < max_index[music]) begin
                            current_state <= WAITING;
                        end else begin
                            current_state <= FINISHED;
                        end
                    end
                end
                FINISHED: begin
                    if(wrong_counter < (index >> 2))begin
                        segments <= A_segment;
                    end
                    else if(wrong_counter < (index >> 1))begin
                        segments <= B_segment;
                    end
                    else if(wrong_counter < (index >>1 + (index >> 2)))begin
                        segments <= C_segment;
                    end
                    else begin
                        segments <= D_segment;
                    end
                    finished <= 1'b1;
                end
            endcase
            former_user_select <= user_select;
        end
        end
endmodule