//
//  ViewController.m
//  Control-Library
//
//  Created by zhangsp on 2019/2/15.
//  Copyright © 2019 zhangsp. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Extension.h"
#define TOPWATERDROP_W 15.0f
#define TOPWATERDROP_ASSISTANCE_W 13.0f
#define radius_1 (TOPWATERDROP_ASSISTANCE_W/2 + 2)
#define radius_2 TOPWATERDROP_ASSISTANCE_W/2
@interface ViewController ()<CAAnimationDelegate,UICollisionBehaviorDelegate>
{
    UIDynamicAnimator * _animator;
    UIGravityBehavior * _gravity;
    UICollisionBehavior *_collision;
}
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

//top water
@property (strong, nonatomic) CAShapeLayer *topWaterLayer;
@property (strong, nonatomic) UIView *topWaterDrop;
@property (strong, nonatomic) UIView *topWaterDropAssistance;   //上面的水平复时的辅助 view

@property (strong, nonatomic) UIDynamicItemBehavior *topWaterDropBehavior;

@property (strong, nonatomic) CADisplayLink *topWaterDropFallDisplayLink;
@property (strong, nonatomic) CADisplayLink *topWaterDropBackDisplayLink;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    
    [self setupTopWater];
}

- (void)setupTopWater
{
    _topWaterLayer = [CAShapeLayer layer];
    _topWaterLayer.frame = CGRectMake(0, 240 + 44, self.loginBtn.frame.size.width, 0);
    _topWaterLayer.backgroundColor = [UIColor whiteColor].CGColor;
    _topWaterLayer.fillColor = [UIColor clearColor].CGColor;
    _topWaterLayer.strokeColor = [UIColor whiteColor].CGColor;
    [self.view.layer addSublayer:_topWaterLayer];
    
    //display link
    _topWaterDropFallDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onTopWaterDropFallDisplayLink:)];
    _topWaterDropFallDisplayLink.paused = YES;
    [_topWaterDropFallDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    _topWaterDropBackDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onTopWaterDropBackDisplayLink:)];
    _topWaterDropBackDisplayLink.paused = YES;
    [_topWaterDropBackDisplayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    
    
    CGFloat width = TOPWATERDROP_W;
    _topWaterDrop = [[UIView alloc] initWithFrame:CGRectMake(0,240 + 44 - width , width, width)];
    [self.view addSubview:_topWaterDrop];
    _topWaterDrop.centerX = self.view.frame.size.width /2;
    _topWaterDrop.backgroundColor = [UIColor whiteColor];
    _topWaterDrop.alpha = 0;
    
    self.topWaterDropAssistance = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TOPWATERDROP_ASSISTANCE_W, TOPWATERDROP_ASSISTANCE_W)];
    self.topWaterDropAssistance.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:(42.0/255.00) green:(143.0/255.00) blue:(228.0/255.00) alpha:1];//
    self.topWaterDropAssistance.center = CGPointMake(self.loginBtn.center.x, (240 + 44)-TOPWATERDROP_ASSISTANCE_W/2);
    [self.view addSubview:self.topWaterDropAssistance];
    // layer
    CGFloat lineWidth = 2;
    CGFloat diameter = width - lineWidth*2;
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(lineWidth, lineWidth, diameter, diameter)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.fillColor = [UIColor clearColor].CGColor;
    maskLayer.strokeColor = [UIColor whiteColor].CGColor;
    maskLayer.lineWidth = lineWidth;
    maskLayer.path = path.CGPath;
    
    _topWaterDrop.layer.mask = maskLayer;
    
}

