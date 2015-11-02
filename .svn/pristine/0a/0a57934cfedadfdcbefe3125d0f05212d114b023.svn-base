//
//  HeUserVC.m
//  单耳兔
//
//  Created by iMac on 15/6/30.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "HeUserVC.h"
#import "TopNaviViewController.h"
#import "HeSettingVC.h"
#import "UIButton+Bootstrap.h"
#import "UIButton+WebCache.h"
#import "SignInController.h"
#import "SellCenterViewController.h"
#import "Waiting.h"
#import "Tools.h"

@interface HeUserVC ()
{
    NSInteger addStatusBarHeight;
    NSArray *iconArr;
    NSArray *tableItemArr;
}

@property(strong,nonatomic)UITableView *myTableView;
@property(strong,nonatomic)UIImageView *portrait; //用户头像
@property(strong,nonatomic)UIButton *loginBtn;
@property(strong,nonatomic)UILabel *myScoreLabel; // 我的积分
@property(strong,nonatomic)UILabel *userNameLabel; // 用户名
@property(strong,nonatomic)NSArray *viewControllerArray;

@end

@implementation HeUserVC
@synthesize myTableView;
@synthesize portrait;
@synthesize loginBtn;
@synthesize myScoreLabel;
@synthesize userNameLabel;
@synthesize viewControllerArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initialization];
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [Tools initPush];
    [self showViewByLogin];
    [self showVipCustomer];
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
        if ([self.navigationController.viewControllers count] == 2) {
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            self.navigationController.interactivePopGestureRecognizer.delegate = self;
        }
    }
}

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


-(BOOL)isShowFinishButton{
    return YES;
}

- (NSString*)getFinishBtnTitle{
    return @"设置";
}
//设置
- (void) clickFinish{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults objectForKey:@"userLoginInfo"]) {
        //如果没有登录，跳登录界面
        [self onClickLogin];
    }
    else{
        HeSettingVC *settingVC = [[HeSettingVC alloc] init];
        settingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:settingVC animated:YES];
    }
}

-(void)showViewByLogin{
    //当前登录状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * userName = [[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];//本地存储
    if(userName.length == 0){
        userName = @"点击登录";
        loginBtn.hidden = NO;
        //签到的按钮
        userNameLabel.hidden = YES;
        myScoreLabel.hidden = YES;
        [[myTableView.tableHeaderView viewWithTag:100] viewWithTag:108].hidden = YES;
    }else{
        //签到的按钮
        userNameLabel.hidden = NO;
        myScoreLabel.hidden = NO;
        [[myTableView.tableHeaderView viewWithTag:100] viewWithTag:108].hidden = NO;
        loginBtn.hidden = YES;
        userNameLabel.text = userName;
        NSDictionary * params = @{@"apiid": @"0085",@"memberid" : userName};
        [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            myScoreLabel.text = [NSString stringWithFormat:@"%@ 积分",score];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
        }];
    }
}

//判断用户是否是VIP
- (void)showVipCustomer{
    
    iconArr = @[@"usericon_merchant",@"usericon_necessary"];
    tableItemArr = @[@"        卖家入口",@"        开店必看"];
    
    if (![Tools isUserHaveLogin]) {
        //如果没有登录，无需请求
        [myTableView reloadData];
        return;
    }
    
    NSDictionary * params = @{@"apiid": @"0252",@"memberid" : userNameLabel.text};
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondStr = operation.responseString;
        NSDictionary *dataDic = [respondStr objectFromJSONString];
        
        if ([[dataDic valueForKey:@"result"] isEqualToString:@"true"]){
            iconArr = @[@"usericon_merchant",@"usericon_necessary",@"usericon_vip"];
            tableItemArr = @[@"        卖家入口",@"        开店必看",@"        精英联盟"];
            
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:YES] forKey:@"IsVipUser"];
        }else{
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"IsVipUser"];
        }
        [myTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"IsVipUser"];
        [myTableView reloadData];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
}
- (void)initialization
{
    viewControllerArray = @[@"OrderListController",@"BookOrderController",@"WalletViewController",@"GoldCarrotController",@"FavoriteViewController",@"WebViewController",@"WebViewController",@"AnnouncementController"];
}

- (void)initView
{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight]+TOPNAVIHEIGHT;
    int barHeight = 0;
    if (iOS7) {
        addStatusBarHeight = iOS7OFFSET;
    }else{
        barHeight = 20;
    }
    myTableView = [[UITableView alloc] init];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    myTableView.frame = CGRectMake(0, addStatusBarHeight, SCREENWIDTH, MAINSCREEN_HEIGHT-addStatusBarHeight-50-barHeight);
    myTableView.backgroundView = nil;
    myTableView.backgroundColor = TABLEBGCOLOR;
    [Tools setExtraCellLineHidden:myTableView];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    self.view.backgroundColor = TABLEBGCOLOR;
    self.navigationController.navigationBarHidden = YES;
