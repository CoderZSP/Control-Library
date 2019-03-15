//
//  UIColor+ColorChange.h
//  Control-Library
//
//  Created by zhangsp on 2019/2/15.
//  Copyright © 2019 zhangsp. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIColor(ColorChange)

// 颜色转换：iOS中（以#开头）十六进制的颜色转换为UIColor(RGB)
+ (UIColor *)colorWithHexString: (NSString *)color;

+ (UIColor *)colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;

@end
