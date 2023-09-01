module water_led(
    input  wire        sys_clk,         //1秒震荡50_000_000次，周期是20ns
    input  wire        sys_rst_n,       //1s = 1_000_000_000ns,震荡一次是20bs
    output reg  [3:0]  led=4'b0001      //always语句赋值就不是wire类型 []矢量写法
);

localparam CNT_IS_MAX=26'd50_000_000;   //定义一个1s计数器:50_000_000,需要26个位宽

reg [25:0] cnt_1s;                      //寄存器cnt_1s的位宽是26位

//1秒钟计数器模块
always @(posedge sys_clk or negedge sys_rst_n) //敏感信号列表,表示在系统时钟信号（sys_clk）的上升沿（posedge）或者系统复位信号的下降沿（negedge sys_rst_n）发生时，执行后续的操作或逻辑。
    if(sys_rst_n==1'b0)                 //按下复位键，清零
        cnt_1s <= 26'd0;                
    else if (cnt_1s==CNT_IS_MAX-1'b1)   //实际值是200_000_000，仿真用200
        cnt_1s <= 26'd0;                //计数达到顶值，清零
    else 
        cnt_1s <= cnt_1s+1'd1;

//控制LED亮灭
always @(posedge sys_clk or negedge sys_rst_n) 
    if(sys_rst_n==1'b0)
        led<=4'b0001;
    else if((cnt_1s == CNT_IS_MAX-1'b1)&&(led==4'b1000))
        led<=4'b0001;
    else if(cnt_1s == CNT_IS_MAX-1'b1)
        led<=led<<1'b1;
    else
        led<=led;

endmodule