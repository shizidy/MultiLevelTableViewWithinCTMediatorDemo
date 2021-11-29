//
//  CTMediator+MultiLevelCraft.h
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import "CTMediator.h"
#import "MultiLevelCraftModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (MultiLevelCraft)
/// CTMediator category方法
/// @param callBack 回调
- (UIViewController *)CTMediator_MultiLevelCraftViewControllerWithCallBack:(void (^)(MultiLevelCraftModel *))callBack;
@end

NS_ASSUME_NONNULL_END
