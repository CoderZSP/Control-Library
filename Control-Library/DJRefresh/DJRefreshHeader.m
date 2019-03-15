//
//  DJRefreshHeader.m
//  Control-Library
//
//  Created by zhangsp on 2019/2/19.
//  Copyright © 2019 zhangsp. All rights reserved.
//


#import "DJRefreshHeader.h"
#import "UIView+Extension.h"
#define MainColor [UIColor colorWithRed:24.0/255.0 green:134.0/255.0 blue:227.0/255.0 alpha:1.0]
static CGFloat const kLineWidth = 7.0;
static CGFloat const kLineCount = 5;
static CGFloat const kLinePending = 5.0;
static CGFloat const kLineHeight = kLineWidth;
@interface DJRefreshHeader ()

/// 主视图.
@property(nonatomic, weak) UIView *animatedView;
/// 下拉层.
@property(nonatomic, weak) CAShapeLayer *pullingLayer1;
@property(nonatomic, weak) CAShapeLayer *pullingLayer2;
@property(nonatomic, weak) CAShapeLayer *pullingLayer3;
@property(nonatomic, weak) CAShapeLayer *pullingLayer4;
@property(nonatomic, weak) CAShapeLayer *pullingLayer5;


@property (strong, nonatomic) CAShapeLayer *firstPointLayer;
@property (strong, nonatomic) CAShapeLayer *secondPointLayer;
@property (strong, nonatomic) CAShapeLayer *thirdPointLayer;
@property (strong, nonatomic) CAShapeLayer *fourthPointLayer;
@property (strong, nonatomic) CAShapeLayer *fifthPointLayer;
@end

@implementation DJRefreshHeader

#pragma mark - 懒加载子控件

-(CAShapeLayer *)firstPointLayer{
    if (!_firstPointLayer) {
        _firstPointLayer = [CAShapeLayer layer];
        [self.animatedView.layer addSublayer:_firstPointLayer];
    }
    return _firstPointLayer;
}

-(CAShapeLayer *)secondPointLayer{
    if (!_secondPointLayer) {
        _secondPointLayer = [CAShapeLayer layer];
        [self.animatedView.layer addSublayer:_secondPointLayer];
    }
    return _secondPointLayer;
}

-(CAShapeLayer *)thirdPointLayer{
    if (!_thirdPointLayer) {
        _thirdPointLayer = [CAShapeLayer layer];
        [self.animatedView.layer addSublayer:_thirdPointLayer];
    }
    return _thirdPointLayer;
}

-(CAShapeLayer *)fourthPointLayer{
    if (!_fourthPointLayer) {
        _fourthPointLayer = [CAShapeLayer layer];
        [self.animatedView.layer addSublayer:_fourthPointLayer];
    }
    return _fourthPointLayer;
}

-(CAShapeLayer *)fifthPointLayer{
    if (!_fifthPointLayer) {
        _fifthPointLayer = [CAShapeLayer layer];
        [self.animatedView.layer addSublayer:_fifthPointLayer];
    }
    return _fifthPointLayer;
}

/** 主视图 */
- (UIView *)animatedView {
    if (!_animatedView) {
        UIView *animatedView = [[UIView alloc]init];
        [animatedView setBackgroundColor:[UIColor clearColor]];
        _animatedView = animatedView;
        [self addSubview:_animatedView];
    }
    return _animatedView;
}

- (CAShapeLayer *)pullingLayer1 {
    if (!_pullingLayer1) {
        _pullingLayer1 = [self setupPullLayer];
        [self.animatedView.layer addSublayer:_pullingLayer1];
    }
    return _pullingLayer1;
}
- (CAShapeLayer *)pullingLayer2 {
    if (!_pullingLayer2) {
        _pullingLayer2 = [self setupPullLayer];
        [self.animatedView.layer addSublayer:_pullingLayer2];
    }
    return _pullingLayer2;
}
- (CAShapeLayer *)pullingLayer3 {
    if (!_pullingLayer3) {
        _pullingLayer3 = [self setupPullLayer];
        [self.animatedView.layer addSublayer:_pullingLayer3];
    }
    return _pullingLayer3;
}
- (CAShapeLayer *)pullingLayer4 {
    if (!_pullingLayer4) {
        _pullingLayer4 = [self setupPullLayer];
        [self.animatedView.layer addSublayer:_pullingLayer4];
    }
    return _pullingLayer4;
}

- (CAShapeLayer *)pullingLayer5 {
    if (!_pullingLayer5) {
        _pullingLayer5 = [self setupPullLayer];
        [self.animatedView.layer addSublayer:_pullingLayer5];
    }
    return _pullingLayer5;
}

