module lib(
    input [2:0] music,
    input [7:0] index,
    output reg [3:0] note,
    output reg low=1'b0,
    output reg high=1'b0,
    output reg gap=1'b0
    );
    `include "parameter.v"
    always @(*) begin
      case (music)
        3'b000: 
          case (index)
            8'b0000_0000: begin note = do; gap = set1; end
            8'b0000_0001: begin note = do; gap = set1; end  
            8'b0000_0010: begin note = so; gap = set1; end
            8'b0000_0011: begin note = so; gap = set1; end
            8'b0000_0100: begin note = la; gap = set1; end
            8'b0000_0101: begin note = la; gap = set1; end
            8'b0000_0110: begin note = so; gap = set0; end
            8'b0000_0111: begin note = so; gap = set1; end

            8'b0000_1000: begin note = fa; gap = set1; end
            8'b0000_1001: begin note = fa; gap = set1; end
            8'b0000_1010: begin note = mi; gap = set1; end
            8'b0000_1011: begin note = mi; gap = set1; end
            8'b0000_1100: begin note = re; gap = set1; end
            8'b0000_1101: begin note = re; gap = set1; end
            8'b0000_1110: begin note = do; gap = set0; end
            8'b0000_1111: begin note = do; gap = set1; end

            8'b0001_0000: begin note = so; gap = set1; end
            8'b0001_0001: begin note = so; gap = set1; end
            8'b0001_0010: begin note = fa; gap = set1; end
            8'b0001_0011: begin note = fa; gap = set1; end
            8'b0001_0100: begin note = mi; gap = set1; end
            8'b0001_0101: begin note = mi; gap = set1; end
            8'b0001_0110: begin note = re; gap = set0; end
            8'b0001_0111: begin note = re; gap = set1; end
            
            8'b0001_1000: begin note = so; gap = set1; end
            8'b0001_1001: begin note = so; gap = set1; end
            8'b0001_1010: begin note = fa; gap = set1; end
            8'b0001_1011: begin note = fa; gap = set1; end
            8'b0001_1100: begin note = mi; gap = set1; end 
            8'b0001_1101: begin note = mi; gap = set1; end 
            8'b0001_1110: begin note = re; gap = set0; end
            8'b0001_1111: begin note = re; gap = set1; end
            
            8'b0010_0000: begin note = do; gap = set1; end
            8'b0010_0001: begin note = do; gap = set1; end  
            8'b0010_0010: begin note = so; gap = set1; end
            8'b0010_0011: begin note = so; gap = set1; end
            8'b0010_0100: begin note = la; gap = set1; end
            8'b0010_0101: begin note = la; gap = set1; end
            8'b0010_0110: begin note = so; gap = set0; end
            8'b0010_0111: begin note = so; gap = set1; end

            8'b0010_1000: begin note = fa; gap = set1; end
            8'b0010_1001: begin note = fa; gap = set1; end
            8'b0010_1010: begin note = mi; gap = set1; end
            8'b0010_1011: begin note = mi; gap = set1; end
            8'b0010_1100: begin note = re; gap = set1; end
            8'b0010_1101: begin note = re; gap = set1; end
            8'b0010_1110: begin note = do; gap = set0; end
            8'b0010_1111: begin note = do; gap = set1; end
            
            default: note = stop;
          endcase

        3'b001:
          case (index)
            8'b0000_0000: begin note = do; gap = set1; end
            8'b0000_0001: begin note = re; gap = set1; end
            8'b0000_0010: begin note = mi; gap = set1; end
            8'b0000_0011: begin note = do; gap = set1; end
            8'b0000_0100: begin note = do; gap = set1; end
            8'b0000_0101: begin note = re; gap = set1; end
            8'b0000_0110: begin note = mi; gap = set1; end
            8'b0000_0111: begin note = do; gap = set1; end
            8'b0000_1000: begin note = mi; gap = set1; end
            8'b0000_1001: begin note = fa; gap = set1; end
            8'b0000_1010: begin note = so; gap = set0; end
            8'b0000_1011: begin note = so; gap = set1; end
            8'b0000_1100: begin note = mi; gap = set1; end
            8'b0000_1101: begin note = fa; gap = set1; end
            8'b0000_1110: begin note = so; gap = set0; end
            8'b0000_1111: begin note = so; gap = set1; end
            
            8'b0001_0000: begin note = so; gap = set1; end
            8'b0001_0001: begin note = la; gap = set1; end
            8'b0001_0010: begin note = so; gap = set1; end
            8'b0001_0011: begin note = fa; gap = set1; end
            8'b0001_0100: begin note = mi; gap = set1; end
            8'b0001_0101: begin note = do; gap = set1; end
            8'b0001_0110: begin note = so; gap = set1; end
            8'b0001_0111: begin note = la; gap = set1; end
            8'b0001_1000: begin note = so; gap = set1; end
            8'b0001_1001: begin note = fa; gap = set1; end
            8'b0001_1010: begin note = mi; gap = set1; end
            8'b0001_1011: begin note = do; gap = set1; end
            8'b0001_1100: begin note = do; gap = set1; end
            8'b0001_1101: begin note = so; gap = set1; low=1'b1; end
            8'b0001_1110: begin note = do; gap = set0; end
            8'b0001_1111: begin note = do; gap = set1; end
            8'b0010_0000: begin note = do; gap = set1; end
            8'b0010_0001: begin note = so; gap = set1; low=1'b1; end
            8'b0010_0010: begin note = do; gap = set0; end
            8'b0010_0011: begin note = do; gap = set1; end
            default: note = 4'b0000;
        endcase
        
        3'b010:
          case (index)
            8'b0000_0000: begin note = mi; gap = set1; end
            8'b0000_0001: begin note = re; gap = set1; end
            8'b0000_0010: begin note = do; gap = set1; end
            8'b0000_0011: begin note = re; gap = set1; end
            8'b0000_0100: begin note = mi; gap = set1; end
            8'b0000_0101: begin note = mi; gap = set1; end
            8'b0000_0110: begin note = mi; gap = set0; end
            8'b0000_0111: begin note = mi; gap = set1; end
            8'b0000_1000: begin note = re; gap = set1; end
            8'b0000_1001: begin note = re; gap = set1; end
            8'b0000_1010: begin note = re; gap = set0; end
            8'b0000_1011: begin note = re; gap = set1; end
            8'b0000_1100: begin note = mi; gap = set1; end
            8'b0000_1101: begin note = mi; gap = set1; end
            8'b0000_1110: begin note = mi; gap = set0; end
            8'b0000_1111: begin note = mi; gap = set1; end
            
            8'b0001_0000: begin note = mi; gap = set1; end
            8'b0001_0001: begin note = re; gap = set1; end
            8'b0001_0010: begin note = do; gap = set1; end
            8'b0001_0011: begin note = re; gap = set1; end
            8'b0001_0100: begin note = mi; gap = set1; end
            8'b0001_0101: begin note = mi; gap = set1; end
            8'b0001_0110: begin note = mi; gap = set1; end
            8'b0001_0111: begin note = do; gap = set1; end
            8'b0001_1000: begin note = re; gap = set1; end
            8'b0001_1001: begin note = re; gap = set1; end
            8'b0001_1010: begin note = mi; gap = set1; end
            8'b0001_1011: begin note = re; gap = set1; end
            8'b0001_1100: begin note = do; gap = set0; end
            8'b0001_1101: begin note = do; gap = set0; end
            8'b0001_1110: begin note = do; gap = set0; end
            8'b0001_1111: begin note = do; gap = set1; end
            default: note = 4'b0000;
        endcase
      endcase
    end    
endmodule
