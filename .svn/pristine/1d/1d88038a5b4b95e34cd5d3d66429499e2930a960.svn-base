//
//  HeTestShopVC.m
//  单耳兔
//
//  Created by Tony on 15/9/22.
//  Copyright © 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "HeTestShopVC.h"
#import "UIButton+Bootstrap.h"
#import "DetailViewController.h"

@interface HeTestShopVC ()

@end

@implementation HeTestShopVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat buttonX = 100;
    CGFloat buttonY = 100;
    CGFloat buttonW = 100;
    CGFloat buttonH = 40;
    CGFloat buttonD = 20;
    for (int i = 0; i < 7; i++) {
        UIButton *button = [[UIButton alloc] init];
        buttonY = 100 + i * (buttonH + buttonD);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [button.titleLabel setText:[NSString stringWithFormat:@"%d",i+1]];
        [button setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
        [button dangerStyle];
        button.tag = i + 1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }
}

- (void)buttonClick:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    NSString *filename = [NSString stringWithFormat:@"shop_template_%ld.html",tag];
    DetailViewController *detailVC = [[DetailViewController alloc] initWithFileName:filename];
    detailVC.agentid = @"13557013342";
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
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
