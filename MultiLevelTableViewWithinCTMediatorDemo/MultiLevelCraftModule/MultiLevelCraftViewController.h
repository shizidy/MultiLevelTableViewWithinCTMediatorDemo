//
//  MultiLevelCraftViewController.h
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import <UIKit/UIKit.h>
#import "MultiLevelCraftModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MultiLevelCraftViewController : UIViewController
/// 选择回调
@property (nonatomic, copy) void (^callBack)(MultiLevelCraftModel *);
@end

NS_ASSUME_NONNULL_END
