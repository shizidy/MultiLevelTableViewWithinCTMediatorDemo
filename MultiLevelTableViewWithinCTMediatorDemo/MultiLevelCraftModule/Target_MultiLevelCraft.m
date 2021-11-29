//
//  Target_MultiLevelCraft.m
//  MultiLevelTableViewWithinCTMediatorDemo
//
//  Created by wdyzmx on 2021/11/28.
//

#import "Target_MultiLevelCraft.h"
#import "MultiLevelCraftViewController.h"

@implementation Target_MultiLevelCraft

- (UIViewController *)Action_MultiLevelCraftViewController:(NSDictionary *)params {
    MultiLevelCraftViewController *viewController = [[MultiLevelCraftViewController alloc] init];
    viewController.callBack = params[@"block"];
    return viewController;
}

@end