-(CAShapeLayer *)setupPullLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = MainColor.CGColor;
    layer.backgroundColor = MainColor.CGColor;
    layer.contentsScale = [[UIScreen mainScreen] scale];
    layer.lineCap = kCALineCapRound;
    layer.lineWidth = kLineWidth;
    return layer;
}

#pragma mark - 公共方法
- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    self.pullingLayer1.strokeColor = tintColor.CGColor;
    self.pullingLayer2.strokeColor = tintColor.CGColor;
    self.pullingLayer3.strokeColor = tintColor.CGColor;
    self.pullingLayer4.strokeColor = tintColor.CGColor;
    self.pullingLayer5.strokeColor = tintColor.CGColor;
}

#pragma mark - 重写父类的方法
- (void)prepare {
    [super prepare];
    if (self.tintColor == nil) {
        self.tintColor = MainColor;
    }
    
    //根据拖拽的情况自动切换透明度
    self.automaticallyChangeAlpha = NO;
    
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    
    //设置文字颜色
    self.stateLabel.textColor = MainColor;
    self.stateLabel.hidden = YES;
}

- (void)placeSubviews {
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;
    if (!self.stateLabel.hidden) {
        CGFloat stateWidth = self.stateLabel.mj_textWith;
        CGFloat timeWidth = 0.0;
        if (!self.lastUpdatedTimeLabel.hidden) {
            timeWidth = self.lastUpdatedTimeLabel.mj_textWith;
        }
        CGFloat textWidth = MAX(stateWidth, timeWidth);
        arrowCenterX -= textWidth / 2 + self.labelLeftInset;
    }
    CGFloat arrowCenterY = self.mj_h * 0.5;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    self.animatedView.bounds = CGRectMake(0, 0, 90, 60);
    self.animatedView.center = arrowCenter;
    CGFloat pullX = (self.animatedView.width - (kLineCount * kLineWidth) - (kLineCount - 1) * kLinePending)/2;
    
    CGFloat pullY = (self.animatedView.height-kLineWidth)/2;
    /// 下拉动画.
        self.pullingLayer1.frame = self.pullingLayer2.frame = self.pullingLayer3.frame = self.pullingLayer4.frame = self.pullingLayer5.frame = CGRectMake(pullX + kLineWidth/2, pullY, 0, 0);
        CGFloat pathX1 = 0;
        UIBezierPath *path1 = [UIBezierPath bezierPath];
        [path1 moveToPoint:CGPointMake(0, 0)];
        [path1 addLineToPoint:CGPointMake(0, kLineHeight)];
        self.pullingLayer1.path = path1.CGPath;
        
        CGFloat pathX2 = pathX1 + kLineWidth + kLinePending;
        UIBezierPath *path2 = [UIBezierPath bezierPath];
        [path2 moveToPoint:CGPointMake(pathX2, 0)];
        [path2 addLineToPoint:CGPointMake(pathX2, kLineHeight)];
        self.pullingLayer2.path = path2.CGPath;
        
        CGFloat pathX3 = pathX2 + kLineWidth + kLinePending;
        UIBezierPath *path3 = [UIBezierPath bezierPath];
        [path3 moveToPoint:CGPointMake(pathX3, 0)];
        [path3 addLineToPoint:CGPointMake(pathX3, kLineHeight)];
        self.pullingLayer3.path = path3.CGPath;
        
        CGFloat pathX4 = pathX3 + kLineWidth + kLinePending;
        UIBezierPath *path4 = [UIBezierPath bezierPath];
        [path4 moveToPoint:CGPointMake(pathX4, 0)];
        [path4 addLineToPoint:CGPointMake(pathX4, kLineHeight)];
        self.pullingLayer4.path = path4.CGPath;
        
        CGFloat pathX5 = pathX4 + kLineWidth + kLinePending;
        UIBezierPath *path5 = [UIBezierPath bezierPath];
        [path5 moveToPoint:CGPointMake(pathX5, 0)];
        [path5 addLineToPoint:CGPointMake(pathX5, kLineHeight)];
        self.pullingLayer5.path = path5.CGPath;

    // 底部的点
    CGPoint firstPoint = CGPointMake(pullX, pullY + kLineHeight);
    self.firstPointLayer = [self layerWithPoint:firstPoint color:MainColor.CGColor layer:self.firstPointLayer];
    CGPoint secondPoint = CGPointMake(firstPoint.x + kLineWidth + kLinePending, pullY + kLineHeight);
    self.secondPointLayer = [self layerWithPoint:secondPoint color:MainColor.CGColor layer:self.secondPointLayer];
    
    CGPoint thirdPoint = CGPointMake(secondPoint.x + kLineWidth + kLinePending, pullY + kLineHeight);
    self.thirdPointLayer = [self layerWithPoint:thirdPoint color:MainColor.CGColor layer:self.thirdPointLayer];
    
    CGPoint fourthPoint = CGPointMake(thirdPoint.x + kLineWidth + kLinePending, pullY + kLineHeight);
    self.fourthPointLayer = [self layerWithPoint:fourthPoint color:MainColor.CGColor layer:self.fourthPointLayer];
    
    CGPoint fifthPoint = CGPointMake(fourthPoint.x + kLineWidth + kLinePending, pullY + kLineHeight);
    self.fifthPointLayer = [self layerWithPoint:fifthPoint color:MainColor.CGColor layer:self.fifthPointLayer];

}
- (CAShapeLayer *)layerWithPoint:(CGPoint)center color:(CGColorRef)color layer:(CAShapeLayer *)layer{
    CGFloat raidusValue = kLineWidth / 2;
    layer.frame = CGRectMake(center.x , center.y - raidusValue, raidusValue * 2, raidusValue * 2);
    layer.fillColor = color;
    layer.path = [self pointPath];
    return layer;
}

