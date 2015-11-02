//
//  DetailViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

//个人中心

#import "MyViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "HeUserVC.h"
#import "CustomNavigationController.h"

@interface MyViewController (){
    NSMutableArray *arrays;
    int bookOrderType;
}
@end
@implementation MyViewController
@synthesize dataArray;
@synthesize showTextLabel;
@synthesize defaults;
@synthesize scoreLb;
@synthesize refreshLb;
@synthesize isToRefresh;

@synthesize loginBtn;
@synthesize userInfoView;
@synthesize portrait;
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self changeThirdTab];
    return;
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    arrays = [[NSMutableArray alloc] init];//初始化
    self.navigationController.navigationBar.hidden = YES;
    
    defaults =[NSUserDefaults standardUserDefaults];//读取本地化存储
    self.view.backgroundColor = VIEWBGCOLOR;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT, MAINSCREEN_WIDTH, self.view.frame.size.height-addStatusBarHeight - 49 - TOPNAVIHEIGHT)];//上半部分
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.userInteractionEnabled = YES;
    scrollView.delegate = self;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height-addStatusBarHeight);
    [self.view addSubview:scrollView];
    
    //下拉刷新的隐藏按钮
    refreshLb = [[UILabel alloc] initWithFrame:CGRectMake(0, -84, MAINSCREEN_WIDTH, 84)];
    refreshLb.text = @"下拉即可刷新...";
    refreshLb.textColor = [UIColor grayColor];
    refreshLb.font = TEXTFONT;
    refreshLb.backgroundColor = [UIColor clearColor];//背景透明色
    refreshLb.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:refreshLb];//
    
    UIImageView *loginBgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 109)];
    [loginBgImg setImage:[UIImage imageNamed:@"myBg1"]];
    loginBgImg.userInteractionEnabled = YES;
    [scrollView addSubview:loginBgImg];
    
    loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(110, 37, 100, 35)];
    [scrollView addSubview:loginBtn];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    loginBtn.backgroundColor = [UIColor whiteColor];
    [loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(onClickLogin) forControlEvents:UIControlEventTouchUpInside];
    
    //登录成功后显示的个人的账户信息
    userInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 109)];
    [scrollView addSubview:userInfoView];
    userInfoView.hidden = YES;
    userInfoView.userInteractionEnabled = YES;

    //头像
    portrait = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 79, 79)];
    [userInfoView addSubview:portrait];
    portrait.userInteractionEnabled = YES;
    portrait.image = [UIImage imageNamed:@"portrait"];
    //头像文件
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
    //头像文件存在
    if ([fileManager fileExistsAtPath:filePath]) {
        portrait.image = [UIImage imageWithContentsOfFile:filePath];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCamera)];
    [portrait addGestureRecognizer:tap];
    
    //账户名
    showTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 150, 25)];
    showTextLabel.backgroundColor = [UIColor clearColor];
    [userInfoView addSubview:showTextLabel];
    
    //积分
    scoreLb = [[UILabel alloc] initWithFrame:CGRectMake(100, 45, 160, 25)];
    [userInfoView addSubview:scoreLb];
    scoreLb.backgroundColor = [UIColor clearColor];
    scoreLb.text = @"金萝卜:";
    
    UILabel *memberScore = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 100, 25)];
    memberScore.backgroundColor = [UIColor clearColor];
    memberScore.font = [UIFont systemFontOfSize:15];
    [scoreLb addSubview:memberScore];
    
    //签到按钮
    UIButton *signBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 70, 60, 25)];
    [userInfoView addSubview:signBtn];
    [signBtn.layer setMasksToBounds:YES];
    [signBtn.layer setCornerRadius:2];//设置矩形四个圆角半径
    signBtn.titleLabel.font = TEXTFONT;
    signBtn.tag = 108;//签到页面的
    signBtn.backgroundColor = [UIColor whiteColor];
    [signBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [signBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [signBtn addTarget:self action:@selector(toSignInView) forControlEvents:UIControlEventTouchUpInside];
    //退出按钮
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(240, 70, 60, 25)];
    [userInfoView addSubview:logoutBtn];
    [logoutBtn.layer setMasksToBounds:YES];
    [logoutBtn.layer setCornerRadius:2];//设置矩形四个圆角半径
    logoutBtn.titleLabel.font = TEXTFONT;
    logoutBtn.backgroundColor = [UIColor whiteColor];
    [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [logoutBtn addTarget:self action:@selector(onClickLogout) forControlEvents:UIControlEventTouchUpInside];

    //设置里的Item区域
    int createViewHeight = [self createItemView].frame.size.height;
    UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 109, MAINSCREEN_WIDTH, createViewHeight)];
    [tempView addSubview:[self createItemView]];//创建视图

    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, createViewHeight + 109 - 10);

    [scrollView addSubview:tempView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScore:) name:@"addBlareScore" object:nil];//view 之间的消息传递
}

