//
//  TabBarController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-5.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

@synthesize trackViewURL;

- (void)viewDidLoad
{
    //---app 版本检测
    //[self checkVersion];//---通关连接apple store来判断,如果连接不上,程序可能被卡死

    //---购物车  角标
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    int shopCatWoodsCount = [[defaults objectForKey:SHOPCATWOODSCOUNT] intValue];
    if(shopCatWoodsCount>0){
        [[self.tabBar.items objectAtIndex:SHOPCATINDEX] setBadgeValue:[NSString stringWithFormat:@"%d",shopCatWoodsCount]];//设置badge,购物车角标
    }
    UIDevice *device_ = [UIDevice currentDevice];
    
    self.tabBar.selectedImageTintColor = [UIColor redColor];//当前的tabbar颜色
    if([device_.systemVersion floatValue] >= 7){
        self.tabBar.barTintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];//背景色
        self.tabBar.translucent = NO;//不透明
    }else{
        self.tabBar.tintColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];//背景色
    }
    //tabbar  item 图标,
    NSArray *itemImages = [NSArray arrayWithObjects:@"main_bottom_tab_home_normal",@"main_bottom_tab_category_normal",@"main_bottom_tab_cart_normal",@"main_bottom_tab_personal_normal",@"main_bottom_tab_share_normal",@"main_bottom_tab_home_focus",@"main_bottom_tab_category_focus",@"main_bottom_tab_cart_focus",@"main_bottom_tab_personal_focus",@"main_bottom_tab_share_focus",@"商城",@"分类",@"购物车",@"我的",@"分享", nil];
    CGFloat itemCount = itemImages.count / 3.0;
    for (int i = 0; i < itemCount; i++) {
        UITabBarItem* item = [self.tabBar.items objectAtIndex:i];
        item.tag = i;
        
        NSString *path  = [NSString stringWithFormat:@"%@.png",[itemImages objectAtIndex:i + itemCount]];
        UIImage *myImage = [UIImage imageNamed:path];
        
        if (iOS7) {
            item.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[itemImages objectAtIndex:i]]];
            item.selectedImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else{
            [item setFinishedSelectedImage:myImage
               withFinishedUnselectedImage:[UIImage imageNamed:[itemImages objectAtIndex:i]]];
        }
        
        //默认字体颜色 选中为红色,未选中黑色
        UIColor *rightColor = (i == 0) ? TABBARSELECTEDCOLOR : TABBARDEFAULTCOLOR;
        [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                      rightColor, UITextAttributeTextColor, nil]
                            forState:UIControlStateNormal];
    }
}

//------点击tabbar--------
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
    for (int i = 0; i < 5; i++) {
        UIColor *rightColor = (i == item.tag) ? TABBARSELECTEDCOLOR : TABBARDEFAULTCOLOR;
        [(UITabBarItem *)[[tabBar items] objectAtIndex:i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:rightColor, UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    }
    
    //[self.navigationController popToRootViewControllerAnimated:NO];
    //NSLog(@"jgoepjgorpejgp----ewgf-----%@",kk.navigationController.viewControllers);
    //[kk.navigationController popToRootViewControllerAnimated:NO];
}
/*
//-----跳转tabbar的时候直接到 root,比如从  购物  到  商城,显示商城第一层,不会显示商城的  detail等层
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    //[self.navigationController popToRootViewControllerAnimated:NO];
    //NSLog(@"jgoepjgorpejgp----ewgf-----%@",kk.navigationController.viewControllers);
    //[kk.navigationController popToRootViewControllerAnimated:NO];
    NSLog(@"jgoepjgorpejgp----%@-----%@",tabBar,item);
}
-(void)checkVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    //CFShow((__bridge CFTypeRef)(infoDic));
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:APP_URL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:recervedData options:NSJSONReadingMutableLeaves error:nil];//json解析
    
    NSLog(@"nveowjfiowejfoi------currentVersion:%@-----APP_URL:%@---results:%@-----dic:%@---",currentVersion,APP_URL,results,dic);
    
    NSArray *infoArray = [dic objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion]) {
            trackViewURL = [releaseInfo objectForKey:@"trackVireUrl"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
            alert.tag = 10000;
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 10001;
            [alert show];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==10000) {
        if (buttonIndex==1) {
            NSURL *url = [NSURL URLWithString:trackViewURL];
            [[UIApplication sharedApplication]openURL:url];
        }
    }
}
*/
@end
