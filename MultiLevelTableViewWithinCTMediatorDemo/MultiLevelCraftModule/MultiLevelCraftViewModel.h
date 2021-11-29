//
//  MultiLevelCraftViewModel.h
//  MultiLevelTableViewWithinCTMediatorDemo
//
//  Created by wdyzmx on 2021/11/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultiLevelCraftViewModel : NSObject
/// 所有craft数据model
@property (nonatomic, strong) NSMutableArray *allCraftsArray;
/// 存储数据model
@property (nonatomic, strong) NSMutableArray *craftsArray;
/// allCraftsArray 减去 craftsArray
@property (nonatomic, strong) NSMutableArray *otherCraftsArray;
/// 保存各craft级联关闭前的数据，格式@{@"craft_id1": array1, @"craft_id2": array2, @"craft_id3": array3}
@property (nonatomic, strong) NSMutableDictionary *statesDictionary;
@end

NS_ASSUME_NONNULL_END
