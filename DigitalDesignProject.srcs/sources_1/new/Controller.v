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
input  clk,
output wire speaker,
output reg [7:0] light
    );
    wire[7:0] keys [7:0];
    assign keys[0] = 8'b00000000;
    assign keys[1] = 8'b00000001; 
    assign keys[2] = 8'b00000010; 
    assign keys[3] = 8'b00000100; 
    assign keys[4] = 8'b00001000; 
    assign keys[5] = 8'b00010000; 
    assign keys[6] = 8'b00100000; 
    assign keys[7] = 8'b01000000;  
    reg [3:0] note;
    
    integer i;
    
    Buzzer buzzer(.clk(clk),.note(note),.speaker(speaker));
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