//    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    

    CGFloat viewHeight = 350;
    UIView *headerView = [[UIView alloc] init];
    headerView.frame = CGRectMake(0, 0, SCREENWIDTH, viewHeight);
    headerView.backgroundColor = TABLEBGCOLOR;
    
    CGFloat imageHeight = 150;
    UIImageView *profileBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_headerbg.jpg"]];
    profileBg.contentMode = UIViewContentModeScaleAspectFill;
    profileBg.tag = 100;
    profileBg.frame = CGRectMake(0, 0, SCREENWIDTH, imageHeight);
    [headerView addSubview:profileBg];
    profileBg.userInteractionEnabled = YES;
    headerView.userInteractionEnabled = YES;
    
    //头像
    CGFloat imageX = 20;
    CGFloat imageY = 25;
    CGFloat imageH = imageHeight - 2 * imageY;
    CGFloat imageW = imageH;
    portrait = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, imageY, imageW, imageH)];
    portrait.layer.borderWidth = 3.0;
    UIColor *borderColor = [UIColor colorWithRed:79.0/255 green:44.0/255 blue:30.0/255 alpha:0.7];
    portrait.layer.borderColor = [borderColor CGColor];
    portrait.layer.cornerRadius = imageW / 2.0;
    portrait.layer.masksToBounds = YES;
    [profileBg addSubview:portrait];
    portrait.userInteractionEnabled = YES;
    [self setPortaitImg];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openCamera)];
    [portrait addGestureRecognizer:tap];
    
    //添加按钮
    UIView *buttonBG = [[UIView alloc] initWithFrame:CGRectMake(0, imageHeight, SCREENWIDTH, viewHeight - imageHeight)];
    buttonBG.backgroundColor = [UIColor clearColor];
    [headerView addSubview:buttonBG];
    NSArray *titleArray = @[@[@"网购",@"预定",@"钱包",@"金萝卜"],@[@"收藏",@"代金券",@"打折卡",@"消息"]];
    NSArray *iconImageArray = @[@[@"usericon_online",@"usericon_book",@"usericon_walet",@"usericon_carrot"],@[@"usericon_fav",@"usericon_ticket",@"usericon_discount",@"usericon_news"]];
    [self addButtonToView:buttonBG withImage:iconImageArray andTitle:titleArray];
    
    myTableView.tableHeaderView = headerView;
    
    
    //登录按钮
    loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(imageY + imageW + 10, 37, 80, 30)];
    loginBtn.center = profileBg.center;
    CGRect loginFrame = loginBtn.frame;
    loginFrame.origin.x = imageY + imageW + 10;
    loginBtn.frame = loginFrame;
    
    [profileBg addSubview:loginBtn];
    [loginBtn.layer setMasksToBounds:YES];
    [loginBtn.layer setCornerRadius:5];//设置矩形四个圆角半径
    loginBtn.backgroundColor = [UIColor whiteColor];
    [loginBtn setTitle:@"登录/注册" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15.0]];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(onClickLogin) forControlEvents:UIControlEventTouchUpInside];
    
    //用户名
    CGFloat labelX = portrait.frame.origin.x + portrait.frame.size.width + 10;
    CGFloat labelY = portrait.frame.origin.y + 10;
    CGFloat labelH = 25;
    CGFloat labelW = SCREENWIDTH-65-labelX;
    userNameLabel = [[UILabel alloc] init];
    userNameLabel.textAlignment = NSTextAlignmentLeft;
    userNameLabel.backgroundColor = [UIColor clearColor];
    userNameLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    userNameLabel.textColor = [UIColor whiteColor];
    userNameLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
    [profileBg addSubview:userNameLabel];
    //积分
    myScoreLabel = [[UILabel alloc] init];
    myScoreLabel.backgroundColor = [UIColor clearColor];
    myScoreLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    myScoreLabel.textColor = [UIColor whiteColor];
    myScoreLabel.frame = CGRectMake(labelX, portrait.frame.origin.y + portrait.frame.size.height - 10 - labelH, labelW, labelH);
    [profileBg addSubview:myScoreLabel];
    //签到按钮
    CGFloat buttonW = 50;
    CGFloat buttonH = 25;
    CGFloat buttonX = SCREENWIDTH - 15 - buttonW;
    UIButton *signBtn = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, 0, buttonW, buttonH)];
    signBtn.center = myScoreLabel.center;
    CGRect signFrame = signBtn.frame;
    signFrame.origin.x = buttonX;
    signBtn.frame = signFrame;
    [profileBg addSubview:signBtn];
    [signBtn bootstrapStyle];
    signBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];;
    signBtn.tag = 108;//签到页面的
    signBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    [signBtn setTitle:@"签到" forState:UIControlStateNormal];
    [signBtn addTarget:self action:@selector(toSignInView) forControlEvents:UIControlEventTouchUpInside];
    if (![Tools isUserHaveLogin]) {
        signBtn.hidden = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPortaitImg) name:@"loginSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPortaitImg) name:@"SignOutNotification" object:nil];
}

