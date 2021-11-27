//
//  MultiLevelViewController.m
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import "MultiLevelViewController.h"
#import "MultiLevelViewModel.h"
#import "MultiLevelCell.h"

@interface MultiLevelViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MultiLevelViewModel *viewModel;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MultiLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view. backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
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
        self.callBack(model);
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
        NSInteger startIndex = indexPath.row + 1;
        NSInteger endIndex = startIndex;
        NSArray *tmpArray = @[];
        for (NSInteger i = startIndex; i < self.viewModel.placesArray.count; i++) {
            MultiLevelModel *tmpModel = self.viewModel.placesArray[i];
            if (model.level >= tmpModel.level) {
                endIndex = i;
                break;
            }
        }
        NSInteger length = endIndex - startIndex;
        if (length == 0) {
            return;
        }
        tmpArray = [self.viewModel.placesArray subarrayWithRange:NSMakeRange(startIndex, length)];
        self.viewModel.statesDictionary[model.code] = tmpArray;
        // 操作数据源
        [self.viewModel.placesArray removeObjectsInRange:NSMakeRange(indexPath.row + 1, length)];
        // 删除行
        NSMutableArray *marray = [[NSMutableArray alloc] init];
        for (int i = 0; i < tmpArray.count; i++) {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 + i inSection:0];
            [marray addObject:tmpIndexPath];
        }
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:marray withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } else {
#pragma mark - 展开级联
        model.isExpanded = YES;
        // 执行箭头旋转动画
        [cell makeArrowImgViewRotation:M_PI / 2];
        
        NSArray *tmpArray = @[];
        for (NSString *placeCode in self.viewModel.statesDictionary.allKeys) {
            if ([placeCode isEqualToString:model.code]) {
                tmpArray = self.viewModel.statesDictionary[model.code];
                break;
            }
        }
        // 没有匹配到
        if (tmpArray.count == 0) {
            tmpArray = model.children;
            for (MultiLevelModel *subModel in tmpArray) {
                subModel.level = model.level + 1;
            }
        }
        // 操作数据源
        [self.viewModel.placesArray insertObjects:tmpArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexPath.row + 1, tmpArray.count)]];
        // 增加行
        NSMutableArray *marray = [[NSMutableArray alloc] init];
        for (int i = 0; i < tmpArray.count; i++) {
            NSIndexPath *tmpIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 + i inSection:0];
            [marray addObject:tmpIndexPath];
        }
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:marray withRowAnimation:UITableViewRowAnimationAutomatic];
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
