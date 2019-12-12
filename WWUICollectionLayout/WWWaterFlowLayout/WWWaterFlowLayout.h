//
//  WWWaterFlowLayout.h
//  WWUICollectionLayout
//
//  Created by 王万鹏 on 2019/12/5.
//  Copyright © 2019 王万鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    WWWaterFlowVerticalEqualWidth = 0, /** 竖向瀑布流 item等宽不等高 */
    WWWaterFlowHorizontalEqualHeight = 1, /** 水平瀑布流 item等高不等宽 不支持头脚视图*/
    WWWaterFlowVerticalEqualHeight = 2,  /** 竖向瀑布流 item等高不等宽 */
} WWWaterFlowLayoutStyle; //样式

@class WWWaterFlowLayout;

@protocol WWWaterFlowLayoutDelegate <NSObject>

/**
 返回item的大小
 注意：根据当前的瀑布流样式需知的事项：
 当样式为WWWaterFlowVerticalEqualWidth 传入的size.width无效 ，所以可以是任意值，因为内部会根据样式自己计算布局
 WWWaterFlowHorizontalEqualHeight 传入的size.height无效 ，所以可以是任意值 ，因为内部会根据样式自己计算布局
 WWWaterFlowHorizontalGrid   传入的size宽高都有效， 此时返回列数、行数的代理方法无效，
 WWWaterFlowVerticalEqualHeight 传入的size宽高都有效， 此时返回列数、行数的代理方法无效
 */
- (CGSize)waterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

/** 头视图Size */
-(CGSize )waterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout sizeForHeaderViewInSection:(NSInteger)section;
/** 脚视图Size */
-(CGSize )waterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout sizeForFooterViewInSection:(NSInteger)section;

@optional //以下都有默认值
/** 列数*/
-(CGFloat)columnCountInWaterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout;
/** 行数*/
-(CGFloat)rowCountInWaterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout;

/** 列间距*/
-(CGFloat)columnMarginInWaterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout;
/** 行间距*/
-(CGFloat)rowMarginInWaterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout;
/** 边缘之间的间距*/
-(UIEdgeInsets)edgeInsetInWaterFlowLayout:(WWWaterFlowLayout *)waterFlowLayout;

@end

@interface WWWaterFlowLayout : UICollectionViewLayout

/** delegate*/
@property (nonatomic, weak) id<WWWaterFlowLayoutDelegate> delegate;
/** 瀑布流样式*/
@property (nonatomic, assign) WWWaterFlowLayoutStyle  flowLayoutStyle;

@end
