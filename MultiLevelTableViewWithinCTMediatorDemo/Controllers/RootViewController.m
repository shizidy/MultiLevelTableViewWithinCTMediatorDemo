//
//  RootViewController.m
//  MutiLevelTableViewDemo
//
//  Created by wdyzmx on 2021/11/25.
//

#import "RootViewController.h"
#import "CTMediator+MultiLevel.h"
#import "CTMediator+MultiLevelCraft.h"
#import "MultiLevelModel.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建button1
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    [self.view addSubview:button1];
    CGPoint point1 = self.view.center;
    point1.y -= 40;
    button1.center = point1;
    button1.backgroundColor = UIColor.redColor;
    button1.titleLabel.font = [UIFont systemFontOfSize:16];
    button1.tag = 1;
    [button1 setTitle:@"多层级城市选择器样式" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 创建button2
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    [self.view addSubview:button2];
    CGPoint point2 = self.view.center;
    point2.y += 40;
    button2.center = point2;
    button2.backgroundColor = UIColor.redColor;
    button2.titleLabel.font = [UIFont systemFontOfSize:16];
    button2.tag = 2;
    [button2 setTitle:@"不定层级样式" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void)buttonAction:(UIButton *)btn {
    if (btn.tag == 1) {
        UIViewController *viewController = [[CTMediator sharedInstance] CTMediator_MultiLevelControllerWithCallBack:^(id _Nonnull obj) {
            if ([obj isKindOfClass:[MultiLevelModel class]]) {
                MultiLevelModel *model = obj;
                NSLog(@"您的选择：%@", model.name);
            }
        }];
        [[CTMediator sharedInstance] pushViewController:viewController animated:YES];
    }
    
    if (btn.tag == 2) {
        UIViewController *viewController = [[CTMediator sharedInstance] CTMediator_MultiLevelCraftViewControllerWithCallBack:^(id _Nonnull obj) {
            if ([obj isKindOfClass:[MultiLevelCraftModel class]]) {
                MultiLevelModel *model = obj;
                NSLog(@"您的选择：%@", model.name);
            }
        }];
        [[CTMediator sharedInstance] pushViewController:viewController animated:YES];
    }
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
