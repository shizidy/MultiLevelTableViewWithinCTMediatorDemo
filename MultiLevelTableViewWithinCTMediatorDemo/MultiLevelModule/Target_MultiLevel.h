//
//  Target_MultiLevel.h
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_MultiLevel : NSObject
/// Action 对应的方法
/// @param params 传参数
- (UIViewController *)Action_MultiLevelViewController:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