- (IBAction)loginClick:(UIButton *)sender {
    
    // 登录动画
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint center = sender.center;
        sender.width = 40;
        sender.height = 40;
        sender.center = center;
        sender.titleLabel.alpha = 0;
    } completion:^(BOOL finished) {
        CABasicAnimation* base=[self rotation:0.5 degree:M_PI repeatCount:1.0];
        [sender.layer addAnimation:base forKey:@"rotation"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self->_animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
            self->_gravity = [[UIGravityBehavior alloc] initWithItems:@[self->_topWaterDrop]];
            [self->_animator addBehavior:self->_gravity];
            
            //碰撞检测行为
            self->_collision = [[UICollisionBehavior alloc]initWithItems:@[self->_topWaterDrop]];
            
            //开启参考边界
            self->_collision.translatesReferenceBoundsIntoBoundary = YES;
            
            [self->_collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(0, 0, 70, 0)];
            self->_collision.collisionDelegate = self;
            [self->_animator addBehavior:self->_collision];
            self->_topWaterDropFallDisplayLink.paused = NO;
        });
        
    }];
}
- (CABasicAnimation *)rotation:(float)dur degree:(float)degree  repeatCount:(int)repeatCount {
    CABasicAnimation *theAnimation;
    theAnimation=[CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    theAnimation.duration=dur;
    theAnimation.cumulative= NO;
    theAnimation.removedOnCompletion = YES;
    theAnimation.fromValue = @(0);
    theAnimation.toValue = @(degree);
    theAnimation.repeatCount=repeatCount;
    theAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    theAnimation.delegate = self;
    return  theAnimation;
}


#pragma mark - Action
// 下落
- (void)onTopWaterDropFallDisplayLink:(CADisplayLink *)displayLink
{
    if ((_topWaterDrop.origin.y - 240 - 44) < 0) {
        return;
    }
    _topWaterDrop.alpha = 1.0f;
    if ((_topWaterDrop.origin.y - 240 - 44) > TOPWATERDROP_W/2) {
        _topWaterDropFallDisplayLink.paused = YES;
        self.topWaterDropAssistance.center = _topWaterDrop.center;
        [UIView animateWithDuration:0.5f animations:^{
            self.topWaterDropAssistance.center = CGPointMake(self.loginBtn.centerX, 240 + 44 - self.topWaterDropAssistance.height/2);
        }];
        
        _topWaterDrop.alpha = 1.0f;
        self.topWaterDropBackDisplayLink.paused = NO;
        
    } else {
        [self drawTopWaterWhenFall];
    }
}

// 回弹
- (void)onTopWaterDropBackDisplayLink:(CADisplayLink *)displayLink
{
    CGPoint assistancePoint = [[self.topWaterDropAssistance.layer.presentationLayer valueForKey:@"position"] CGPointValue];

    if (assistancePoint.y <= (240 + 44 )) {
        self.topWaterDropBackDisplayLink.paused = YES;
        self.topWaterLayer.hidden = YES;
    } else {
        [self drawTopWaterWhenBack];
    }
}


// 水滴回弹
- (void)drawTopWaterWhenBack
{
    NSLog(@"----drawTopWaterWhenBack");
    CGPoint assistancePoint = [[self.topWaterDropAssistance.layer.presentationLayer valueForKey:@"position"] CGPointValue];
    
    CGPoint point2 = CGPointMake(assistancePoint.x, assistancePoint.y - (240 + 44));
    if (point2.y <=0) {
        return;
    }
    
    UIBezierPath *path = [self getBezierPathFromPoint1:CGPointMake(self.loginBtn.centerX, 0) radius1:radius_1 Point2:point2 radius2:radius_2];
    
    [path addArcWithCenter:point2 radius:radius_2 startAngle:0 endAngle:M_PI clockwise:YES];
    
    self.topWaterLayer.path = path.CGPath;
}

// 下落 绘制
- (void)drawTopWaterWhenFall
{
    NSLog(@"----drawTopWaterWhenFall");
    CGPoint point2 = CGPointMake(_topWaterDrop.centerX, _topWaterDrop.centerY - (240 + 44));
    UIBezierPath *path = [self getBezierPathFromPoint1:CGPointMake(self.loginBtn.centerX, 0) radius1:radius_1 Point2:point2 radius2:radius_2];
    [path addArcWithCenter:point2 radius:radius_2 startAngle:0 endAngle:M_PI clockwise:YES];
    _topWaterLayer.path = path.CGPath;
}

- (UIBezierPath *)getBezierPathFromPoint1:(CGPoint)point1 radius1:(CGFloat)r1 Point2:(CGPoint)point2 radius2:(CGFloat)r2
{
    if (r1 > r2) {
        CGPoint tempPoint = point1;
        point1 = point2;
        point2 = tempPoint;
        
        CGFloat tempR = r1;
        r1 = r2;
        r2 = tempR;
    }
    
    CGFloat x1 = point1.x;
    CGFloat y1 = point1.y;
    CGFloat x2 = point2.x;
    CGFloat y2 = point2.y;
    
    CGFloat distance = sqrt((x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1));
    
    CGFloat sinDegree = (x2 - x1) / distance;
    CGFloat cosDegree = (y2 - y1) / distance;
    
    CGPoint pointA = CGPointMake(x1 - r1 * cosDegree, y1 + r1 * sinDegree);
    CGPoint pointB = CGPointMake(x1 + r1 * cosDegree, y1 - r1 * sinDegree);
    CGPoint pointC = CGPointMake(x2 + r2 * cosDegree, y2 - r2 * sinDegree);
    CGPoint pointD = CGPointMake(x2 - r2 * cosDegree, y2 + r2 * sinDegree);
    CGPoint pointN;
    CGPoint pointM;
    
    pointM = CGPointMake(pointA.x + (distance / 2) * sinDegree, pointA.y + (distance / 2) * cosDegree);
    pointN = CGPointMake(pointB.x + (distance / 2) * sinDegree, pointB.y + (distance / 2) * cosDegree);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:pointA];
    [path moveToPoint:pointB];
//    [path addLineToPoint:pointB];
    [path addQuadCurveToPoint:pointC controlPoint:pointN];
//    [path addLineToPoint:pointD];
    [path moveToPoint:pointD];
    [path addQuadCurveToPoint:pointA controlPoint:pointM];
    
    return path;
    
}
// 掉落碰撞
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p
{
    
}


@end
