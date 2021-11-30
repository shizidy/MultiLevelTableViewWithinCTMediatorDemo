//
//  MultiLevelCraftViewController.h
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultiLevelCraftViewController : UIViewController
/// 选择回调
@property (nonatomic, copy) void (^callBack)(NSDictionary *);
@end

NS_ASSUME_NONNULL_END
