parameter song1 = 3'b000,song2 = 3'b001,song3 = 3'b010;
parameter stop = 4'b0000,do = 4'b0001,re = 4'b0010,mi = 4'b0011,fa = 4'b0100,so = 4'b0101,la = 4'b0110,si = 4'b0111;
parameter lstop = 8'b00000000,ldo = 8'b00000001,lre = 8'b00000010,lmi = 8'b00000100,lfa = 8'b00001000,lso = 8'b00010000,lla = 8'b00100000,lsi = 8'b01000000;
parameter segnull = 8'b00000000,seg1 = 8'b01100000,seg2 = 8'b11011010,seg3 = 8'b11110010;
parameter index0 = 8'b00000000,indexfull = 8'b11111111;
parameter cnt0 = 32'd0;
parameter set0 = 1'b0,set1 = 1'b1;
parameter TIME = 50000000;
parameter GAP = 10000000;