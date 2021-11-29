//
//  CTMediator+MultiLevelCraft.m
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import "CTMediator+MultiLevelCraft.h"

NSString * const kCTMediatorMultiLevelCraftTarget = @"MultiLevelCraft";
NSString * const kCTMediatorMultiLevelCraftAction = @"MultiLevelCraftViewController";

@implementation CTMediator (MultiLevelCraft)

- (UIViewController *)CTMediator_MultiLevelCraftViewControllerWithCallBack:(void (^)(MultiLevelCraftModel * _Nonnull))callBack {
    UIViewController *viewController = [[CTMediator sharedInstance] performTarget:kCTMediatorMultiLevelCraftTarget action:kCTMediatorMultiLevelCraftAction params:@{
        @"block": callBack
    } shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    } else {
        return [UIViewController new];
    }
}

@end