- (void)setPortaitImg{
    portrait.image = [UIImage imageNamed:@"defaultHead"];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
    if ([Tools isUserHaveLogin]) {
        if ([fileManager fileExistsAtPath:filePath]) {
            portrait.image = [UIImage imageWithContentsOfFile:filePath];
        }
    }
}

//添加按钮
- (void)addButtonToView:(UIView *)buttonBG withImage:(NSArray *)imagearray andTitle:(NSArray *)nameArray
{
    CGFloat viewW = buttonBG.frame.size.width;
    CGFloat viewH = buttonBG.frame.size.height;
    NSInteger buttonCountRow = [[imagearray objectAtIndex:0] count];
    NSInteger buttonCountColumn = [imagearray count];
    CGFloat buttonX = 0;
    CGFloat buttonHDistance = 2;
    CGFloat buttonVDistance = 2;
    CGFloat buttonY = 0;
    CGFloat buttonW = (viewW - (buttonCountRow - 1) * buttonHDistance) / ((CGFloat)buttonCountRow);
    CGFloat buttonH = (viewH - (buttonCountColumn - 1) * buttonVDistance) / ((CGFloat)buttonCountColumn);

    for (int i = 0; i < [imagearray count]; i++) {
        for (int j = 0; j < [[imagearray objectAtIndex:i] count]; j++) {
            UIImage *image = [UIImage imageNamed:[[imagearray objectAtIndex:i] objectAtIndex:j]];
            UIImageView *subImage = [[UIImageView alloc] initWithFrame:CGRectMake(buttonW / 4.0, buttonH / 5.0, buttonW / 2.0, buttonW / 2.0)];
            subImage.image = image;
            UIImageView *iconImage = [[UIImageView alloc] init];
            [iconImage addSubview:subImage];
            iconImage.backgroundColor = [UIColor whiteColor];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(buttonX + j * buttonHDistance + j * buttonW, buttonY + i * buttonVDistance + i * buttonH, buttonW, buttonH);
            button.tag = i * [[imagearray objectAtIndex:i] count] + j;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttonBG addSubview:button];
            
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor grayColor];
            label.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            label.frame = CGRectMake(0, buttonH - 30, buttonW, 20);
            label.text = [[nameArray objectAtIndex:i] objectAtIndex:j];
            label.textAlignment = NSTextAlignmentCenter;
            [button addSubview:label];
            
            iconImage.frame = button.frame;
            [buttonBG addSubview:iconImage];
            [buttonBG addSubview:button];
          
        }
        
    }
}

- (void)buttonClick:(UIButton *)button
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger index = button.tag;
    id myObj = [[NSClassFromString(viewControllerArray[index]) alloc] init];
    UIViewController *myVC = nil;
    if ([myObj isKindOfClass:[UIViewController class]]) {
        myVC = (UIViewController *)myObj;
    }
    
    if (![defaults objectForKey:@"userLoginInfo"]) {
        [self onClickLogin];//---跳转登录
    }else{
        //            id myObj = [[NSClassFromString(identifierArr[index]) alloc] init];
        if (myObj) {
            if ([myObj isKindOfClass:[WebViewController class]]) {
                NSString *title,*url,*type = @"webUrl";
                switch (index) {
                    case 5:
                        title = @"我的代金券";
                        url = @"person_coupon_list.html";
                        break;
                    case 6:
                        title = @"我的卡券";
                        url = @"discount_list.html";
                        break;
                    case 3:
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
                ((WalletViewController *)myObj).webURL = @"wallet_index_second.html";
                ((WalletViewController *)myObj).webType =  @"webUrl";
            }
            else if ([myObj isKindOfClass:[OrderListController class]]) {
                ((OrderListController *)myObj).currentItemTag =  0;
            }
            else if ([myObj isKindOfClass:[AnnouncementController class]]) {
                ((AnnouncementController *)myObj).shopID =  [Tools getUserLoginNumber];
            }
            ((UIViewController *)myObj).hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:(UIViewController *)myObj animated:YES];
        }else{
            [self.view makeToast:@"功能未完善" duration:1.2 position:@"center"];
        }
    }
}

