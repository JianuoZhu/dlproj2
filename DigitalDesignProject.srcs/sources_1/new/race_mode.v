module Learn(
    input enable,
    input clk,
    input rst_n,
    input [3:0]note,
    input [2:0]music,
    input [7:0]max_index,
    output reg [7:0] light,
    output low_light,
    output high_light,
    output reg [7:0] segments,
    output reg finished,
    output reg [3:0] speaker_note
);
    parameter A_segment = 8'b11101110, B_segment = 8'b00111110, C_segment = 8'b10011100, D_segment = 8'b01111010, E_segment = 8'b10011110;
    wire[7:0] keys [7:0];
    assign keys[0] = 8'b00000000;
    assign keys[1] = 8'b00000001; 
    assign keys[2] = 8'b00000010; 
    assign keys[3] = 8'b00000100; 
    assign keys[4] = 8'b00001000; 
    assign keys[5] = 8'b00010000; 
    assign keys[6] = 8'b00100000; 
    assign keys[7] = 8'b01000000;  
    parameter WAITING = 2'b00, PLAYING = 2'b01, FINISHED = 2'b10, zeros = 7'b0000_000, a_sec = 100000000;
    parameter WAIT_MAX = 200000000;
    reg [1:0] current_state;
    reg [7:0] index;
    wire [3:0] supposed_note;
    reg [31:0] time_counter;
    lib slib(.music(music), .index(index), .note(supposed_note), .low(low_light), .high(high_light));
    reg press_flag;
    reg [31:0] wrong_counter;
    reg [31:0] wait_counter;
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n)begin
            finished <= 1'b0;
            segments <= 8'b0000_0000;
            press_flag <= 1'b0;
            wrong_counter <= 0;
            current_state <= WAITING;
            index <= 8'b0000_0000;
            time_counter <= 0;
        end
        else if(enable)begin
            case (current_state)
                WAITING: begin
                    if (note == supposed_note) begin
                        current_state <= PLAYING;
                        light <= zeros;
                        wrong_counter <= wrong_counter + wait_counter;
                        wait_counter <= 0;
                    end
                    else if (wait_counter > WAIT_MAX)begin
                        current_state <= PLAYING;
                        light <= zeros;
                        wrong_counter <= wrong_counter + wait_counter;
                        wait_counter <= 0;
                    end 
                    else begin
                        current_state <= WAITING;
                        light <= keys[supposed_note];
                        wait_counter <= wait_counter + 1;
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
                        if (index < max_index) begin
                            current_state <= WAITING;
                        end else begin
                            current_state <= FINISHED;
                        end
                    end
                end
                FINISHED: begin
                    if(wrong_counter < ((WAIT_MAX * max_index) >> 2))begin
                        segments <= A_segment;
                    end
                    else if(wrong_counter < ((WAIT_MAX * max_index) >> 1))begin
                        segments <= B_segment;
                    end
                    else if(wrong_counter < ((WAIT_MAX * max_index) >>1 + ((WAIT_MAX * max_index) >> 2)))begin
                        segments <= C_segment;
                    end
                    else begin
                        segments <= D_segment;
                    end
                    finished <= 1'b1;
                end
            endcase
        end
        end
endmodule