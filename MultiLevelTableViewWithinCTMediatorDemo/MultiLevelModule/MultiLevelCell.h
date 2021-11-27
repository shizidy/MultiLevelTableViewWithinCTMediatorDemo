//
//  MultiLevelCell.h
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/26.
//

#import <UIKit/UIKit.h>
#import "MultiLevelViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MultiLevelCell : UITableViewCell

- (void)setCellWithViewModel:(MultiLevelViewModel *)viewModel indexPath:(NSIndexPath *)indexPath;
- (void)makeArrowImgViewRotation:(CGFloat)rotation;
@end

NS_ASSUME_NONNULL_END
