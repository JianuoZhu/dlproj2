module memory_module (
    input clk,
    input reset,
    input [2:0] addr,        // 3位地址用于访问8个位置
    input [7:0] data_in,     // 8位数据输入
    output reg [7:0] data_out, // 8位数据输出
    input write_enable,
    input read_enable
);

// 定义8x8内存数组
reg [7:0] keys [7:0];

// 同步逻辑
always @(posedge clk, negedge reset) begin
    if (!reset) begin
        //赋初始值
        keys[0] <= 8'b00000000;
        keys[1] <= 8'b00000001; 
        keys[2] <= 8'b00000010; 
        keys[3] <= 8'b00000100; 
        keys[4] <= 8'b00001000; 
        keys[5] <= 8'b00010000; 
        keys[6] <= 8'b00100000; 
        keys[7] <= 8'b01000000;
    end else begin
        if (write_enable) begin
            // 执行写操作
            keys[addr] <= data_in;
        end

        if (read_enable) begin
            // 执行读操作
            data_out <= keys[addr+1];
        end
    end
end

endmodule
