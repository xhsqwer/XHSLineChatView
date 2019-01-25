//
//  ViewController.m
//  WSLineChart
//
//  Created by iMac on 16/11/14.
//  Copyright © 2016年 zws. All rights reserved.
//

#import "ViewController.h"
#import "XHSLineChatView.h"
#define SCREEN_WIDTH                                [[UIScreen mainScreen] bounds].size.width
#define KW(R)                                       R*(SCREEN_WIDTH)/360


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    NSMutableArray *xArray = [[NSMutableArray alloc]initWithObjects:@"7/20",@"8/18",@"9/1",@"9/15",@"9/20",@"10/3",@"10/20",@"11/6",@"11/19",@"11/25",@"12/3",@"12/3",@"12/3",@"12/3",@"12/3",@"12/3", nil];
    NSMutableArray *yArray = [[NSMutableArray alloc]initWithObjects:@"0.25",@"0.51",@"0.69",@"0.71",@"0.77",@"1.65",@"2.45",@"3.25",@"4.25",@"4.68",@"4.32",@"5", @"5.6",@"6.8",@"7.2",@"7.88",nil];
//    for (NSInteger i = 0; i < 11; i++) {
//
//        [xArray addObject:[NSString stringWithFormat:@"%.1f",3+0.1*i]];
//        [yArray addObject:[NSString stringWithFormat:@"%.2lf",20.0+arc4random_uniform(10)]];
//
//    }
    
//   type:1渐变折线样式，2无渐变折线样式
    XHSLineChatView *wsLine = [[XHSLineChatView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width-KW(15), KW(300)) xTitleArray:xArray yValueArray:yArray yMax:10 yMin:0 type:@"1"];
    [self.view addSubview:wsLine];
    
}






@end
