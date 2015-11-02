//
//  HeBaseViewController.m
//  单耳兔
//
//  Created by Tony on 15/7/17.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "HeBaseViewController.h"
#import "KKAppDelegate.h"
@interface HeBaseViewController ()

@end

@implementation HeBaseViewController

- (void)viewDidLoad {
    
    if (iOS7) {
//        UILabel *addStatusBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 20)];
//        addStatusBar.backgroundColor = [UIColor blackColor];
//        [self.view addSubview:addStatusBar];
    }else{
        UILabel *addStatusBar = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, MAINSCREEN_WIDTH, 20)];
        addStatusBar.backgroundColor = TOPNAVIBGCOLOR;
        [self.view addSubview:addStatusBar];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [((KKAppDelegate *)[UIApplication sharedApplication].delegate).window makeKeyAndVisible];
    self.navigationController.navigationBar.hidden = YES;
    NSInteger addStatusBarHeight = STATUSBAR_HEIGHT;
    CGFloat navgationBarHeight = 44;
    UIView *topNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, navgationBarHeight+addStatusBarHeight)];
    topNavi.backgroundColor = TOPNAVIBGCOLOR;
    topNavi.userInteractionEnabled = YES;
    [self.view addSubview:topNavi];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //代理置空，否则会闪退
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //开启iOS7的滑动返回效果
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        //只有在二级页面生效
        if ([self.navigationController.viewControllers count] >= 2) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
        else{
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    else{
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