- (void)changeThirdTab
{
    NSArray *tabBarVCArray = self.tabBarController.viewControllers;
    HeUserVC *merchantVC = [[HeUserVC alloc] initWithNibName:nil bundle:nil];
    CustomNavigationController *userCenterNav = [[CustomNavigationController alloc] initWithRootViewController:merchantVC];
    userCenterNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"main_bottom_tab_personal_normal"] tag:3];
    UIImage *myImage = [UIImage imageNamed:@"main_bottom_tab_personal_focus"];
    
    if (iOS7) {
        userCenterNav.tabBarItem.selectedImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }else{
        [userCenterNav.tabBarItem setFinishedSelectedImage:myImage
                               withFinishedUnselectedImage:[UIImage imageNamed:@"main_bottom_tab_personal_normal"]];
    }
    
    //    //默认字体颜色 选中为红色,未选中黑色
    UIColor *rightColor = TABBARSELECTEDCOLOR;
    [userCenterNav.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                      rightColor, UITextAttributeTextColor, nil]
                                            forState:UIControlStateNormal];
    
    NSMutableArray *newTabBarVCArray = [[NSMutableArray alloc] initWithArray:tabBarVCArray];
    [newTabBarVCArray removeObjectAtIndex:3];
    [newTabBarVCArray insertObject:userCenterNav atIndex:3];
    self.tabBarController.viewControllers = newTabBarVCArray;
}

//修改标题,重写父类方法
-(NSString*)getTitle
{
    return @"个人中心";
}

//重写父类方法
-(void)onClickBack
{
    [self.tabBarController setSelectedIndex:0];
    [self setBarItemSelectedIndex:0];
}

