//
//  XXAxisView.m
//  WSLineChart
//
//  Created by Hongshuo Xiao on 2019/1/24.
//  Copyright © 2019 zws. All rights reserved.
//

#import "XXAxisView.h"

#define topMargin 0   // 为顶部留出的空白
#define kChartLineColor         [UIColor colorWithRed:109.0/255 green:109.0/255 blue:109.0/255 alpha:1]
#define kChartTextColor         [UIColor colorWithRed:79.0/255 green:79.0/255 blue:79.0/255 alpha:1]
#define numberOfYAxisElements 4 // y轴分为几段
//#define defaultSpace 5
#define leftMargin 45
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

@interface XXAxisView ()
{
    NSMutableArray *pointArray;
    CAGradientLayer *_gradientLayer;
}
@property (strong, nonatomic) NSArray *xTitleArray;
@property (strong, nonatomic) NSArray *yValueArray;
@property (assign, nonatomic) CGFloat yMax;
@property (assign, nonatomic) CGFloat yMin;

@property (assign, nonatomic) CGFloat defaultSpace;

/**
 *  记录坐标轴的第一个frame
 */
@property (assign, nonatomic) CGRect firstFrame;
@property (assign, nonatomic) CGRect firstStrFrame;//第一个点的文字的frame

@property (strong, nonatomic) NSString * type;


@end

@implementation XXAxisView

- (id)initWithFrame:(CGRect)frame xTitleArray:(NSArray*)xTitleArray yValueArray:(NSArray*)yValueArray yMax:(CGFloat)yMax yMin:(CGFloat)yMin type:(NSString *) type{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.type=type;
        pointArray=[NSMutableArray new];
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
        
        self.pointGap = (frame.size.width-5)/(xTitleArray.count+0.5);
//        self.pointGap = _defaultSpace;
        
        
    }
    
    return self;
}

- (void)setPointGap:(CGFloat)pointGap {
    _pointGap = pointGap;
    
    [self setNeedsDisplay];
}

