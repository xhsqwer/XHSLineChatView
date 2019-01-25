//
//  XHSLineChatView.h
//  WSLineChart
//
//  Created by Hongshuo Xiao on 2019/1/24.
//  Copyright © 2019 zws. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XHSLineChatView : UIView

- (id)initWithFrame:(CGRect)frame xTitleArray:(NSArray*)xTitleArray yValueArray:(NSArray*)yValueArray yMax:(CGFloat)yMax yMin:(CGFloat)yMin type:(NSString *) type;

@end

NS_ASSUME_NONNULL_END
