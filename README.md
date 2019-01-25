# XHSLineChatView
XHSLineChatView
折线图，支持放大缩小，横向定位放大,增加长按功能,y轴的值可以自己设置。采用贝塞尔曲线，核心绘图，支持大数据量。减少卡顿，左右滑动流畅

https://github.com/xhsqwer/XHSLineChatView/blob/master/%E5%B1%8F%E5%B9%95%E5%BF%AB%E7%85%A7%202019-01-25%20%E4%B8%8A%E5%8D%8811.25.37.png?raw=true

# How To Use

```ruby

1.将XHSLineChatView文件夹拖入工程中

#import "XHSLineChatView.h"

NSMutableArray *xArray = [[NSMutableArray alloc]initWithObjects:@"7/20",@"8/18",@"9/1",@"9/15",@"9/20",@"10/3",@"10/20",@"11/6",@"11/19",@"11/25",@"12/3",@"12/3",@"12/3",@"12/3",@"12/3",@"12/3", nil];
NSMutableArray *yArray = [[NSMutableArray alloc]initWithObjects:@"0.25",@"0.51",@"0.69",@"0.71",@"0.77",@"1.65",@"2.45",@"3.25",@"4.25",@"4.68",@"4.32",@"5", @"5.6",@"6.8",@"7.2",@"7.88",nil];


//   type:1渐变折线样式，2无渐变折线样式
XHSLineChatView *wsLine = [[XHSLineChatView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width-KW(15), KW(300)) xTitleArray:xArray yValueArray:yArray yMax:10 yMin:0 type:@"1"];
[self.view addSubview:wsLine];

喜欢的点个星。 (*^__^*)
