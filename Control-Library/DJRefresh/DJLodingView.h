//
//  DJLodingView.h
//  Control-Library
//
//  Created by zhangsp on 2019/2/26.
//  Copyright © 2019 zhangsp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DJLodingView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
-(void)hideLoding;
@end

NS_ASSUME_NONNULL_END