- (CGPathRef)pointPath {
    CGFloat raidusValue = kLineWidth / 2;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(raidusValue, raidusValue) radius:raidusValue startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
}
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState
    
    // 根据状态做事情
    [super setState:state];
    if (state == MJRefreshStateIdle) {
        [self setupPullHidden:NO];
        if (oldState == MJRefreshStateRefreshing) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJRefreshFastAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self removeRefreshAnimation];
            });
        }
    } else if (state == MJRefreshStatePulling) {
//        [self removeRefreshAnimation];
        [self setupPullHidden:NO];
    } else if (state == MJRefreshStateRefreshing) {
        [self startRefreshAnimation];
        [self setupPullHidden:NO];
    }
}


-(void)setupPullHidden:(BOOL)hidden
{
    self.pullingLayer1.hidden = hidden;
    self.pullingLayer2.hidden = hidden;
    self.pullingLayer3.hidden = hidden;
    self.pullingLayer4.hidden = hidden;
    self.pullingLayer5.hidden = hidden;
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
    CGFloat durationDraw = 0.2;
    CGFloat separateTime = (1 - durationDraw*2) / 4;
    CGFloat percent = self.pullingPercent;
    self.pullingLayer1.strokeEnd = percent >=durationDraw? 1:percent/durationDraw;
    self.pullingLayer1.strokeStart = percent>=(2*durationDraw)?1:(percent >= durationDraw?((percent-durationDraw)/durationDraw) : 0);
    self.pullingLayer1.opacity = self.pullingLayer1.strokeEnd;
    self.pullingLayer2.strokeEnd = percent <separateTime? 0 : (percent <=(separateTime + durationDraw)? ((percent - separateTime)/durationDraw):1);
    self.pullingLayer2.strokeStart = percent>=(2*durationDraw + separateTime)?1:(percent >= (durationDraw + separateTime)?((percent-durationDraw - separateTime)/durationDraw) : 0);
    self.pullingLayer2.opacity = self.pullingLayer2.strokeEnd;
    
    self.pullingLayer3.strokeEnd = percent <(separateTime*2)? 0 : (percent <=(separateTime*2 + durationDraw)? ((percent - separateTime*2)/durationDraw):1);
    self.pullingLayer3.strokeStart = percent>=(2*durationDraw + separateTime *2)?1:(percent >= (durationDraw + separateTime*2)?((percent-durationDraw - separateTime*2)/durationDraw) : 0);
    self.pullingLayer3.opacity = self.pullingLayer3.strokeEnd;
    
    self.pullingLayer4.strokeEnd = percent <(separateTime*3)? 0 : (percent <=(separateTime*3 + durationDraw)? ((percent - separateTime*3)/durationDraw):1);
    self.pullingLayer4.strokeStart = percent>=(2*durationDraw + separateTime *3)?1:(percent >= (durationDraw + separateTime*3)?((percent-durationDraw - separateTime*3)/durationDraw) : 0);
    self.pullingLayer4.opacity = self.pullingLayer4.strokeEnd;
    
    self.pullingLayer5.strokeEnd = percent <(separateTime*4)? 0 : (percent <=(separateTime*4 + durationDraw)? ((percent - separateTime*4)/durationDraw):1);
    self.pullingLayer5.strokeStart = percent>=(2*durationDraw + separateTime*4)?1:(percent >= (durationDraw + separateTime*4)?((percent-durationDraw - separateTime*4)/durationDraw) : 0);
    self.pullingLayer5.opacity = self.pullingLayer5.strokeEnd;
    self.firstPointLayer.hidden = percent >=0.2? NO:YES;
    self.secondPointLayer.hidden = percent >=0.4? NO:YES;
    self.thirdPointLayer.hidden = percent >=0.6? NO:YES;;
    self.fourthPointLayer.hidden = percent >=0.8? NO:YES;
    self.fifthPointLayer.hidden = percent >=1.0? NO:YES;;
    
}

