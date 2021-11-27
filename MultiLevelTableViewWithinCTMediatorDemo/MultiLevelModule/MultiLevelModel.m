//
//  MultiLevelModel.m
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import "MultiLevelModel.h"

@implementation MultiLevelModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"children": @"MultiLevelModel"
    };
}

//- (NSString *)description {
//    return [NSString stringWithFormat:@"%@ == %@ == %ld == %@", self.code, self.name, (long)self.level, self.children];
//}

@end
