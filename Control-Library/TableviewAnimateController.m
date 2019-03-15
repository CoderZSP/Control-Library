//
//  TableviewAnimateController.m
//  Control-Library
//
//  Created by zhangsp on 2019/2/19.
//  Copyright © 2019 zhangsp. All rights reserved.
//

#import "TableviewAnimateController.h"

@interface TableviewAnimateController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *iconArray;
@property (assign, nonatomic) BOOL isDrag;
@property (strong, nonatomic) dispatch_semaphore_t semaphore;
@property (strong, nonatomic) dispatch_queue_t quene;
@end

@implementation TableviewAnimateController

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [@[@[@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"Section",@"清理缓存",@"Section",@"Section"],@[@"Section",@"Section",@"Section",@"Section"]] mutableCopy];
    }
    return _dataArray;
}

-(NSMutableArray *)iconArray
{
    if (_iconArray == nil) {
        _iconArray = [@[@[@"setting_icon_edit",@"setting_icon_function",@"setting_icon_clean",@"setting_icon_function",@"setting_icon_clean",@"setting_icon_function",@"setting_icon_clean",@"setting_icon_function",@"setting_icon_clean",@"setting_icon_function",@"setting_icon_clean",@"setting_icon_function",@"setting_icon_clean",@"setting_icon_function",@"setting_icon_clean",@"setting_icon_function",@"setting_icon_clean",@"setting_icon_function",@"setting_icon_clean",@"setting_icon_function",@"setting_icon_clean",@"setting_icon_function",@"setting_icon_clean",@"setting_icon_function",@"setting_icon_clean",@"setting_icon_function",@"setting_icon_clean",@"setting_icon_function",@"setting_icon_clean"],@[@"setting_icon_aobut",@"setting_icon_share",@"setting_icon_history",@"setting_icon_history"]] mutableCopy];
    }
    return _iconArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"TableViewCell animate ";
    
    // 1.创建一个串行队列，保证for循环依次执行
    self.semaphore = dispatch_semaphore_create(1);
    self.quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = self.dataArray[section];
    return array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"animateIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue1 reuseIdentifier: @"animateIdentifier"];
    }
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.iconArray[indexPath.section][indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isDrag) {
        return;
    }
    
    cell.alpha = 0;
    dispatch_async(self.quene, ^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CGPoint center = cell.center;
            CGPoint orgCenter = center;
            center.x += 100;
            cell.center = center;
            cell.alpha = 0;
            [UIView animateWithDuration:0.5 animations:^{
                cell.center = orgCenter;
                cell.alpha = 1;
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                dispatch_semaphore_signal(self.semaphore);
            });
        });
        
    });
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewWillBeginDragging");
    self.isDrag = YES;
}

@end
