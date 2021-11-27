//
//  Target_MultiLevel.m
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import "Target_MultiLevel.h"
#import "MultiLevelViewController.h"

@implementation Target_MultiLevel

- (UIViewController *)Action_MultiLevelViewController:(NSDictionary *)params {
    MultiLevelViewController *viewController = [[MultiLevelViewController alloc] init];
    viewController.callBack = params[@"block"];
    return viewController;
}

@end