- (void)setIsLongPress:(BOOL)isLongPress {
    _isLongPress = isLongPress;
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    ////////////////////// X轴文字 //////////////////////////
    // 添加坐标轴Label
    for (int i = 0; i < self.xTitleArray.count; i++) {
        NSString *title = self.xTitleArray[i];
        
        [[UIColor blackColor] set];
        NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
        CGSize labelSize = [title sizeWithAttributes:attr];
        
        CGRect titleRect = CGRectMake((i) * self.pointGap+self.pointGap/2 - labelSize.width / 2,self.frame.size.height - labelSize.height,labelSize.width,labelSize.height);
        
        if (i == 0) {
            self.firstFrame = titleRect;
            if (titleRect.origin.x < 0) {
                titleRect.origin.x = 0;
            }
            
            [title drawInRect:titleRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
            
            //画垂直X轴的竖线
            [self drawLine:context
                startPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, self.frame.size.height - labelSize.height-5)
                  endPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, self.frame.size.height - labelSize.height-10)
                 lineColor:kChartLineColor
                 lineWidth:1];
        }
        // 如果Label的文字有重叠，那么不绘制
        CGFloat maxX = CGRectGetMaxX(self.firstFrame);
        if (i != 0) {
            if ((maxX + 3) > titleRect.origin.x) {
                //不绘制
                
            }else{
                
                [title drawInRect:titleRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
                //画垂直X轴的竖线
                [self drawLine:context
                    startPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, self.frame.size.height - labelSize.height-5)
                      endPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, self.frame.size.height - labelSize.height-10)
                     lineColor:kChartLineColor
                     lineWidth:1];
                
                self.firstFrame = titleRect;
            }
        }else {
            if (self.firstFrame.origin.x < 0) {
                
                CGRect frame = self.firstFrame;
                frame.origin.x = 0;
                self.firstFrame = frame;
            }
        }
        
    }
    
    //////////////// 画原点上的x轴 ///////////////////////
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
    CGSize textSize = [@"x" sizeWithAttributes:attribute];
    
    [self drawLine:context
        startPoint:CGPointMake(0, self.frame.size.height - textSize.height - 5)
          endPoint:CGPointMake(self.frame.size.width, self.frame.size.height - textSize.height - 5)
         lineColor:kChartLineColor
         lineWidth:1];
    
    
    //////////////// 画横向分割线 ///////////////////////
    CGFloat separateMargin = (self.frame.size.height - topMargin - textSize.height - 5 - 5 * 1) / numberOfYAxisElements;
    for (int i = 0; i < numberOfYAxisElements; i++) {
        
        [self drawLine:context
            startPoint:CGPointMake(0, self.frame.size.height - textSize.height - 5  - (i + 1) *(separateMargin + 1))
              endPoint:CGPointMake(0+self.frame.size.width, self.frame.size.height - textSize.height - 5  - (i + 1) *(separateMargin + 1))
             lineColor:[UIColor colorWithRed:109.0/255 green:109.0/255 blue:109.0/255 alpha:1]
             lineWidth:.1];
    }
    
    
    /////////////////////// 根据数据源画折线 /////////////////////////
    if (self.yValueArray && self.yValueArray.count > 0) {
        CGPoint ranPoint;
        if ([self.type integerValue] == 1) {
            [_gradientLayer removeFromSuperlayer];
            [pointArray removeAllObjects];
        }
        //画折线
        for (NSInteger i = 0; i < self.yValueArray.count; i++) {
            //如果是最后一个点
            if (i == self.yValueArray.count-1) {
                
                NSNumber *endValue = self.yValueArray[i];
                CGFloat chartHeight = self.frame.size.height - textSize.height - 5 - topMargin;
                CGPoint endPoint = CGPointMake((i)*self.pointGap+self.pointGap/2, chartHeight -  (endValue.floatValue-self.yMin)/(self.yMax-self.yMin) * chartHeight+topMargin);
                ranPoint=endPoint;
                if ([self.type integerValue] == 2) {
                    CGContextSetRGBStrokeColor(context,0.0,97.0,174.0,1.0);//画笔线的颜色
                    CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:0.0/255 green:97.0/255 blue:174.0/255 alpha:1].CGColor);
                    UIColor*aColor = [UIColor whiteColor]; //点的颜色
                    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
                    CGContextAddArc(context, endPoint.x, endPoint.y, 3, 0, 2*M_PI, 0); //添加一个圆
                    CGContextSetLineWidth(context, 2);
                    CGContextSetLineCap(context, kCGLineCapButt);
                    CGContextDrawPath(context, kCGPathFillStroke);
                    CGContextDrawPath(context, kCGPathFill);//绘制填充

                }
                
                //画点上的文字
                NSString *str = [NSString stringWithFormat:@"%.2f", endValue.floatValue];
                // 判断是不是小数
                if ([self isPureFloat:endValue.floatValue]) {
                    str = [NSString stringWithFormat:@"%.2f", endValue.floatValue];
                }
                else {
                    str = [NSString stringWithFormat:@"%.0f", endValue.floatValue];
                }
                
                NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
                CGSize strSize = [str sizeWithAttributes:attr];
                
                CGRect strRect = CGRectMake(endPoint.x-strSize.width/2,endPoint.y-strSize.height-8,strSize.width,strSize.height);
                
                // 如果点的文字有重叠，那么不绘制
                CGFloat maxX = CGRectGetMaxX(self.firstStrFrame);
                if (i != 0) {
                    if ((maxX + 3) > strRect.origin.x) {
                        //不绘制
                        
                    }else{
                        if ([self.type integerValue] == 2) {
                            [str drawInRect:strRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
                            
                            self.firstStrFrame = strRect;

                        }
                    }
                }else {
                    if (self.firstStrFrame.origin.x < 0) {
                        
                        CGRect frame = self.firstStrFrame;
                        frame.origin.x = 0;
                        self.firstStrFrame = frame;
                    }
                }
                
            }else {
                
                NSNumber *startValue = self.yValueArray[i];
                NSNumber *endValue = self.yValueArray[i+1];
                CGFloat chartHeight = self.frame.size.height - textSize.height - 5 - topMargin;
                
                CGPoint startPoint = CGPointMake((i)*self.pointGap+self.pointGap/2, chartHeight -  (startValue.floatValue-self.yMin)/(self.yMax-self.yMin) * chartHeight+topMargin);
                CGPoint endPoint = CGPointMake((i+1)*self.pointGap+self.pointGap/2, chartHeight -  (endValue.floatValue-self.yMin)/(self.yMax-self.yMin) * chartHeight+topMargin);
                
                CGFloat normal[1]={1};
                CGContextSetLineDash(context,0,normal,0); //画实线
                
                [self drawLine:context startPoint:startPoint endPoint:endPoint lineColor:[UIColor colorWithRed:0/255.0 green:97/255.0 blue:174/255.0 alpha:1] lineWidth:2];
                
                
                //画点
                if ([self.type integerValue] == 2) {
                    UIColor*aColor = [UIColor whiteColor]; //点的颜色
                    //                CGContextSetRGBStrokeColor(context,0.0,97.0,174.0,1.0);//画笔线的颜色
                    CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:0.0/255 green:97.0/255 blue:174.0/255 alpha:1].CGColor);
                    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
                    CGContextAddArc(context, startPoint.x, startPoint.y, 3, 0, 2*M_PI, 0); //添加一个圆
                    CGContextSetLineWidth(context,2);
                    CGContextSetLineCap(context, kCGLineCapRound);
                    CGContextDrawPath(context, kCGPathFillStroke);
                    CGContextDrawPath(context, kCGPathFill);//绘制填充

                }
                [pointArray addObject:[NSValue valueWithCGPoint:startPoint]];
                if (!_isShowLabel) {
                    
                    //画点上的文字
                    NSString *str = [NSString stringWithFormat:@"%.2f", endValue.floatValue];
                    // 判断是不是小数
                    if ([self isPureFloat:startValue.floatValue]) {
                        str = [NSString stringWithFormat:@"%.2f", startValue.floatValue];
                    }
                    else {
                        str = [NSString stringWithFormat:@"%.0f", startValue.floatValue];
                    }
                    
                    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
                    CGSize strSize = [str sizeWithAttributes:attr];
                    
                    CGRect strRect = CGRectMake(startPoint.x-strSize.width/2,startPoint.y-strSize.height-8,strSize.width,strSize.height);
                    if (i == 0) {
                        self.firstStrFrame = strRect;
                        if (strRect.origin.x < 0) {
                            strRect.origin.x = 0;
                        }
                        if ([self.type integerValue] == 2) {
                            [str drawInRect:strRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];

                        }
                    }
                    // 如果点的文字有重叠，那么不绘制
                    CGFloat maxX = CGRectGetMaxX(self.firstStrFrame);
                    //            NSLog(@"%f   %f",maxX,strRect.origin.x);
                    if (i != 0) {
                        if ((maxX + 3) > strRect.origin.x) {
                            //不绘制
                            
                        }else{
                            if ([self.type integerValue] == 2) {
                                [str drawInRect:strRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kChartTextColor}];
                                
                                self.firstStrFrame = strRect;

                            }
                        }
                    }else {
                        if (self.firstStrFrame.origin.x < 0) {
                            
                            CGRect frame = self.firstStrFrame;
                            frame.origin.x = 0;
                            self.firstStrFrame = frame;
                        }
                    }
                }
            }
        }
        [pointArray addObject:[NSValue valueWithCGPoint:ranPoint]];
    }
    if ([self.type integerValue] == 1) {
        [self drawGradient];
    }
    
    //长按时进入
    if(self.isLongPress)
    {
        NSLog(@"%f",_currentLoc.x/self.pointGap);
        int nowPoint = _currentLoc.x/self.pointGap;
        if(nowPoint >= 0 && nowPoint < [self.yValueArray count]) {
            
            NSNumber *num = [self.yValueArray objectAtIndex:nowPoint];
            CGFloat chartHeight = self.frame.size.height - textSize.height - 5 - topMargin;
            
            CGPoint selectPoint = CGPointMake((nowPoint)*self.pointGap+self.pointGap/2, chartHeight -  (num.floatValue-self.yMin)/(self.yMax-self.yMin) * chartHeight+topMargin);
            
            //            NSLog(@"_screenLoc=%@",NSStringFromCGPoint(_screenLoc));
            //            NSLog(@"_currentLoc=%@",NSStringFromCGPoint(_currentLoc));
            
            // 显示的时间和水位
            //            CGContextSetFillColorWithColor(context, [UIColor greenColor].CGColor);
            //            CGContextSetStrokeColorWithColor(context, [UIColor greenColor].CGColor);
            CGContextSaveGState(context);
            
            
            //            NSString *timeStr = ;
            NSDictionary *timeAttr = @{NSFontAttributeName : [UIFont systemFontOfSize:12]};
            CGSize timeSize = [[NSString stringWithFormat:@"时间:%@",self.xTitleArray[nowPoint]] sizeWithAttributes:timeAttr];
            
            
            //画文字所在的位置  动态变化
            CGPoint drawPoint = CGPointZero;
            if(_screenLoc.x >((kScreenWidth-leftMargin)/2) && _screenLoc.y < 80) {
                //如果按住的位置在屏幕靠右边边并且在屏幕靠上面的地方   那么字就显示在按住位置的左上角40 60位置
                drawPoint = CGPointMake(_currentLoc.x-40-timeSize.width, 80-60);
            }
            else if(_screenLoc.x >((kScreenWidth-leftMargin)/2) && _screenLoc.y > self.frame.size.height-20) {
                drawPoint = CGPointMake(_currentLoc.x-40-timeSize.width, self.frame.size.height-20 -60);
            }
            else if(_screenLoc.x >((kScreenWidth-leftMargin)/2)) {
                //如果按住的位置在屏幕靠右边边   那么字就显示在按住位置的左上角40 60位置
                drawPoint = CGPointMake(_currentLoc.x-40-timeSize.width, _currentLoc.y-60);
            }
            else if (_screenLoc.x <= ((kScreenWidth-leftMargin)/2) && _screenLoc.y < 80) {
                //如果按住的位置在屏幕靠左边边并且在屏幕靠上面的地方   那么字就显示在按住位置的右上角上角40 40位置
                drawPoint = CGPointMake(_currentLoc.x+40, 80-60);
                
            }
            else if (_screenLoc.x <= ((kScreenWidth-leftMargin)/2) && _screenLoc.y > self.frame.size.height-20) {
                
                drawPoint = CGPointMake(_currentLoc.x+40, self.frame.size.height-20 -60);
                
            }
            else if(_screenLoc.x  <= ((kScreenWidth-leftMargin)/2)) {
                //如果按住的位置在屏幕靠左边   那么字就显示在按住位置的右上角40 60位置
                drawPoint = CGPointMake(_currentLoc.x+40, _currentLoc.y-60);
            }
            
            
            //画选中的数值
            [[NSString stringWithFormat:@"时间：%@",self.xTitleArray[nowPoint]] drawAtPoint:CGPointMake(drawPoint.x, drawPoint.y) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.0/255 green:97.0/255 blue:174.0/255 alpha:1]}];
            
            
            // 判断是不是小数
            if ([self isPureFloat:[num floatValue]]) {
                [[NSString stringWithFormat:@"价格：%.2f", [num floatValue]] drawAtPoint:CGPointMake(drawPoint.x, drawPoint.y+15) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.0/255 green:97.0/255 blue:174.0/255 alpha:1]}];
            }
            else {
                [[NSString stringWithFormat:@"价格：%.0f", [num floatValue]] drawAtPoint:CGPointMake(drawPoint.x, drawPoint.y+15)withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor colorWithRed:0.0/255 green:97.0/255 blue:174.0/255 alpha:1]}];
                
            }
            
            
            //画十字线
            //            CGContextRestoreGState(context);
            //            CGContextSetLineWidth(context, 1);
            //            CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
            //            CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
            //
            ////            // 选中横线
            ////            CGContextMoveToPoint(context, 0, selectPoint.y);
            ////            CGContextAddLineToPoint(context, self.frame.size.width, selectPoint.y);
            //
            //            // 选中竖线
            //            CGContextMoveToPoint(context, selectPoint.x, 0);
            //            CGContextAddLineToPoint(context, selectPoint.x, self.frame.size.height- textSize.height - 5);
            //
            //            CGContextStrokePath(context);
            
            [self drawLine:context startPoint:CGPointMake(selectPoint.x, 0) endPoint:CGPointMake(selectPoint.x, self.frame.size.height- textSize.height - 5) lineColor:[UIColor colorWithRed:0.0/255 green:97.0/255 blue:174.0/255 alpha:1] lineWidth:1];
            
            // 交界点
            CGRect myOval = {selectPoint.x-2, selectPoint.y-2, 4, 4};
            CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.0/255 green:97.0/255 blue:174.0/255 alpha:1].CGColor);
            CGContextAddEllipseInRect(context, myOval);
            CGContextFillPath(context);
        }
    }
    
    
    
}

