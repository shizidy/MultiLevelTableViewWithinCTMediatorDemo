//
//  MultiLevelCell.h
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/26.
//

#import <UIKit/UIKit.h>
#import "MultiLevelViewModel.h"
#import "MultiLevelCraftViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MultiLevelCell : UITableViewCell
/// 赋值cell
/// @param viewModel MultiLevelViewModel
/// @param indexPath indexPath
- (void)setCellWithViewModel:(MultiLevelViewModel *)viewModel indexPath:(NSIndexPath *)indexPath;
/// 赋值cell
/// @param viewModel MultiLevelCraftViewModel
/// @param indexPath indexPath
- (void)fillCellWithViewModel:(MultiLevelCraftViewModel *)viewModel indexPath:(NSIndexPath *)indexPath;
/// 指示箭头旋转动画
/// @param rotation 旋转度数
- (void)makeArrowImgViewRotation:(CGFloat)rotation;
@end

NS_ASSUME_NONNULL_END
