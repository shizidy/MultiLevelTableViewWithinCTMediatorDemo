//
//  MultiLevelViewController.m
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import "MultiLevelViewController.h"
#import "MultiLevelViewModel.h"
#import "MultiLevelCell.h"
#import "MultiLevelModel.h"

@interface MultiLevelViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MultiLevelViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MultiLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view. backgroundColor = [UIColor whiteColor];
    [self setUI];
    // Do any additional setup after loading the view.
}

- (void)setUI {
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.viewModel.placesArray.count > 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.placesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MultiLevelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MultiLevelCell class]) forIndexPath:indexPath];
    [cell setCellWithViewModel:self.viewModel indexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MultiLevelModel *model = self.viewModel.placesArray[indexPath.row];
    MultiLevelCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 当没有子children或者children为空时直接return
    if (!model.children || !model.children.count) {
        /*
         1.倒序查找父节点即可找到层级关系，如：北京->市辖区->朝阳区
         2.查找思路：对比level值大小，倒序找到第一个比自己level值小的即为自己的父级
         3.level值的层级关系定义是：比如北京->市辖区->朝阳区对应的level值为0->1->2
         */
        // placesStr保存拼接的层级（节点），初始化为本节点
        NSString *str = [NSString stringWithString:model.name];
        // 初始化marray保存第一个本节点
        NSMutableArray<MultiLevelModel *> *marray = [NSMutableArray arrayWithObject:model];
        // 初始化tmpLevel为当前model的level
        NSInteger level = model.level;
        for (NSInteger i = indexPath.row - 1; i >= 0; i--) {
            MultiLevelModel *tmpModel = self.viewModel.placesArray[i];
            if (level > tmpModel.level) {
                str = [NSString stringWithFormat:@"%@->%@", tmpModel.name, str];
                [marray insertObject:tmpModel atIndex:0];
                // 重置节点tmpLevel为当前条件匹配的tmpModel.level
                level = tmpModel.level;
            }
            if (tmpModel.level == 0) {
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
        // 执行箭头旋转动画
        [cell makeArrowImgViewRotation:0];
        /*
         1.关闭前先把省/市/县展开时的数据保存起来
         2.怎么查找要保存的数据，思路：1.两个相同层级（level）之间的数据即为该层级的展开状态下的数据 2.该层级与首次找到比他大的层级之间的数据
         3.例如北京市与河北省之间，假如北京这一层级处于展开状态，在placesArray中寻找北京（level1=0）与河北省（level2=0）判断条件level1=level2，把这两者中间的数据保存起来，或者北京市市辖区（level1=1）与河北省（level2=0）之间的数据，判断条件level1>level2
         */
        // 起始index
        NSInteger startIndex = indexPath.row + 1;
        // 终止index并赋初值self.viewModel.placesArray.count
        NSInteger endIndex = self.viewModel.placesArray.count;
        // 保存删除的model
        NSMutableArray<MultiLevelModel *> *modelArray = [NSMutableArray array];
        // 保存indexPath
        NSMutableArray<NSIndexPath *> *indexPathArray = [NSMutableArray array];
        
        for (NSInteger i = startIndex; i < self.viewModel.placesArray.count; i++) {
            MultiLevelModel *tmpModel = self.viewModel.placesArray[i];
            if (model.level >= tmpModel.level) {
                endIndex = i;
                break;
            }
            // 添加各indexPath
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [indexPathArray addObject:tmpIndexPath];
            // 添加model
            [modelArray addObject:tmpModel];
        }
        NSInteger length = endIndex - startIndex;
        if (length == 0) {
            return;
        }
//        modelArray = [self.viewModel.placesArray subarrayWithRange:NSMakeRange(startIndex, length)];
        self.viewModel.statesDictionary[model.code] = modelArray;
        // 操作数据源
        [self.viewModel.placesArray removeObjectsInRange:NSMakeRange(startIndex, length)];
        // 删除行
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } else {
#pragma mark - 展开级联
        model.isExpanded = YES;
        // 执行箭头旋转动画
        [cell makeArrowImgViewRotation:M_PI / 2];
        
        NSArray *modelArray = @[];
        for (NSString *placeCode in self.viewModel.statesDictionary.allKeys) {
            if ([placeCode isEqualToString:model.code]) {
                modelArray = self.viewModel.statesDictionary[model.code];
                break;
            }
        }
        // 没有匹配到
        if (modelArray.count == 0) {
            modelArray = model.children;
            // 计算level
            for (MultiLevelModel *subModel in modelArray) {
                subModel.level = model.level + 1;
            }
        }
        // 增加行
        NSMutableArray<NSIndexPath *> *indexPathArray = [NSMutableArray array];
        for (int i = 0; i < modelArray.count; i++) {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 + i inSection:0];
            [indexPathArray addObject:tmpIndexPath];
            // 插入数据model
            [self.viewModel.placesArray insertObject:modelArray[i] atIndex:indexPath.row + 1 + i];
        }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

#pragma mark - 懒加载
- (MultiLevelViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MultiLevelViewModel alloc] init];
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
