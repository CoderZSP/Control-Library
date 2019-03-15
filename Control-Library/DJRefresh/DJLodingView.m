//
//  DJLodingView.m
//  Control-Library
//
//  Created by zhangsp on 2019/2/26.
//  Copyright © 2019 zhangsp. All rights reserved.
//

#import "DJLodingView.h"

#define SPACE 20.0
#define BALL_WIDTH 12.0
#define SEGMENT_TIME 0.5
#define ANIMATION_DURATION 2.0
#define CIRCLE_NUM 4
#define MainColor [UIColor colorWithRed:24.0/255.0 green:134.0/255.0 blue:227.0/255.0 alpha:1.0]
@interface DJLodingView ()<CAAnimationDelegate>

@property (nonatomic, strong) NSMutableArray<CALayer*> *circleArray;
@property (nonatomic, assign) NSInteger ballIndex; // 移动的index
@end
@implementation DJLodingView

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }
    return _titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _circleArray = [NSMutableArray array];
        
        self.backgroundColor = [UIColor clearColor];
        CGFloat circleX = (frame.size.width - CIRCLE_NUM*SPACE - BALL_WIDTH)/2 + BALL_WIDTH/2.0 ;
        CGFloat circleY = frame.size.height/2;
        
        for (int i = 0; i < 5; i++) {
            CALayer *circle = [CALayer layer];
            circle.bounds = CGRectMake(0, 0, BALL_WIDTH, BALL_WIDTH);
            circle.position = CGPointMake(circleX, circleY);
            circle.backgroundColor = MainColor.CGColor;
            circle.cornerRadius = circle.bounds.size.height / 2;
            [self.layer addSublayer:circle];
            [_circleArray addObject:circle];
            
            circleX += SPACE;
        }
        self.titleLabel.textColor = MainColor;
        self.titleLabel.text = @"疯狂加载中...";
        [self.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        CGFloat ballX = (self.frame.size.width - CIRCLE_NUM*SPACE - BALL_WIDTH)/2 + BALL_WIDTH/2.0;
        CGFloat ballY = self.frame.size.height/2;
        
        self.titleLabel.frame = CGRectMake(ballX, ballY + SPACE, _circleArray.count * SPACE, SPACE);
        [self addSubview:self.titleLabel];
        _ballIndex = 0;
        [self addAnimation];
    }
    return self;
}

- (void)addAnimation {
    CGMutablePathRef ballPath = CGPathCreateMutable();
    if (_ballIndex >= _circleArray.count-1) {
        _ballIndex = 0;
    }
    CGFloat ballX = (self.frame.size.width - CIRCLE_NUM*SPACE - BALL_WIDTH)/2 + BALL_WIDTH/2.0 + _ballIndex*SPACE;
    CGFloat ballY = self.frame.size.height/2;
    CGPathMoveToPoint(ballPath,NULL,ballX,ballY);
    
    for (int i = 0; i < 1; i++) {
        ballX += SPACE;
        CGPathAddLineToPoint(ballPath, NULL, ballX, ballY );
    }
    CAKeyframeAnimation * ballAnimation;
    //创建一个动画对象，指定位置属性作为键路径
    ballAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    ballAnimation.path=ballPath;
    ballAnimation.duration = ANIMATION_DURATION/_circleArray.count;
    ballAnimation.delegate = self;
    ballAnimation.removedOnCompletion = NO;
    ballAnimation.fillMode = kCAFillModeForwards;
    ballAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CGPathRelease(ballPath);
    // 为图层添加动画
    [_circleArray[_ballIndex] removeAllAnimations];
    [_circleArray[_ballIndex] addAnimation:ballAnimation forKey:@"ball"];
    
    CALayer* circleLayer = nil;
    NSInteger index = _ballIndex +1;
    circleLayer = _circleArray[index];
    // 椭圆
    //短半轴和长半轴的比例
    float radiuscale = 1.8;
    //椭圆顶点的坐标值
    CGFloat origin_x = ballX - SPACE/2;
    CGFloat origin_y = ballY;
    //长半轴的长
    CGFloat radiusX = SPACE/2;
    CGMutablePathRef circlePath = CGPathCreateMutable();
    CGAffineTransform t2 = CGAffineTransformConcat(CGAffineTransformConcat(
                                                                           CGAffineTransformMakeTranslation(-origin_x, -origin_y),
                                                                           CGAffineTransformMakeScale(1, radiuscale)),
                                                   CGAffineTransformMakeTranslation(origin_x, origin_y));
    CGPathAddArc(circlePath, &t2, origin_x, origin_y, radiusX,0,M_PI, 1);
    
    CAKeyframeAnimation * circleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    circleAnimation.path = circlePath;
    CGFloat totalTime = ANIMATION_DURATION / _circleArray.count;
    CGFloat segmentTime = totalTime * (M_PI * SPACE / 2) / (M_PI * SPACE / 2);
    
    circleAnimation.duration = segmentTime;
    circleAnimation.beginTime = CACurrentMediaTime();
    CGPathRelease(circlePath);
    circleAnimation.removedOnCompletion = NO;
    circleAnimation.fillMode = kCAFillModeForwards;
    
    [circleLayer removeAllAnimations];
    // 为图层添加动画
    [circleLayer addAnimation:circleAnimation forKey:@"circle"];
    // 交换位置
    [_circleArray exchangeObjectAtIndex:_ballIndex withObjectAtIndex:_ballIndex+1];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    _ballIndex++;
    if (_ballIndex == _circleArray.count) {
        _ballIndex = 0;
    }
    
    if (_ballIndex <= _circleArray.count && self.superview) {
        [self addAnimation];
    }else{
        for (CALayer* layer in _circleArray) {
            [layer removeFromSuperlayer];
            [layer removeAllAnimations];
        }
    }
}

-(void)hideLoding
{
    [self removeFromSuperview];
}

@end