-(void)setBarItemSelectedIndex:(NSUInteger)selectedIndex
{
    for (int i = 0; i < 5; i++) {
        UIColor *rightColor = (i==selectedIndex) ? TABBARSELECTEDCOLOR : TABBARDEFAULTCOLOR;
        [(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:rightColor, UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    }
}

//每次页面显示时执行
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    return;
    [Tools initPush];
    [self showViewByLogin];
}

//判断是否登录
-(void)showViewByLogin{
    //当前登录状态
    NSString * userName = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
    if(userName.length==0){
        userName = @"点击登录";
        //[logoutBtn setHidden:YES];//隐藏退出按钮
        userInfoView.hidden = YES;
        loginBtn.hidden = NO;
    }else{
        userInfoView.hidden = NO;
        loginBtn.hidden = YES;
        showTextLabel.text = userName;
        UILabel *memberScore = [[scoreLb subviews] objectAtIndex:0];
        //刷新积分
        [Waiting show];
        AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        NSDictionary * params = @{@"apiid": @"0085",@"memberid" : userName};
        NSURLRequest * request = [client requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];//隐藏loadin
            NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if(score.length>0){
                memberScore.text = score;
            }else{
                [self.view makeToast:@"系统错误,请稍后重试" duration:2.0 position:@"center"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];//隐藏loading
            [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        }];
        [operation start];
    }
}

- (UIView *)createItemView{
    UIView *areaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 330)];
    areaView.backgroundColor = VIEWBGCOLOR;
    
    NSInteger itemHeight = 40;
    //"订单中心"
    UIView *bgView               = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MAINSCREEN_WIDTH, itemHeight)];
    bgView.backgroundColor       = [UIColor whiteColor];
    [areaView addSubview:bgView];
    
    UILabel *orderTitleLb        = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, itemHeight)];
    [areaView addSubview:orderTitleLb];
    [orderTitleLb setBackgroundColor:[UIColor clearColor]];
    orderTitleLb.text            = @"订单中心";
    
    //分界线
    UILabel *border1 = [[UILabel alloc] initWithFrame:CGRectMake(10, itemHeight-1, MAINSCREEN_WIDTH-20, 1)];
    [bgView addSubview:border1];
    border1.backgroundColor = VIEWBGCOLOR;
    
    UIView *orderTitleView                 = [[UIView alloc] initWithFrame:CGRectMake(0, 50, MAINSCREEN_WIDTH, itemHeight)];
    [areaView addSubview:orderTitleView];
    orderTitleView.userInteractionEnabled  = YES;
    orderTitleView.backgroundColor         = [UIColor whiteColor];
    orderTitleView.tag                     = 100;
    orderTitleView.accessibilityIdentifier = @"0";//--赋值给  orderListType
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickToView:)];
    [orderTitleView addGestureRecognizer:singleTap];//---添加点击事件
    
    UILabel *myOrderT = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, itemHeight)];
    [orderTitleView addSubview:myOrderT];
    myOrderT.text = @"我的网购";
    
    UIImageView *chevronImage = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 40, 14, 10, 15)];
    [orderTitleView addSubview:chevronImage];
    [chevronImage setImage:[UIImage imageNamed:@"chevron_right"]];
    
    UIImageView *myOrderIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 22, 22)];
    myOrderIcon.image = [UIImage imageNamed:@"icon_13"];
    [orderTitleView addSubview:myOrderIcon];
    
    //分界线
    UILabel *border2 = [[UILabel alloc] initWithFrame:CGRectMake(10, itemHeight-1, MAINSCREEN_WIDTH-20, 1)];
    [orderTitleView addSubview:border2];
    border2.backgroundColor = VIEWBGCOLOR;
    
    UIView *orderTitleView_                 = [[UIView alloc] initWithFrame:CGRectMake(0, 90, MAINSCREEN_WIDTH, itemHeight)];
    [areaView addSubview:orderTitleView_];
    orderTitleView_.userInteractionEnabled  = YES;
    orderTitleView_.backgroundColor         = [UIColor whiteColor];
    orderTitleView_.tag                     = 1100;
    orderTitleView_.accessibilityIdentifier = @"0";//赋值给  orderListType
    
    UITapGestureRecognizer *singleTap_ =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickToView:)];
    [orderTitleView_ addGestureRecognizer:singleTap_];//---添加点击事件
    
    UILabel *orderTitleLb_ = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 100, itemHeight)];
    [orderTitleView_ addSubview:orderTitleLb_];
    orderTitleLb_.text     = @"我的预订";
    
    UIImageView *orderChevronImage = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 40, 14, 10, 15)];
    [orderTitleView_ addSubview:orderChevronImage];
    [orderChevronImage setImage:[UIImage imageNamed:@"chevron_right"]];
    
    UIImageView *orderTitleIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 22, 22)];
    orderTitleIcon.image        = [UIImage imageNamed:@"icon_11"];
    [orderTitleView_ addSubview:orderTitleIcon];
    
    //账户中心
    NSArray *titleArr = @[@"我的收藏",@"我的钱包",@"我的代金券",@"我的卡券",@"我的收货地址",@"账户安全",@"资讯中心",@"泉眼产品销售统计",@"送酒活动统计",@"送酒活动审核",@"关于单耳兔"];
    NSArray *iconArr = @[@"my_favorite",@"my_wallet",@"my_coupon",@"icon_2",@"my_address",@"my_account",@"my_news",@"icon_15",@"wineActive",@"wine_check",@"setting_Icon"];
    NSInteger itemNum                  = titleArr.count;
    UIView *accountArea                = [[UIView alloc] initWithFrame:CGRectMake(0, 140, MAINSCREEN_WIDTH, itemHeight*(itemNum+1))];
    [areaView addSubview:accountArea];
    accountArea.backgroundColor        = [UIColor whiteColor];
    accountArea.userInteractionEnabled = YES;
    
    UILabel *accountTitleLb        = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, MAINSCREEN_WIDTH, itemHeight)];
    [accountArea addSubview:accountTitleLb];
    accountTitleLb.backgroundColor = [UIColor whiteColor];
    accountTitleLb.text            = @"账户中心";
    
    for (int i=0; i<itemNum; i++) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 40*(i+1), MAINSCREEN_WIDTH, 40)];
        itemView.backgroundColor = [UIColor whiteColor];
        itemView.userInteractionEnabled = YES;
        [accountArea addSubview:itemView];
        itemView.tag = 100+1+i;
        
        UIImageView *icon9 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 22, 22)];
        icon9.image = [UIImage imageNamed:iconArr[i]];
        [itemView addSubview:icon9];
        
        UILabel *text9 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 250, 39)];
        text9.text = titleArr[i];
        [itemView addSubview:text9];//text
        
        UIImageView *gtChevronImage = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 40, 14, 10, 15)];
        [itemView addSubview:gtChevronImage];
        [gtChevronImage setImage:[UIImage imageNamed:@"chevron_right"]];
        
        UILabel *line9 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.6, MAINSCREEN_WIDTH-20, 0.6)];
        line9.backgroundColor = BORDERCOLOR;
        [itemView addSubview:line9];//line
        
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickToView:)];
        [itemView addGestureRecognizer:singleTap];//---添加大图片点击事
    }
    
    //金萝卜中心
    UIView *turnipArea = [[UIView alloc] initWithFrame:CGRectMake(0, 140+accountArea.frame.size.height+10, MAINSCREEN_WIDTH, 120)];
    [areaView addSubview:turnipArea];
    
    UIView *turnipTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, itemHeight)];
    [turnipArea addSubview:turnipTitleView];
    turnipTitleView.userInteractionEnabled = YES;
    turnipTitleView.backgroundColor = [UIColor whiteColor];
    turnipTitleView.tag = 100+1+itemNum;
    UITapGestureRecognizer *singleTap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickToView:)];
    [turnipTitleView addGestureRecognizer:singleTap1];//---添加大图片点击事
    
    UILabel *turnipTitleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, itemHeight)];
    [turnipTitleView addSubview:turnipTitleLb];
    turnipTitleLb.text = @"金萝卜中心";
    
    UILabel *ruleLb = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 90, itemHeight)];
    [turnipTitleView addSubview:ruleLb];
    ruleLb.textColor = [UIColor grayColor];
    ruleLb.font = TEXTFONT;
    ruleLb.text = @"金萝卜规则  >";
    
    NSArray *titleArr_turnip = @[@"金萝卜",@"签到"];
    NSArray *iconArr_turnip = @[@"my_turnip",@"my_sign"];
    NSInteger itemNum_turnip = titleArr_turnip.count;
    for (int i=0; i<itemNum_turnip; i++) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 40*(i+1), MAINSCREEN_WIDTH, 40)];
        itemView.backgroundColor = [UIColor whiteColor];
        itemView.userInteractionEnabled = YES;
        [turnipArea addSubview:itemView];
        itemView.tag = turnipTitleView.tag+1+i;
        
        UIImageView *icon9 = [[UIImageView alloc] initWithFrame:CGRectMake(15, 9, 22, 22)];
        icon9.image = [UIImage imageNamed:iconArr_turnip[i]];
        [itemView addSubview:icon9];
        
        UILabel *text9 = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 39)];
        text9.text = titleArr_turnip[i];
        [itemView addSubview:text9];//text
        
        UIImageView *gtChevronImage = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 40, 14, 10, 15)];
        [itemView addSubview:gtChevronImage];
        [gtChevronImage setImage:[UIImage imageNamed:@"chevron_right"]];
        
        UILabel *line9 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0.6, MAINSCREEN_WIDTH-20, 0.6)];
        line9.backgroundColor = BORDERCOLOR;
        [itemView addSubview:line9];//line
        
        
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickToView:)];
        [itemView addGestureRecognizer:singleTap];//---添加大图片点击事
    }
    
    
    int totalH = 130+accountArea.frame.size.height+turnipArea.frame.size.height+40;
    areaView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, totalH);
    return areaView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollViewTmp
{
    isToRefresh = NO;
    refreshLb.text = @"下拉即可刷新...";
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollViewTmp
{
    if (scrollViewTmp.contentOffset.y<-100) {
        isToRefresh = YES;
        refreshLb.text = @"释放即可刷新...";
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollViewTmp
{
    if(isToRefresh==YES){
        [self showViewByLogin];//-----刷新数据-----刷新积分-----
    }
}

//-----登录成功
-(void)dismissAllModalViewControllers:(NSNotification*) notification{
    userInfoView.hidden = NO;
    loginBtn.hidden = YES;
//    UILabel *asd = [notification object];//两种方法传值
    NSDictionary *nd = notification.userInfo;
    showTextLabel.text = [nd objectForKey:@"MemLoginID"];
    ((UILabel*)[[scoreLb subviews] objectAtIndex:0]).text = [nd objectForKey:@"Score"];
    //[logoutBtn setHidden:NO];
}
//----吼一吼加分
-(void)changeScore:(NSNotification*) notification{
    NSDictionary *nd = notification.userInfo;
    UILabel *temp = ((UILabel*)[[scoreLb subviews] objectAtIndex:0]);
    temp.text = [NSString stringWithFormat:@"%d",[[nd objectForKey:@"Score"] intValue]] ;
}
//-----点击登录
-(void)onClickLogin{
    //NSLog(@"----------rewr43t43t43t   %@---%d",[defaults objectForKey:@"userLoginInfo"],[[defaults objectForKey:@"userLoginInfo"] count]);
    if(![defaults objectForKey:@"userLoginInfo"]){
        LoginViewController *loginV = [[LoginViewController alloc] init];
        loginV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginV animated:YES];
    }
}
//----按钮点击事件,,单独分开,,跳转到签到页面----
-(void)toSignInView{
    
    SignInController *signV = [[SignInController alloc] init];
    signV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:signV animated:YES];
    
}
//----跳转到另一页面----
-(void)onClickToView:(id)sender{
    UIView *temp = [sender view];
    //按照排版顺序依次是:
    //  订单中心,我的收藏,我的代金券,我的收获地址,账户安全,资讯中心,金萝卜规则,金萝卜,签到
    NSArray *identifierArr = @[@"OrderListController",@"FavoriteViewController",@"WalletViewController",@"WebViewController",@"WebViewController",@"AddressListController",@"AccountSecurityController",@"AnnouncementController",@"WebViewController",@"WineActiveInfoViewController",@"WebViewController",@"SettingsViewController",@"WebViewController",@"GoldCarrotController",@"SignInController"];
    NSInteger index = temp.tag - 100;
    if (index < 100) {
        id myObj = [[NSClassFromString(identifierArr[index]) alloc] init];
        
        //此处不需要登录
        if ([myObj isKindOfClass:[SettingsViewController class]]) {
            ((SettingsViewController *)myObj).hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:(SettingsViewController *)myObj animated:YES];
            return;
        }
        
        if (![defaults objectForKey:@"userLoginInfo"]) {
            [self onClickLogin];//---跳转登录
        }else{
//            id myObj = [[NSClassFromString(identifierArr[index]) alloc] init];
            if (myObj) {
                NSLog(@"fiweojfeiowjfow-----%@",myObj);
                if ([myObj isKindOfClass:[WebViewController class]]) {
                    NSString *title,*url,*type = @"webUrl";
                    switch (index) {
                        case 3:
                            title = @"我的代金券";
                            url = @"person_coupon_list.html";
                            break;
                        case 4:
                            title = @"我的卡券";
                            url = @"discount_list.html";
                            break;
                        case 8:
                            title = @"泉眼产品销售";
                            url = @"sell_detail.html";
                            break;
                        case 10:
                            ((WebViewController *)myObj).agentid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"];
                            ((WebViewController *)myObj).isCheckJiu = YES;
                            ((WebViewController *)myObj).narBarOffsetY = 50;
                            
                            title = @"送酒活动审核";
                            url = @"check_jiu.html";
                            break;
                        case 12:
                            title = @"金萝卜活动";
                            url = @"principle.html";
                            break;
                        default:
                            break;
                    }
                    ((WebViewController *)myObj).webTitle = title;
                    ((WebViewController *)myObj).webURL = url;
                    ((WebViewController *)myObj).webType =  type;
                }
                else if([myObj isKindOfClass:[WalletViewController class]]) {
                    ((WalletViewController *)myObj).webTitle = @"我的钱包";
                    ((WalletViewController *)myObj).webURL = @"wallet_index1.html?34";
                    ((WalletViewController *)myObj).webType =  @"webUrl";
                }
                else if ([myObj isKindOfClass:[OrderListController class]]) {
                    ((OrderListController *)myObj).currentItemTag =  [temp.accessibilityIdentifier intValue];
                }
                ((UIViewController *)myObj).hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:(UIViewController *)myObj animated:YES];
            }else{
                [self.view makeToast:@"功能未完善" duration:1.2 position:@"center"];
            }
        }
        
    }else{
        //-----后来新增的安排特定的tag值-------
        if (index==1000) {
            if ([defaults objectForKey:@"userLoginInfo"]) {
                bookOrderType = [temp.accessibilityIdentifier intValue];
                
                BookOrderController *orderController = [[BookOrderController alloc] init];
                orderController.hidesBottomBarWhenPushed = YES;
                orderController.currentItemTag =  bookOrderType;
                [self.navigationController pushViewController:orderController animated:YES];
            }else{
                [self onClickLogin];//---跳转登录
            }
        }
    }
}