- (void)onClickLogin
{
    LoginViewController *loginV = [[LoginViewController alloc] init];
    loginV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginV animated:YES];
}

-(void)toSignInView
{
    SignInController *orderV = [[SignInController alloc] init];
    orderV.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderV animated:YES];
}

-(void)setBarItemSelectedIndex:(NSUInteger)selectedIndex{
    for (int i = 0; i < 5; i++) {
        UIColor *rightColor = (i == selectedIndex) ? TABBARSELECTEDCOLOR : TABBARDEFAULTCOLOR;
        [(UITabBarItem *)[self.tabBarController.tabBar.items objectAtIndex:i] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:rightColor, UITextAttributeTextColor, nil] forState:UIControlStateNormal];
    }
}

//打开相机,获取照片
-(void)openCamera
{
    if (![Tools isUserHaveLogin]) {
        //如果没有登录，跳登录界面
        [self onClickLogin];
    }else{
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
    }
}

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
        [picker dismissViewControllerAnimated:YES completion:nil];
        portrait.image = image;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return iconArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cellIndentifier";
    UITableViewCell *userCell = [tableView cellForRowAtIndexPath:indexPath];
    if (!userCell) {
        userCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    CGFloat iconY = 10;
    CGFloat iconH = cellSize.height - 2 * iconY;
    CGFloat iconX = 10;
    CGFloat iconW = iconH;
    switch (section) {
        case 0:
        {
            switch (row) {
                case 0:
                {
                    
                    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArr objectAtIndex:row]]];
                    icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
                    [userCell addSubview:icon];
                    userCell.textLabel.text = tableItemArr[row];
                    userCell.textLabel.textColor = [UIColor grayColor];
                    userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 1:
                {
                    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArr objectAtIndex:row]]];
                    icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
                    [userCell addSubview:icon];
                    userCell.textLabel.text = tableItemArr[row];
                    userCell.textLabel.textColor = [UIColor grayColor];
                    userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                case 2:
                {
                    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[iconArr objectAtIndex:row]]];
                    icon.frame = CGRectMake(iconX, iconY, iconW, iconH);
                    [userCell addSubview:icon];
                    userCell.textLabel.text = tableItemArr[row];
                    userCell.textLabel.textColor = [UIColor grayColor];
                    userCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    return userCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger index = indexPath.row;
    if (index == 0) {
        if (![Tools isUserHaveLogin]) {
            //如果没有登录，跳登录界面
            [self onClickLogin];
        }else{
            [Waiting show];
            NSDictionary * params  = @{@"apiid": @"0141",@"shopid" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"]};
            NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                              path:@""
                                                                        parameters:params];
            AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [Waiting dismiss];
                
                NSString *respondStr = operation.responseString;
                NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[respondStr objectFromJSONString]];
                
                
                if ([[tempDic valueForKey:@"val"] count] > 0) {
                    
                    SellCenterViewController *sellCenterVC = [[SellCenterViewController alloc] init];
                    sellCenterVC.hidesBottomBarWhenPushed = YES;
                    sellCenterVC.myShopDataInfo = tempDic;
                    [self.navigationController pushViewController:sellCenterVC animated:YES];
                    
                }else{
                    //未开店
                    [self.view makeToast:@"请去开店" duration:2.0 position:@"center"];
                    /*
                     */
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Waiting dismiss];
                [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
            }];
            [operation start];
        }
    }else if (index == 1){
        NSLog(@"开店必看");
        WebViewController *webViewController = [[WebViewController alloc] init];
        webViewController.narBarOffsetY = 50;
        webViewController.webTitle = @"开店必看";
        webViewController.webURL = [NSString stringWithFormat:@"%@/seller_learn.html?platform=ios",ROOTPAGEURLADDRESS];
        webViewController.webType = @"webUrl";
        webViewController.agentid = [Tools getUserLoginNumber];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
        
//        seller_learn.html
    }else if (index == 2){
        NSLog(@"精英联盟");
        WebViewController *webViewController = [[WebViewController alloc] init];
        webViewController.narBarOffsetY = 50;
        webViewController.webTitle = @"精英联盟";
        webViewController.webURL = [NSString stringWithFormat:@"%@/elite_alliance.html?platform=ios",ROOTPAGEURLADDRESS];
        webViewController.webType = @"webUrl";
        webViewController.agentid = [Tools getUserLoginNumber];
        webViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webViewController animated:YES];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"敬请期待" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
