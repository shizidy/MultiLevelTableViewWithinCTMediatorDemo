//
//  MultiLevelCraftViewController.m
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import "MultiLevelCraftViewController.h"
#import "MultiLevelCraftViewModel.h"
#import "MultiLevelCraftModel.h"
#import "MultiLevelCell.h"

@interface MultiLevelCraftViewController () <UITableViewDelegate, UITableViewDataSource>
/// tableView
@property (nonatomic, strong) UITableView *tableView;
/// viewModel
@property (nonatomic, strong) MultiLevelCraftViewModel *viewModel;
@end

@implementation MultiLevelCraftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)setUI {
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.craftsArray.count > 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.craftsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultiLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MultiLevelCell class]) forIndexPath:indexPath];
    [cell fillCellWithViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 获取所点击行所在的model
    MultiLevelCraftModel *model = self.viewModel.craftsArray[indexPath.row];
    // 获取cell
    MultiLevelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    BOOL isMatched = NO;
    for (MultiLevelCraftModel *craftModel in self.viewModel.allCraftsArray) {
        if ([craftModel.craft_id isEqualToString:model.craft_id]) {
            continue;
        }
        if ([craftModel.pid isEqualToString:model.craft_id]) {
            isMatched = YES;
            break;
        }
    }
    if (!isMatched) {
        /*
         1.倒序查找父节点即可找到层级关系
         2.查找思路：对比level值大小，倒序找到第一个比自己level值小的即为自己的父级
         3.level值的层级关系定义是：level值为0->1->2->3...
         */
        // 初始化第一个节点为本节点
        NSMutableArray<MultiLevelCraftModel *> *marray = [NSMutableArray arrayWithObject:model];
        // 初始化str
        NSString *str = model.name;
        // 初始化level
        NSInteger level = [model.level_code componentsSeparatedByString:@"."].count;
        for (NSInteger i = indexPath.row - 1; i >= 0; i--) {
            MultiLevelCraftModel *tmpModel = self.viewModel.craftsArray[i];
            NSInteger tmpLevel = [tmpModel.level_code componentsSeparatedByString:@"."].count;
            if (level > tmpLevel) {
                str = [NSString stringWithFormat:@"%@->%@", tmpModel.name, str];
                [marray insertObject:tmpModel atIndex:0];
                // 重置level
                level = tmpLevel;
            }
            if (tmpLevel == 1) {
                break;
            }
        }
        // 回调传参，可自定义
        NSDictionary *params = @{
            @"selectedModel": model,
            @"selectedModelArray": marray,
            @"selectedFormatString": str
        };
        self.callBack(params);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (model.isExpanded) {
#pragma mark - 关闭级联
        model.isExpanded = NO;
        //旋转动画
        [cell makeArrowImgViewRotation:0];
        
        // 起始index
        NSInteger startIndex = indexPath.row + 1;
        // 终止index并赋初值self.viewModel.craftsArray.count
        NSInteger endIndex = self.viewModel.craftsArray.count;
        // 保存删除的model
        NSMutableArray<MultiLevelCraftModel *> *modelArray = [NSMutableArray array];
        // 保存indexPath
        NSMutableArray<NSIndexPath *> *indexPathArray = [NSMutableArray array];
        NSArray *array1 = [model.level_code componentsSeparatedByString:@"."];
        
        for (NSInteger i = startIndex; i < self.viewModel.craftsArray.count; i++) {
            MultiLevelCraftModel *endModel = self.viewModel.craftsArray[i];
            NSArray *array2 = [endModel.level_code componentsSeparatedByString:@"."];
            if (array1.count >= array2.count) {
                endIndex = i;
                break;
            }
            // 添加各indexPath
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPathArray addObject:tmpIndexPath];
            // 添加model
            [modelArray addObject:endModel];
        }
        NSInteger length = endIndex - startIndex;
        if (length == 0) {
            return;
        }
        self.viewModel.statesDictionary[model.craft_id] = modelArray;
        // 操作数据源
        [self.viewModel.craftsArray removeObjectsInRange:NSMakeRange(indexPath.row + 1, length)];
        // 执行删除行
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } else {
#pragma mark - 展开级联
        model.isExpanded = YES;
        // 旋转动画
        [cell makeArrowImgViewRotation:M_PI / 2];
        
        // 生成modelArray
        NSMutableArray<MultiLevelCraftModel *> *modelArray = [NSMutableArray array];
        for (NSString *craftId in self.viewModel.statesDictionary.allKeys) {
            if ([craftId isEqualToString:model.craft_id]) {
                modelArray = self.viewModel.statesDictionary[model.craft_id];
                break;
            }
        }
        if (modelArray.count == 0) {
            NSMutableArray *allCraftsArrayCopy = self.viewModel.allCraftsArray.mutableCopy;
            [allCraftsArrayCopy removeObjectsInArray:self.viewModel.craftsArray];
            for (MultiLevelCraftModel *tmpModel in allCraftsArrayCopy) {
                if ([tmpModel.pid isEqualToString:model.craft_id]) {
                    [modelArray addObject:tmpModel];
                }
            }
            // 对marray内的model依据level_code进行排序，因为level_code数值的小数点后数字表示其顺序
            [self quickSortMutiLevelCraftModelByLevel_codeWithArray:modelArray leftIndex:0 rightIndex:modelArray.count - 1];
        }
        NSMutableArray<NSIndexPath *> *indexPathArray = [NSMutableArray array];
        for (int i = 0; i < modelArray.count; i++) {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 + i inSection:0];
            [indexPathArray addObject:tmpIndexPath];
            [self.viewModel.craftsArray insertObject:modelArray[i] atIndex:indexPath.row + 1 + i];
        }
        // 执行插入行
        [tableView beginUpdates];
        [tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
    }
}

