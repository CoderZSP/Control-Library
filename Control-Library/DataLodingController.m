//
//  DataLodingController.m
//  Control-Library
//
//  Created by zhangsp on 2019/2/26.
//  Copyright © 2019 zhangsp. All rights reserved.
//

#import "DataLodingController.h"
#import "DJLodingView.h"
@interface DataLodingController ()
@property (nonatomic, strong) DJLodingView* lodingView;
@end

@implementation DataLodingController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lodingView = [[DJLodingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.lodingView];
    self.view.backgroundColor = [UIColor whiteColor];
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if(self.lodingView){
//        [self.lodingView hideLoding];
//    }
//}
@end
