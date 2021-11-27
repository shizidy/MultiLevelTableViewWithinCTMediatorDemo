//
//  CTMediator+MultiLevel.m
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import "CTMediator+MultiLevel.h"

// 定义字符串常量
NSString * const kCTMediatorMultiLevelTarget = @"MultiLevel";
NSString * const kCTMediatorMultiLevelAction = @"MultiLevelViewController";

@implementation CTMediator (MultiLevel)

- (UIViewController *)CTMediator_MultiLevelControllerWithCallBack:(void (^)(id _Nonnull))callBack {
    UIViewController *viewController = [self performTarget:kCTMediatorMultiLevelTarget action:kCTMediatorMultiLevelAction params:@{@"block": callBack} shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    } else {
        NSLog(@"%@初始化失败", kCTMediatorMultiLevelAction);
        return [[UIViewController alloc] init];
    }
}

@end
