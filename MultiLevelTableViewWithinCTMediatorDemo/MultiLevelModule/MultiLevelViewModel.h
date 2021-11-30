//
//  MultiLevelViewModel.h
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import <Foundation/Foundation.h>
#import "MultiLevelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MultiLevelViewModel : NSObject
/// 存储省市县的数据model
@property (nonatomic, strong) NSMutableArray<MultiLevelModel *> *placesArray;
/// 保存各省或市或县的级联关闭前的数据，格式@{@"code1": array1, @"code2": array2, @"code3": array3}
@property (nonatomic, strong) NSMutableDictionary *statesDictionary;
@end

NS_ASSUME_NONNULL_END
