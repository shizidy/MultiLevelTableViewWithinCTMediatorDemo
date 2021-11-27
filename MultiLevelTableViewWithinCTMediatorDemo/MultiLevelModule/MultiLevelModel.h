//
//  MultiLevelModel.h
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultiLevelModel : NSObject
/// 下级
@property (nonatomic, strong) NSMutableArray *children;
/// 城市代码
@property (nonatomic, strong) NSString *code;
/// 城市名称
@property (nonatomic, strong) NSString *name;
/// 层级
@property (nonatomic, assign) NSInteger level;
/// 记录是否展开
@property (nonatomic, assign) BOOL isExpanded;
@end

NS_ASSUME_NONNULL_END
