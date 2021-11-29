//
//  MultiLevelViewController.h
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import <UIKit/UIKit.h>
#import "MultiLevelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MultiLevelViewController : UIViewController

@property (nonatomic, copy) void (^callBack)(MultiLevelModel *);

@end

NS_ASSUME_NONNULL_END