//快速排序
- (void)quickSortMutiLevelCraftModelByLevel_codeWithArray:(NSMutableArray *)marray leftIndex:(NSInteger)left rightIndex:(NSInteger)right {
    if (left >= right) {
        return;
    }
    NSInteger i = left;
    NSInteger j = right;
    MultiLevelCraftModel *model = marray[i];
    NSInteger key = [[self getLastStringWith:model.level_code separateBy:@"."] integerValue];
    
    while (i < j) {
        while (i < j && [self getCondition1WithArray:marray key:key index:j]) {  // 从右边找到比key小的
            j--;
        }
        marray[i] = marray[j];
        
        while (i < j && [self getCondition2WithArray:marray key:key index:i]) {  // 从左边找到比key大的
            i++;
        }
        marray[j] = marray[i];
    }
    marray[i] = model;  // 把基准数放在正确的位置
    // 递归
    [self quickSortMutiLevelCraftModelByLevel_codeWithArray:marray leftIndex:left rightIndex:i - 1]; // 排序基准数左边的
    [self quickSortMutiLevelCraftModelByLevel_codeWithArray:marray leftIndex:i + 1 rightIndex:right];  // 排序基准数右边的
}

- (NSString *)getLastStringWith:(NSString *)string separateBy:(NSString *)character {
    NSArray *array = [string componentsSeparatedByString:character];
    return array.lastObject;
}

- (BOOL)getCondition1WithArray:(NSMutableArray *)marray key:(NSInteger)key index:(NSInteger)index {
    MultiLevelCraftModel *model = marray[index];
    NSInteger keyIndex = [[self getLastStringWith:model.level_code separateBy:@"."] integerValue];
    return keyIndex >= key;
}

- (BOOL)getCondition2WithArray:(NSMutableArray *)marray key:(NSInteger)key index:(NSInteger)index {
    MultiLevelCraftModel *model = marray[index];
    NSInteger keyIndex = [[self getLastStringWith:model.level_code separateBy:@"."] integerValue];
    return keyIndex <= key;
}

#pragma mark - 懒加载
- (MultiLevelCraftViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MultiLevelCraftViewModel alloc] init];
    }
    return _viewModel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBarHeight + StatusBarHeight, KScreenWidth, KScreenHeight - NavigationBarHeight - StatusBarHeight - TabbarSafeBottomMargin) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[MultiLevelCell class] forCellReuseIdentifier:NSStringFromClass([MultiLevelCell class])];
    }
    return _tableView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
