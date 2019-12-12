//
//  ViewController.m
//  WWUICollectionLayout
//
//  Created by 王万鹏 on 2019/12/5.
//  Copyright © 2019 王万鹏. All rights reserved.
//

#import "ViewController.h"
#import "WWWaterFlowLayoutStyleOne.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong)  UITableView *tableView;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * vcArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"瀑布流";
    
    [self.view addSubview:self.tableView];
    
    _dataSource = @[@"竖向瀑布流 item等宽不等高 支持头脚视图",@"水平瀑布流 item等高不等宽 不支持头脚视图", @"竖向瀑布流 item等高不等宽 支持头脚视图"];
    _vcArray = @[@"WWWaterFlowLayoutStyleOne", @"WWWaterFlowLayoutStyleOne", @"WWWaterFlowLayoutStyleOne"];
}

#pragma mark -- UITableViewDelegate  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellID"];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    
    return cell;
}

- (void )tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    WWWaterFlowLayoutStyleOne * flowLayout = [NSClassFromString(_vcArray[indexPath.row]) new];
    flowLayout.flowLayoutStyle = (WWWaterFlowLayoutStyle)indexPath.row;
    
    [self.navigationController pushViewController:flowLayout animated:NO];
}

- (UITableView *)tableView {
    _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
//    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

