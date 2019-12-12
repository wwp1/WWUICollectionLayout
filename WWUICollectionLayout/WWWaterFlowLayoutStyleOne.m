//
//  WWWaterFlowLayoutStyleOne.m
//  WWUICollectionLayout
//
//  Created by 王万鹏 on 2019/12/5.
//  Copyright © 2019 王万鹏. All rights reserved.
//

#import "WWWaterFlowLayoutStyleOne.h"
#import "WaterCollectionViewCell.h"
#import "CollectionHeaderAndFooterView.h"
#import "UIButton+WWTitleImage.h"

@interface WWWaterFlowLayoutStyleOne ()<UICollectionViewDelegate, UICollectionViewDataSource,WWWaterFlowLayoutDelegate>
{
    WWWaterFlowLayout * _flow;
    NSMutableArray * _array;
}
@end

@implementation WWWaterFlowLayoutStyleOne

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title =  [NSString stringWithFormat:@"样式%d",self.flowLayoutStyle];
    self.view.backgroundColor = [UIColor grayColor];
    
    _array = [NSMutableArray array];
    for (int i = 0 ; i < 2 * 30; i++) {
        [_array addObject:@(arc4random()%200)];
    }
    
    _flow = [[WWWaterFlowLayout alloc] init];
    _flow.delegate = self;
    _flow.flowLayoutStyle = self.flowLayoutStyle;
    
    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) collectionViewLayout:_flow];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    
    //注册Item
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([WaterCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:@"ItemID"];
    
    //注册头尾视图
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionHeaderAndFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionHeaderAndFooterView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooter"];
    
    [self.view addSubview:collectionView];
    
    [self refreshLayout];
    
}

- (void)refreshLayout{
    
    if (_flow.flowLayoutStyle == (WWWaterFlowLayoutStyle)3){
        //每一个最小的正方形单元格的边长
        CGFloat  average = (self.view.frame.size.width - [self edgeInsetInWaterFlowLayout:_flow].left * 2 - 3 * [self columnMarginInWaterFlowLayout:_flow])/4.0;
        _flow.collectionView.frame = CGRectMake(0, 64, self.view.frame.size.width, average * 2 + [self rowMarginInWaterFlowLayout:_flow] + [self edgeInsetInWaterFlowLayout:_flow].top + [self edgeInsetInWaterFlowLayout:_flow].bottom);
    }else{
        _flow.collectionView.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64);
    }
    
    [_flow.collectionView  reloadData];
    
}

#pragma mark - Help Methods
//返回样式4所需的宽高信息
- (NSArray *)proportionsForItem{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"WWWaterFlowHorizontalGrid" ofType:@"plist"];
    NSArray * layoutInfo= [[NSArray alloc] initWithContentsOfFile:plistPath];
    return layoutInfo;
}

#pragma mark - WWWaterFlowLayoutDelegate
//返回每个item大小
- (CGSize)waterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(waterFlowLayout.flowLayoutStyle == (WWWaterFlowLayoutStyle)0){
        return CGSizeMake(0, [_array[indexPath.section * 10 + indexPath.row] floatValue]);
    }else if (waterFlowLayout.flowLayoutStyle == (WWWaterFlowLayoutStyle)1){
        return CGSizeMake([_array[indexPath.section * 10 + indexPath.row] floatValue], 0);
    }else if (waterFlowLayout.flowLayoutStyle == (WWWaterFlowLayoutStyle)2){
        return CGSizeMake([_array[indexPath.section * 10 + indexPath.row] floatValue], 100);
    }else if (waterFlowLayout.flowLayoutStyle == (WWWaterFlowLayoutStyle)3){
        //每一个最小的正方形单元格的边长
        CGFloat  average = (self.view.frame.size.width - [self edgeInsetInWaterFlowLayout:waterFlowLayout].left * 2 - 3 * [self columnMarginInWaterFlowLayout:waterFlowLayout])/4.0;
        NSDictionary * proportion = [self proportionsForItem][indexPath.row];
        CGSize itemSize =  CGSizeMake(average * [proportion[@"width"] intValue]+ ([proportion[@"width"] intValue] == 2 ? [self columnMarginInWaterFlowLayout:waterFlowLayout] : 0), average * [proportion[@"height"] intValue] + ([proportion[@"height"] intValue] == 2 ? [self rowMarginInWaterFlowLayout:waterFlowLayout] : 0));
        return itemSize;
    }else{
        return CGSizeMake(0, 0);
    }
}

/** 头视图Size */
-(CGSize )waterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section{
    return CGSizeMake(40, 40);
}
/** 脚视图Size */
-(CGSize )waterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section{
    return CGSizeMake(40, 40);
}

/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout{
    return 3;
}
/** 行数*/
-(CGFloat)rowCountInWaterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout{
    return 5;
}
/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout{
    return 5;
}
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout{
    return 5;
}
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout{
    if (waterFlowLayout.flowLayoutStyle == (WWWaterFlowLayoutStyle)3){
        return UIEdgeInsetsMake(20, 20, 20, 20);
    }
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma mark - UICollectionView数据源

//组个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_flow.flowLayoutStyle == (WWWaterFlowLayoutStyle)3){
        return 1;
    }
    return _array.count/10;
}

//组内成员个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_flow.flowLayoutStyle == (WWWaterFlowLayoutStyle)3){
        return [self proportionsForItem].count;
    }
    return 10;
}

// 返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WaterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemID" forIndexPath:indexPath];
    
    cell.label.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0];
    //     cell.label.backgroundColor = [UIColor greenColor];
    
    cell.label.text = [NSString stringWithFormat:@"%ld - %ld",indexPath.section, indexPath.row];
    
    return cell;
    
}
//返回头脚视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        CollectionHeaderAndFooterView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
        headerView.titleLabel.text = @"头视图";
        headerView.titleLabel.backgroundColor = [UIColor orangeColor];
        return headerView;
        
    }else{
        CollectionHeaderAndFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"sectionFooter" forIndexPath:indexPath];
        footerView.titleLabel.text = @"脚视图";
        footerView.titleLabel.backgroundColor = [UIColor cyanColor];
        return footerView;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@" %@",indexPath);
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

