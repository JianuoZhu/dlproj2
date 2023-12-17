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
    input  clk,
    input rst,
    input mode_switch,
    output [2:0] mode_light,
    output wire speaker,
    output reg [7:0] light
);
    wire [2:0] mode;
    wire en_mode1, en_mode2, en_mode3;
    reg [3:0] note;
    //连接模式选择
    patterns pat(.clk(clk),.rst(rst),.mode_switch(mode_switch),.mode_light(mode_light),.en_mode1(en_mode1),.en_mode2(en_mode2),.en_mode3(en_mode3));
    Buzzer buzzer(.clk(clk), .note(note), .button_low_tone(low_button), .button_high_tone(high_button), .speaker(speaker));
    
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
            note<= i;
            light<=keys[i];
        end
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
    
    parameter MODE_1 = 2'b00;
    parameter MODE_2 = 2'b01;
    parameter MODE_3 = 2'b10;
    
    reg [1:0] current_mode;
    reg flag;
    wire debounced_mode_switch;
    Debounce debounce_mode_switch(.clk(clk), .button_in(mode_switch), .button_out(debounced_mode_switch));
    always @(posedge clk or negedge rst) begin
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
