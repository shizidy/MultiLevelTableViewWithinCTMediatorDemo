//
//  MultiLevelViewModel.m
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import "MultiLevelViewModel.h"
#import "MultiLevelModel.h"

@implementation MultiLevelViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initCityResource];
    }
    return self;
}

#pragma mark - 初始化数据源
- (void)initCityResource {
    NSString *filePathStr = [[NSBundle mainBundle] pathForResource:@"cityResource" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePathStr];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    self.placesArray = [MultiLevelModel mj_objectArrayWithKeyValuesArray:jsonArray];
    self.statesDictionary = [[NSMutableDictionary alloc] init];
    self.statesArray = [[NSMutableArray alloc] init];
}

@end
