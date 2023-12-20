`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/17 20:45:09
// Design Name: 
// Module Name: lib
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


module lib(
input [1:0] music,
input [7:0] index,
output reg [3:0] note,
output reg low=1'b0,
output reg high=1'b0
    );
    always @(music, index) begin
      case (music)
        2'b00: 
          case (index)
            8'b0000_0000: note = 4'b0001; 
            8'b0000_0001: note = 4'b0001;  
            8'b0000_0010: note = 4'b0101;
            8'b0000_0011: note = 4'b0101; 
            8'b0000_0100: note = 4'b0110;
            8'b0000_0101: note = 4'b0110;
            8'b0000_0110: note = 4'b0101;

            8'b0000_0111: note = 4'b0100;
            8'b0000_1000: note = 4'b0100;
            8'b0000_1001: note = 4'b0011;
            8'b0000_1010: note = 4'b0011;
            8'b0000_1011: note = 4'b0010;
            8'b0000_1100: note = 4'b0010;
            8'b0000_1101: note = 4'b0001;

            8'b0000_1110: note = 4'b0101;
            8'b0000_1111: note = 4'b0101;
            8'b0001_0000: note = 4'b0100;
            8'b0001_0001: note = 4'b0100;
            8'b0001_0010: note = 4'b0011;
            8'b0001_0011: note = 4'b0011;
            8'b0001_0100: note = 4'b0010;

            8'b0001_0101: note = 4'b0101;
            8'b0001_0110: note = 4'b0101;
            8'b0001_0111: note = 4'b0100;
            8'b0001_1000: note = 4'b0100;
            8'b0001_1001: note = 4'b0011;
            8'b0001_1010: note = 4'b0011;
            8'b0001_1011: note = 4'b0010;

            8'b0001_1100: note = 4'b0001;  
            8'b0001_1101: note = 4'b0001; 
            8'b0001_1110: note = 4'b0101;
            8'b0001_1111: note = 4'b0101; 
            8'b0010_0000: note = 4'b0110;
            8'b0010_0001: note = 4'b0110;
            8'b0010_0010: note = 4'b0101;

            8'b0010_0011: note = 4'b0100;
            8'b0010_0100: note = 4'b0100;
            8'b0010_0101: note = 4'b0011;
            8'b0010_0110: note = 4'b0011;
            8'b0010_0111: note = 4'b0010;
            8'b0010_1000: note = 4'b0010;
            8'b0010_1001: note = 4'b0001;
            default: note = 4'b0000;
          endcase

        2'b01:
          case (index)
            8'b0000_0000: note = 4'b0001;
            8'b0000_0001: note = 4'b0010;
            8'b0000_0010: note = 4'b0011;
            8'b0000_0011: note = 4'b0001;
            8'b0000_0100: note = 4'b0001;
            8'b0000_0101: note = 4'b0010;
            8'b0000_0110: note = 4'b0011;
            8'b0000_0111: note = 4'b0001;
            8'b0000_1000: note = 4'b0011;
            8'b0000_1001: note = 4'b0100;
            8'b0000_1010: note = 4'b0101;
            8'b0000_1011: note = 4'b0011;
            8'b0000_1100: note = 4'b0100;
            8'b0000_1101: note = 4'b0101;

            8'b0000_1110: note = 4'b0101;
            8'b0000_1111: note = 4'b0110;
            8'b0001_0000: note = 4'b0101;
            8'b0001_0001: note = 4'b0100;
            8'b0001_0010: note = 4'b0011;
            8'b0001_0011: note = 4'b0001;
            8'b0001_0100: note = 4'b0101;
            8'b0001_0101: note = 4'b0110;
            8'b0001_0110: note = 4'b0101;
            8'b0001_0111: note = 4'b0100;
            8'b0001_1000: note = 4'b0011;
            8'b0001_1001: note = 4'b0001;
            
            8'b0001_1010: note = 4'b0001;
            8'b0001_1011:begin
                             low=1'b1;
                             note = 4'b0101;
                         end
            8'b0001_1100: begin
                            low=1'b0;
                            note = 4'b0001;
                            end
            8'b0001_1101: note = 4'b0001;
            8'b0001_1110:begin
                             low=1'b1;
                             note = 4'b0101;
                         end
            8'b0001_1111:begin
                            low=1'b0;
                             note = 4'b0001;
                         end
            default: note = 4'b0000;
           endcase
      endcase
    end    
endmodule