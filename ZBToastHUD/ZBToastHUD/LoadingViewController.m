//
//  LoadingViewController.m
//  ZBToastHUD
//
//  Created by yuanye on 2016/10/28.
//  Copyright © 2016年 yuanye. All rights reserved.
//

#import "LoadingViewController.h"
#import "UIViewController+ZBToastHUD.h"

@interface LoadingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *dataSource;

@end

@implementation LoadingViewController

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
        [self zb_showLoading];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self zb_dismissToast];
        });
    }
    else if (1 == indexPath.row)
    {
        [self zb_showLoadingWithStyle:ZBToastHUDLoadingStyleLight];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self zb_dismissToast];
        });
    }
    else if (2 == indexPath.row)
    {
        [self zb_showLoadingWithMaskType:ZBToastHUDLoadingMaskTypeDark];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self zb_dismissToast];
        });
    }
    else if (3 == indexPath.row)
    {
        [self zb_showLoadingWithStyle:ZBToastHUDLoadingStyleLight maskType:ZBToastHUDLoadingMaskTypeDark];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self zb_dismissToast];
        });
    }
    else if (4 == indexPath.row)
    {
        [self.navigationController zb_showLoadingWithMaskType:ZBToastHUDLoadingMaskTypeDark];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController zb_dismissToast];
        });
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
        _dataSource = @[@"default loading",
                        @"style light",
                        @"maskType dark",
                        @"style light and maskType dark",
                        @"self.navigationController maskType dark"];
    }
    return _dataSource;
}

@end
