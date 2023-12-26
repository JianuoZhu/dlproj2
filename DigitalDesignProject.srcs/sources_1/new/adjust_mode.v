module Adjust_Mode(
    input enable,
    input clk,
    input rst_n,
    input[7:0] inputs,
    output reg [7:0] light,
    output reg [3:0] note,
    output reg [2:0] adj_addr,
    output reg [7:0] adj_key
);
    parameter ADJUST_STATE = 2'b00, PLAY_STATE = 2'b01, FINISH_STATE = 2'b10, a_sec = 100000000;
    reg [1:0] current_state;
    reg [2:0] state_counter;
    reg [7:0] write_enables;
    reg press_flag;
    reg [7:0] tmp_keys [7:0];
    reg [2:0] clk_counter;
    /*generate
    genvar i;
    for (i = 0; i < 8; i = i + 1) begin : mem_gen
        memory_module memory(
            .clk(clk),
            .reset(rst),
            .addr(i[2:0]),
            .data_in(tmp_keys[i]),
            .data_out(8'b00000000),
            .write_enable(1'b1),
            .read_enable(1'b0)
        );
    end
    endgenerate*/
    reg [31:0]time_counter;
    always @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            tmp_keys[0] <= 8'b00000000;
            tmp_keys[1] <= 8'b00000001; 
            tmp_keys[2] <= 8'b00000010; 
            tmp_keys[3] <= 8'b00000100; 
            tmp_keys[4] <= 8'b00001000; 
            tmp_keys[5] <= 8'b00010000; 
            tmp_keys[6] <= 8'b00100000; 
            tmp_keys[7] <= 8'b01000000; 
            state_counter <= 3'b000;
            current_state <= ADJUST_STATE;
            note <= 4'b0000;
            time_counter <= 0;
            adj_addr <= 3'b000;
            adj_key <= 8'b0000_0000;
        end else if(enable) begin
            write_enables <= 8'b11111111;
            case(current_state)
                ADJUST_STATE: begin
                    if(inputs != 8'b0000_0000 && state_counter < 3'b111) begin
                        current_state <= PLAY_STATE;
                        //tmp_keys[state_counter+1] <= inputs;
                        /*write_enables[state_counter+1] <= 1'b1;
                        state_counter <= state_counter + 1;*/
                        adj_addr <= state_counter + 1;
                        adj_key <= inputs;
                        state_counter <= state_counter + 1;
                    end else if(state_counter==3'b111) begin
                        current_state <= FINISH_STATE;
                    end
                    else begin
                        light <= tmp_keys[state_counter+1];
                    end
                end
                PLAY_STATE: begin
                    if (time_counter < a_sec) begin
                        time_counter <= time_counter + 1;
                        note <= {1'b0,state_counter};
                        light <= tmp_keys[state_counter];
                    end else begin
                        light <= 8'b0000_0000;
                        note <= 4'b0000;
                        time_counter <= 0;
                        adj_addr <= 3'b000;
                        adj_key <= 8'b0000_0000;
                        if (state_counter < 3'b111) begin
                            current_state <= ADJUST_STATE;
                        end else begin
                            current_state <= FINISH_STATE;
                        end
                    end
                    
                end
                FINISH_STATE: begin
                    note <= 4'b0000;
                    light <= 8'b0000_0000;
                end
                default: current_state <= ADJUST_STATE;
            endcase
        end
    end
endmodule