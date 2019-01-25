//
//  XHSLineChatView.m
//  WSLineChart
//
//  Created by Hongshuo Xiao on 2019/1/24.
//  Copyright © 2019 zws. All rights reserved.
//

#import "XHSLineChatView.h"

#import "SVProgressHUD.h"
#import "XXAxisView.h"
#import "YYAxisView.h"

#define leftMargin 45
//#define defaultSpace 5
#define lastSpace 5

@interface XHSLineChatView ()

@property (strong, nonatomic) NSArray *xTitleArray;
@property (strong, nonatomic) NSArray *yValueArray;
@property (assign, nonatomic) CGFloat yMax;
@property (assign, nonatomic) CGFloat yMin;
@property (strong, nonatomic) YYAxisView *yAxisView;
@property (strong, nonatomic) XXAxisView *xAxisView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (assign, nonatomic) CGFloat pointGap;
@property (assign, nonatomic) CGFloat defaultSpace;//间距

@property (assign, nonatomic) CGFloat moveDistance;

@property (strong, nonatomic) NSString * type;

@end

@implementation XHSLineChatView

- (id)initWithFrame:(CGRect)frame xTitleArray:(NSArray*)xTitleArray yValueArray:(NSArray*)yValueArray yMax:(CGFloat)yMax yMin:(CGFloat)yMin type:(nonnull NSString *)type{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.type=type;
        self.xTitleArray = xTitleArray;
        self.yValueArray = yValueArray;
        self.yMax = yMax;
        self.yMin = yMin;
        
        if (xTitleArray.count > 600) {
            _defaultSpace = 5;
        }
        else if (xTitleArray.count > 400 && xTitleArray.count <= 600){
            _defaultSpace = 10;
        }
        else if (xTitleArray.count > 200 && xTitleArray.count <= 400){
            _defaultSpace = 20;
        }
        else if (xTitleArray.count > 100 && xTitleArray.count <= 200){
            _defaultSpace = 30;
        }
        //        else if (xTitleArray.count > 12 && xTitleArray.count <= 100){
        //            _defaultSpace = 15;
        //        }
        else {
            _defaultSpace = 30;
        }
        
        self.pointGap = (frame.size.width-lastSpace)/(xTitleArray.count+0.5);
        
        [self creatYAxisView];
        
        [self creatXAxisView];
        
        // 2. 捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        [self.xAxisView addGestureRecognizer:pinch];
        
        //长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(event_longPressAction:)];
        [self.xAxisView addGestureRecognizer:longPress];
    }
    return self;
}



- (void)creatYAxisView {
    
    self.yAxisView = [[YYAxisView alloc]initWithFrame:CGRectMake(0, 0, leftMargin, self.frame.size.height) yMax:self.yMax yMin:self.yMin];
    [self addSubview:self.yAxisView];
    
}

- (void)creatXAxisView {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(leftMargin, 0, self.frame.size.width-leftMargin, self.frame.size.height)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self addSubview:_scrollView];
    
    self.xAxisView = [[XXAxisView alloc] initWithFrame:CGRectMake(0, 0, self.xTitleArray.count * self.pointGap + lastSpace, self.frame.size.height) xTitleArray:self.xTitleArray yValueArray:self.yValueArray yMax:self.yMax yMin:self.yMin type:self.type];
    
    [_scrollView addSubview:self.xAxisView];
    
    _scrollView.contentSize = self.xAxisView.frame.size;
    
}


// 捏合手势监听方法
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == 3) {
        
        if (self.xAxisView.frame.size.width-lastSpace <= self.scrollView.frame.size.width) { //当缩小到小于屏幕宽时，松开回复屏幕宽度
            
            CGFloat scale = self.scrollView.frame.size.width / (self.xAxisView.frame.size.width-lastSpace);
            
            self.pointGap *= scale;
            
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = self.xAxisView.frame;
                frame.size.width = self.scrollView.frame.size.width+lastSpace;
                self.xAxisView.frame = frame;
            }];
            
            self.xAxisView.pointGap = self.pointGap;
            
        }else if (self.xAxisView.frame.size.width-lastSpace >= self.xTitleArray.count * _defaultSpace){
            
            [UIView animateWithDuration:0.25 animations:^{
                CGRect frame = self.xAxisView.frame;
                frame.size.width = self.xTitleArray.count * _defaultSpace + lastSpace;
                self.xAxisView.frame = frame;
                
            }];
            
            self.pointGap = _defaultSpace;
            
            self.xAxisView.pointGap = self.pointGap;
        }
    }else{
        
        CGFloat currentIndex,leftMagin;
        if( recognizer.numberOfTouches == 2 ) {
            //2.获取捏合中心点 -> 捏合中心点距离scrollviewcontent左侧的距离
            CGPoint p1 = [recognizer locationOfTouch:0 inView:self.xAxisView];
            CGPoint p2 = [recognizer locationOfTouch:1 inView:self.xAxisView];
            CGFloat centerX = (p1.x+p2.x)/2;
            leftMagin = centerX - self.scrollView.contentOffset.x;
            //            NSLog(@"centerX = %f",centerX);
            //            NSLog(@"self.scrollView.contentOffset.x = %f",self.scrollView.contentOffset.x);
            //            NSLog(@"leftMagin = %f",leftMagin);
            
            
            currentIndex = centerX / self.pointGap;
            //            NSLog(@"currentIndex = %f",currentIndex);
            
            
            
            self.pointGap *= recognizer.scale;
            self.pointGap = self.pointGap > _defaultSpace ? _defaultSpace : self.pointGap;
            if (self.pointGap == _defaultSpace) {
                
                [SVProgressHUD showErrorWithStatus:@"已经放至最大"];
            }
            self.xAxisView.pointGap = self.pointGap;
            recognizer.scale = 1.0;
            
            self.xAxisView.frame = CGRectMake(0, 0, self.xTitleArray.count * self.pointGap + lastSpace, self.frame.size.height);
            
            self.scrollView.contentOffset = CGPointMake(currentIndex*self.pointGap-leftMagin, 0);
            //            NSLog(@"contentOffset = %f",self.scrollView.contentOffset.x);
            
        }
        
        
        
        
        
    }
    
    self.scrollView.contentSize = CGSizeMake(self.xAxisView.frame.size.width, 0);
    
    
    
    
}


- (void)event_longPressAction:(UILongPressGestureRecognizer *)longPress {
    
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state) {
        
        CGPoint location = [longPress locationInView:self.xAxisView];
        
        //相对于屏幕的位置
        CGPoint screenLoc = CGPointMake(location.x - self.scrollView.contentOffset.x, location.y);
        [self.xAxisView setScreenLoc:screenLoc];
        
        if (ABS(location.x - _moveDistance) > self.pointGap) { //不能长按移动一点点就重新绘图  要让定位的点改变了再重新绘图
            
            [self.xAxisView setIsShowLabel:YES];
            [self.xAxisView setIsLongPress:YES];
            self.xAxisView.currentLoc = location;
            _moveDistance = location.x;
        }
    }
    
    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        _moveDistance = 0;
        //恢复scrollView的滑动
        [self.xAxisView setIsLongPress:NO];
        [self.xAxisView setIsShowLabel:NO];
        
    }
}

@end
