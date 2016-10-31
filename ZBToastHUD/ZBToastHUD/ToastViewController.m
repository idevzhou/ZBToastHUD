//
//  ToastViewController.m
//  ZBToastHUD
//
//  Created by yuanye on 2016/10/28.
//  Copyright © 2016年 yuanye. All rights reserved.
//

#import "ToastViewController.h"
#import "UIViewController+ZBToastHUD.h"

@interface ToastViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation ToastViewController

#pragma mark - lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.tableView.frame = self.view.frame;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (0 == indexPath.row)
    {
        [self zb_showWithMessage:@"3秒后消失"];
    }
    else if (1 == indexPath.row)
    {
        [self zb_showNoNetwork];
    }
    else if (2 == indexPath.row)
    {
        [self zb_showSuccessWithMessage:@"3秒后消失"];
    }
    else if (3 == indexPath.row)
    {
        [self zb_showErrorWithMessage:@"3秒后消失"];
    }
    else if (4 == indexPath.row)
    {
        [self zb_showWarningWithMessage:@"3秒后消失"];
    }
}

#pragma mark - super

- (NSString *)title
{
    return NSStringFromClass(self.class);
}

#pragma mark - getter and setter

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@"only message",
                        @"no network image and message",
                        @"success image and message",
                        @"error image and message",
                        @"warning image and message"];
    }
    return _dataSource;
}

@end
