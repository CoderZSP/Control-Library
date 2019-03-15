//
//  ListRefreshController.m
//  Control-Library
//
//  Created by zhangsp on 2019/2/19.
//  Copyright © 2019 zhangsp. All rights reserved.
//

#import "ListRefreshController.h"
#import "MJRefresh.h"
#import "DJRefreshHeader.h"
@interface ListRefreshController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation ListRefreshController

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [@[@"修改密码",@"功能设置",@"清理缓存",@"功能设置",@"清理缓存",@"功能设置",@"清理缓存",@"功能设置",@"清理缓存"] mutableCopy];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = [DJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshAction)];
    
}

-(void)refreshAction
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.mj_header endRefreshing];
    });
    NSLog(@"refreshAction");
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"animateIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"animateIdentifier"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"section - %ld, row - %ld",(long)indexPath.section,(long)indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
