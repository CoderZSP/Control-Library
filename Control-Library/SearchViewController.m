//
//  SearchViewController.m
//  Control-Library
//
//  Created by zhangsp on 2019/2/26.
//  Copyright © 2019 zhangsp. All rights reserved.
//

#import "SearchViewController.h"
#import "FinishListSearchBoxView.h"
#import "UIView+Extension.h"
#import "UIColor+ColorChange.h"
#define MainColor [UIColor colorWithRed:24.0/255.0 green:134.0/255.0 blue:227.0/255.0 alpha:1.0]
#define HScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define HScreenHeight ([UIScreen mainScreen].bounds.size.height)
@interface SearchViewController ()<UITextFieldDelegate>

@property(nonatomic, strong) FinishListSearchBoxView *searchBoxView;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavBarItem];
}


/** 初始化导航栏信息 */
- (void)initNavBarItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"common_icon_search_normal"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(clickForSearch)];
}

#pragma mark - action
/** 搜索框 */
- (void)clickForSearch {
    self.title = @"";
    self.navigationItem.rightBarButtonItem = nil;
    
    self.searchBoxView =  [[NSBundle mainBundle] loadNibNamed:
                           @"FinishListSearchBoxView" owner:nil options:nil ].lastObject;
    self.searchBoxView.frame = CGRectMake(0, 4, HScreenWidth, 35);
    self.searchBoxView.width = HScreenWidth/2;
    self.searchBoxView.x = HScreenWidth;
//    self.searchBoxView.centerX = HScreenWidth;// HScreenWidth /2;
    self.navigationItem.titleView = self.searchBoxView;
    
    [self.searchBoxView.searchTextField setValue:[UIColor colorWithHexString:@"ACCDF2" alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    [self.searchBoxView.searchTextField setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    self.searchBoxView.searchTextField.delegate = self;
    
    [self.searchBoxView.cancelButton.layer setAnchorPoint:CGPointMake(0.5, 0.5)];
    [self.searchBoxView.cancelButton.layer setTransform:CATransform3DMakeRotation(85 * M_PI / 180, 0, 1, 0)];
    [self.searchBoxView.searchTextField resignFirstResponder];
//    self.searchBoxView.searchTextField setf
//    self.searchBoxView.searchTextField.width = 15;
    [UIView animateWithDuration:0.5 animations:^{
        self.searchBoxView.x = 0;
        self.searchBoxView.width = HScreenWidth;
    } completion:^(BOOL finished) {
        
        self.searchBoxView.cancelButton.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.4 animations:^{
            [self.searchBoxView.cancelButton.layer setTransform:CATransform3DMakeRotation(0 * M_PI / 180, 0, 1, 0)];
        } completion:^(BOOL finished) {
            NSString *str = @"请输入名称、备注、发起人搜索";
            NSString *mstr = @"";
            for (int i=0; i<str.length; i++) {
                mstr = [str substringToIndex:i+1];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.searchBoxView.searchTextField setPlaceholder:mstr];
                    if (i<str.length-1) {
                        [self.searchBoxView.searchTextField becomeFirstResponder];
                    }
                });
            }
        }];
    }];
    
    [self.searchBoxView.cancelButton addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickForCancel)]];
}


/** 取消 */
- (void)clickForCancel {
    [UIView animateWithDuration:0.4 animations:^{
        [self.searchBoxView.cancelButton.layer setTransform:CATransform3DMakeRotation(90 * M_PI / 180, 0, 1, 0)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 animations:^{
            [self.searchBoxView setX:HScreenWidth];
        } completion:^(BOOL finished) {
            [self.searchBoxView removeFromSuperview];
            self.searchBoxView = nil;
            self.navigationItem.titleView = nil;
            self.title = @"SearchView";
            [self initNavBarItem];
            
        }];
    }];
}

@end
