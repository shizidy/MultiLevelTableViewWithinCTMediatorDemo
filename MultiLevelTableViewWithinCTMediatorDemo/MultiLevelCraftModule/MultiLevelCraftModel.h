//
//  MultiLevelCraftModel.h
//  MultiLevelTableViewWithinCTMediatorDemo
//
//  Created by wdyzmx on 2021/11/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultiLevelCraftModel : NSObject
@property (nonatomic, strong) NSString *craft_type;
@property (nonatomic, strong) NSString *craft_id;
@property (nonatomic, strong) NSString *level_code;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *order_no;
@property (nonatomic, strong) NSString *pid;
@property (nonatomic, strong) NSString *type;
/// 层级
@property (nonatomic, assign) NSInteger level;
/// 记录是否展开
@property (nonatomic, assign) BOOL isExpanded;
@end

NS_ASSUME_NONNULL_END