//-----账户安全
-(void)onClickAccount{
    
    AccountSecurityController *account = [[AccountSecurityController alloc] init];
    account.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:account animated:YES];
}
//-----吼出积分onClickBlare
-(void)onClickBlare:(id)sender{
    if([defaults objectForKey:@"userLoginInfo"]){
        /*
         GameBlareController *gameView = [[GameBlareController alloc] init];//---gameview
         */
        [defaults removeObjectForKey:@"gameBlareShopId"];//------为自己吼,取消gameBlareShopId值,,,,
        GameBlareController *gameV = [[GameBlareController alloc] init];
        [self.navigationController pushViewController:gameV animated:YES];
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"gameBlare" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"forMe",@"infoStr",nil]];//和吼一吼view直接的传递消息
    }else{
        
        LoginViewController *loginV = [[LoginViewController alloc] init];
        loginV.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginV animated:YES];
    }
}

//----------点击退出-------
-(void)onClickLogout{
    if([defaults objectForKey:@"userLoginInfo"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"确认要退出当前账户吗"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"退出"];
        [alert setTag:1];
        [alert show];
    }else{
        [self.view makeToast:@"您还未登录" duration:2.0 position:@"center"];
    }
}
//----------确定清空
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] ==1 ) {
        if(buttonIndex==1){
            userInfoView.hidden = YES;
            loginBtn.hidden = NO;
            [defaults removeObjectForKey:@"userLoginInfo"];
            [Tools initPush];
        }
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


//----------打开相机,获取照片---------
-(void)openCamera
{
    if (iOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //取消
        }];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self takePhoto];
        }];
        
        UIAlertAction *libAction = [UIAlertAction actionWithTitle:@"从手机相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self LocalPhoto];
        }];
        
        // Add the actions.
        [alertController addAction:cameraAction];
        [alertController addAction:libAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                        initWithTitle:nil
                                        delegate:self
                                        cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
        [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == actionSheet.cancelButtonIndex){
        
        NSLog(@"取消");
    }
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }}
//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}
//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        NSString *base = [data base64Encoding];
        NSLog(@"jgreojpopewfpkhtph----%@\n\n--%@\n\n----%@",base,data,filePath);
        [self dismissViewControllerAnimated:YES completion:nil];
        portrait.image = image;
    }
}
//----------点击取消-------
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];    
}
@end