- (void)drawLine:(CGContextRef)context startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint lineColor:(UIColor *)lineColor lineWidth:(CGFloat)width {
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);
}

#pragma mark 渐变阴影
- (void)drawGradient {
    CGPoint startPoint=[pointArray[0] CGPointValue];

    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0/255.0 green:97/255.0 blue:174/255.0 alpha:0.8].CGColor,(__bridge id)[UIColor colorWithWhite:1 alpha:0.1].CGColor];

    _gradientLayer.locations=@[@0.0,@1.0];
    _gradientLayer.startPoint = CGPointMake(0.0,0.0);
    _gradientLayer.endPoint = CGPointMake(0.0,1);

    UIBezierPath *gradientPath = [[UIBezierPath alloc] init];
    [gradientPath moveToPoint:CGPointMake(startPoint.x, self.frame.size.width + startPoint.y)];

    for (int i = 0; i < pointArray.count; i ++) {
        [gradientPath addLineToPoint:[pointArray[i] CGPointValue]];
    }

    CGPoint endPoint = [[pointArray lastObject] CGPointValue];
    endPoint = CGPointMake(endPoint.x, self.frame.size.width + startPoint.y);
    [gradientPath addLineToPoint:endPoint];
    CAShapeLayer *arc = [CAShapeLayer layer];
    arc.path = gradientPath.CGPath;
    _gradientLayer.mask = arc;
    [self.layer addSublayer:_gradientLayer];

}


// 判断是小数还是整数
- (BOOL)isPureFloat:(CGFloat)num {
    int i = num;
    
    CGFloat result = num - i;
    
    // 当不等于0时，是小数
    return result != 0;
}


@end
