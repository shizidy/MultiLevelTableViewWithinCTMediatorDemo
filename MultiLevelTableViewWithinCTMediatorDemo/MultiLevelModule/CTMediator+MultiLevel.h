//
//  CTMediator+MultiLevel.h
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import "CTMediator.h"

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (MultiLevel)

- (UIViewController *)CTMediator_MultiLevelControllerWithCallBack:(void (^)(id))callBack;

@end

NS_ASSUME_NONNULL_END
