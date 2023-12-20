`timescale 1ns / 1ps

module sim;

    // 测试平台的输入和输出端口
    reg [7:0] inputs;
    reg low_button;
    reg high_button;
    reg clk;
    reg rst;
    reg mode_switch;
    wire [2:0] mode_light;
    wire speaker;
    wire [7:0] light;
    wire [7:0] display_segments;
    wire tub_sel;
    wire low_light;
    wire high_light;
    wire zero;

    // 实例化 Controller 模块
    Controller uut (
        .inputs(inputs),
        .low_button(low_button),
        .high_button(high_button),
        .clk(clk),
        .rst(rst),
        .mode_switch(mode_switch),
        .mode_light(mode_light),
        .speaker(speaker),
        .light(light),
        .display_segments(display_segments),
        .tub_sel(tub_sel),
        .low_light(low_light),
        .high_light(high_light),
        .zero(zero)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 产生一个周期为10ns的时钟信号
    end

    // 测试过程
    initial begin
        // 初始化测试
        rst = 0;
        inputs = 0;
        low_button = 0;
        high_button = 0;
        mode_switch = 0;
        #10;
        rst = 1;

        // 测试不同的输入和模式切换
        #20;
        mode_switch = 1;
        #25;
        mode_switch = 0;
        inputs = 8'b00000001;
        #20
        inputs = 8'b00000001;
        #20
        inputs = 8'b00000101;
        #20
        inputs = 8'b00000101;
        // 更多的测试情况可以在这里添加

        // 测试结束
        $finish;
    end

endmodule
