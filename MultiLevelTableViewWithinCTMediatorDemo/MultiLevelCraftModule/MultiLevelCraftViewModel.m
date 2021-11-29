//
//  MultiLevelCraftViewModel.m
//  MultiLevelTableViewWithinCTMediatorDemo
//
//  Created by wdyzmx on 2021/11/28.
//

#import "MultiLevelCraftViewModel.h"
#import "MultiLevelCraftModel.h"

@implementation MultiLevelCraftViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initResource];
    }
    return self;
}

#pragma mark - 解析数据源
- (void)initResource {
    NSString *filePathStr = [[NSBundle mainBundle] pathForResource:@"Resource" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePathStr];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"%@", jsonArray);
    self.statesDictionary = [NSMutableDictionary dictionary];
    self.craftsArray = [NSMutableArray array];
    self.otherCraftsArray = [NSMutableArray array];
    self.allCraftsArray = [MultiLevelCraftModel mj_objectArrayWithKeyValuesArray:jsonArray];
    for (MultiLevelCraftModel *model in self.allCraftsArray) {
        if (!model.pid) {
            [self.craftsArray addObject:model];
        } else {
            [self.otherCraftsArray addObject:model];
        }
    }
}

@end