/** 开始刷新动画 */
- (void)startRefreshAnimation {
    NSLog(@"startRefreshAnimation");
    
    CGFloat separateTime = 0.1;
//    CFTimeInterval time = [self.pullingLayer1 convertTime:CACurrentMediaTime() fromLayer:nil];
    CAAnimationGroup *group1 = [self animationToLayer:self.firstPointLayer];
    [group1 setBeginTime:CACurrentMediaTime()];
    [self.firstPointLayer addAnimation:group1 forKey:@"animation"];
    
    CAAnimationGroup *group2 = [self animationToLayer:self.secondPointLayer];
    [group2 setBeginTime:separateTime + CACurrentMediaTime()];
    [self.secondPointLayer addAnimation:group2 forKey:@"animation"];
    
    CAAnimationGroup *group3 = [self animationToLayer:self.thirdPointLayer];
    [group3 setBeginTime:separateTime*2 + CACurrentMediaTime()];
    [self.thirdPointLayer addAnimation:group3 forKey:@"animation"];
    CAAnimationGroup *group4 = [self animationToLayer:self.fourthPointLayer];
    [group4 setBeginTime:separateTime*3 + CACurrentMediaTime()];
    [self.fourthPointLayer addAnimation:group4 forKey:@"animation"];
    CAAnimationGroup *group5 = [self animationToLayer:self.fifthPointLayer];
    [group5 setBeginTime:separateTime*4 + CACurrentMediaTime()];
    [self.fifthPointLayer addAnimation:group5 forKey:@"animation"];
}

-(CAAnimationGroup *)animationToLayer:(CAShapeLayer *)layer
{
    CGFloat durationTime = 0.2;
    CABasicAnimation *basicAnimation = [self animationKeyPath:@"position.y"
                                                         from:@(layer.position.y)
                                                           to:@(layer.position.y-7)
                                                     duration:durationTime
                                                   repeatTime:INFINITY];
    basicAnimation.autoreverses = YES;
    [basicAnimation setBeginTime:0.0];
    
    CABasicAnimation *basicAnimation1 = [self animationKeyPath:@"position.y"
                                                          from:@(layer.position.y-7)
                                                            to:@(layer.position.y)
                                                      duration:durationTime
                                                    repeatTime:INFINITY];
    basicAnimation1.autoreverses = YES;
    [basicAnimation1 setBeginTime:durationTime];
    CABasicAnimation *basicAnimation2 = [self animationKeyPath:@"position.y"
                                                          from:@(layer.position.y)
                                                            to:@(layer.position.y)
                                                      duration:durationTime*2
                                                    repeatTime:INFINITY];
    basicAnimation2.autoreverses = YES;
    [basicAnimation2 setBeginTime:durationTime*2];
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration:durationTime*4];
    [group setAnimations:[NSArray arrayWithObjects:basicAnimation,basicAnimation1, basicAnimation2, nil]];
    group.repeatCount = INFINITY;
    return group;
}


- (CABasicAnimation *)animationKeyPath:(NSString *)keyPath
                                  from:(NSNumber *)fromValue
                                    to:(NSNumber *)toValue
                              duration:(CFTimeInterval)duration
                            repeatTime:(CGFloat)repeat {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = duration;
    animation.repeatCount = repeat;
    animation.removedOnCompletion = NO;
    return animation;
}
/** 移除刷新动画 */
- (void)removeRefreshAnimation {
    [self.firstPointLayer removeAllAnimations];
    self.firstPointLayer.hidden = YES;
    [self.secondPointLayer removeAllAnimations];
    self.secondPointLayer.hidden = YES;
    [self.thirdPointLayer removeAllAnimations];
    self.thirdPointLayer.hidden = YES;
    [self.fourthPointLayer removeAllAnimations];
    self.fourthPointLayer.hidden = YES;
    [self.fifthPointLayer removeAllAnimations];
    self.fifthPointLayer.hidden = YES;
    
}

@end

