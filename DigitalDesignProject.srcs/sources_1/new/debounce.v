module Debounce(
    input clk,        // 系统时钟，100MHz
    input button_in,  // 原始按钮输入
    output reg button_out  // 防抖动后的按钮输出
);

// 参数定义
parameter DEBOUNCE_INTERVAL = 1000000;  // 防抖时间间隔，100MHz时钟下约为10ms

// 内部变量
reg [19:0] counter;  // 用于防抖计时的计数器
reg button_in_prev;  // 存储按钮的上一个状态

// 初始化
initial begin
    counter = 0;
    button_out = 0;
    button_in_prev = 0;
end

// 主要防抖逻辑
always @(posedge clk) begin
    // 检测按钮状态是否改变
    if (button_in != button_in_prev) begin
        counter = 0;
    end else if (counter < DEBOUNCE_INTERVAL) begin
        counter = counter + 1;
    end

    // 如果计数器达到防抖时间间隔，则更新输出状态
    if (counter >= DEBOUNCE_INTERVAL) begin
        button_out <= button_in;
    end

    // 更新上一个按钮状态
    button_in_prev <= button_in;
end

endmodule
