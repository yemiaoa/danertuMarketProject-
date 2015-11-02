//
//  HeSettingVC.m
//  单耳兔
//
//  Created by iMac on 15/6/30.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "HeSettingVC.h"
#import "UIButton+Bootstrap.h"
#import "SettingsViewController.h"
#import "AddressListController.h"
#import "ModifyPwdController.h"
#import "MeiMesSettingVC.h"

@interface HeSettingVC ()<UITextFieldDelegate>
{
    UIImageView *alertBG;
    UITextField *inputField;
    UIView *dismissView;
}
@property(strong,nonatomic)UITableView *settingTable;
@property(strong,nonatomic)NSArray *settingArray;
@property(strong,nonatomic)NSString *bindShopID;  //绑定店铺的ID
@property(strong,nonatomic)NSString *bindshareNum;  //绑定店铺的分享码
@property(strong,nonatomic)NSString *bindShopName;  //绑定店铺的名称
@end

@implementation HeSettingVC
@synthesize settingTable;
@synthesize settingArray;
@synthesize bindshareNum;
@synthesize bindShopID;
@synthesize bindShopName;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initialization];
    [self initView];
    NSString *deviceCode = [Tools getDeviceUUid];
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0144",@"apiid",deviceCode,@"deviceCode", nil];
    [self getBindInfoWithParams:params];
}

- (void)initialization
{
    settingArray = @[@"绑定店铺",@"收货地址",@"消息通知",@"修改密码",@"关于单耳兔"];
}

- (void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight]+TOPNAVIHEIGHT;
    if (iOS7) {
        addStatusBarHeight = iOS7OFFSET;
    }
    settingTable = [[UITableView alloc] init];
    settingTable.frame = CGRectMake(0, addStatusBarHeight, SCREENWIDTH, MAINSCREEN_HEIGHT-addStatusBarHeight);
    settingTable.backgroundView = nil;
    settingTable.backgroundColor = TABLEBGCOLOR;
    [Tools setExtraCellLineHidden:settingTable];
    settingTable.delegate = self;
    settingTable.dataSource = self;
    [self.view addSubview:settingTable];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    footerView.backgroundColor = [UIColor clearColor];
    UIButton *signOutButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 20, SCREENWIDTH - 80, 40)];
    [signOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [signOutButton dangerStyle];
    signOutButton.layer.borderWidth = 0;
    signOutButton.layer.borderColor = [UIColor clearColor].CGColor;
    footerView.userInteractionEnabled = YES;
    [footerView addSubview:signOutButton];
    [signOutButton addTarget:self action:@selector(signOut:) forControlEvents:UIControlEventTouchUpInside];
    settingTable.tableFooterView = footerView;
}

- (void)getBindInfoWithParams:(NSDictionary *)params
{
    NSString *apiid = [params objectForKey:@"apiid"];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self hideHud];
        NSString *respondStr = operation.responseString;
        NSDictionary *dic = [respondStr objectFromJSONString];
        if ([apiid isEqualToString:@"0144"]) {
            NSString *shopid = [dic objectForKey:@"shopid"];
            if ([shopid isMemberOfClass:[NSNull class]] || shopid == nil || [shopid isEqualToString:@""]) {
                //还没绑定
                self.bindShopID = @"-1";
                self.bindshareNum = @"-1";
                [settingTable reloadData];
            }
            else{
                self.bindShopID = shopid;
                if (self.bindshareNum) {
                    [Tools recordBindShopWithShareNumber:bindshareNum shopid:bindShopID];
                }
                NSDictionary *params = @{@"apiid":@"0142",@"shopid":self.bindShopID};
                [self getBindInfoWithParams:params];
                [self getShopNameWithShopID:shopid];
            }
        }
        else if ([apiid isEqualToString:@"0142"]){
            NSString *sharenumber = [dic objectForKey:@"sharenumber"];
            if ([sharenumber isMemberOfClass:[NSNull class]] || sharenumber == nil || [sharenumber isEqualToString:@""]) {
                //还没绑定
                self.bindshareNum = @"-1";
            }
            else{
                self.bindshareNum = sharenumber;
                [Tools recordBindShopWithShareNumber:sharenumber shopid:bindShopID];
                [settingTable reloadData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self hideHud];
    }];
}

- (void)getShopNameWithShopID:(NSString *)shopid
{
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0141",@"apiid",shopid,@"shopid", nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        NSString *respondStr = operation.responseString;
        id respondObj = [respondStr objectFromJSONString];
        id valObj = [respondObj objectForKey:@"val"];
        @try {
            id respondDic = [valObj firstObject];
            self.bindShopName = [respondDic objectForKey:@"ShopName"];
            [settingTable reloadData];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        
    }];
}

- (void)bindShop
{
    if (!alertBG) {
        
        dismissView = [[UIView alloc] init];
        dismissView.frame = self.view.frame;
        dismissView.backgroundColor = [UIColor blackColor];
        dismissView.alpha = 0.7;
        [self.view addSubview:dismissView];
        
        UIImage *alertImage = [UIImage imageNamed:@"alertBG"];
        CGFloat imageScale = alertImage.size.width / alertImage.size.height;
        
        CGFloat alertX = 30;
        CGFloat alertW = SCREENWIDTH - 2 * alertX;
        CGFloat alertH = alertW / imageScale + 50;
        CGFloat alertY = addStatusBarHeight;
        alertBG = [[UIImageView alloc] init];
        alertBG.frame = CGRectMake(alertX, alertY, alertW, alertH);
        alertBG.image = alertImage;
        alertBG.userInteractionEnabled = YES;
//        alertBG.center = self.view.center;
        [self.view addSubview:alertBG];
        
        UIImage *closeIcon = [UIImage imageNamed:@"closeIcon"];
        CGFloat iconScale = closeIcon.size.width / closeIcon.size.height;
        CGFloat iconW = 40;
        CGFloat iconH = iconW / iconScale;
        UIButton *closeButton = [[UIButton alloc] init];
        closeButton.frame = CGRectMake(alertW - iconW, 0, iconW, iconH);
        [closeButton setBackgroundImage:closeIcon forState:UIControlStateNormal];
        [closeButton setBackgroundImage:[UIImage imageNamed:@"closeIconHL"] forState:UIControlStateNormal];
        [alertBG addSubview:closeButton];
        [closeButton addTarget:self action:@selector(closeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        inputField = [[UITextField alloc] init];
        inputField.keyboardType = UIKeyboardTypeNumberPad;
        inputField.delegate = self;
        inputField.frame = CGRectMake(20, iconH + 10, alertW - 40, 40);
        inputField.placeholder = @"请输入您要绑定的店铺码";
        inputField.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        inputField.textAlignment = NSTextAlignmentCenter;
        inputField.textColor = [UIColor blackColor];
        [inputField setBackground:[UIImage imageNamed:@"inputFieldBG"]];
        [alertBG addSubview:inputField];
        
        UIButton *commitButton = [[UIButton alloc] init];
        [commitButton setTitle:@"确    认" forState:UIControlStateNormal];
        [commitButton dangerStyle];
        [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commitButton.layer.borderColor = [UIColor clearColor].CGColor;
        commitButton.layer.borderWidth = 0;
        [commitButton addTarget:self action:@selector(commitButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        commitButton.frame = CGRectMake((alertW - 120) / 2.0, inputField.frame.origin.y + inputField.frame.size.height + 10, 120, 40);
        [alertBG addSubview:commitButton];
        
        UILabel *tipLabel = [[UILabel alloc] init];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.textColor = [UIColor blackColor];
        tipLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"如有疑问，请致电客服: 400 995 2220";
        tipLabel.frame = CGRectMake(0, alertH - 25, alertW, 20);
        [alertBG addSubview:tipLabel];
        
        UILabel *tipLabel1 = [[UILabel alloc] init];
        tipLabel1.backgroundColor = [UIColor clearColor];
        tipLabel1.textColor = [UIColor blackColor];
        tipLabel1.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        tipLabel1.textAlignment = NSTextAlignmentCenter;
        tipLabel1.text = @"在分享链接中查看商家店铺码!";
        tipLabel1.frame = CGRectMake(0, alertH - 50, alertW, 20);
        [alertBG addSubview:tipLabel1];
        
        
        UITapGestureRecognizer *disGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        disGes.numberOfTapsRequired = 1;
        disGes.numberOfTouchesRequired = 1;
        [dismissView addGestureRecognizer:disGes];
    }
    
    dismissView.hidden = NO;
    alertBG.hidden = NO;
//    [inputField becomeFirstResponder];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [alertBG.layer addAnimation:popAnimation forKey:nil];
}

- (void)dismiss:(UITapGestureRecognizer *)tap
{
    dismissView.hidden = YES;
    alertBG.hidden = YES;
    [inputField resignFirstResponder];
}

- (void)closeButtonClick:(UIButton *)button
{
    dismissView.hidden = YES;
    alertBG.hidden = YES;
    [inputField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)commitButtonClick:(UIButton *)button
{
    if ([inputField.text isEqualToString:@""] || inputField == nil) {
        [self showHint:@"请输入您要绑定的店铺码"];
        return;
    }
    dismissView.hidden = YES;
    alertBG.hidden = YES;
    [inputField resignFirstResponder];
    [self showHudInView:self.view hint:@"绑定中..."];
    [self requestBindShopWithNumber:inputField.text];
}

//请求绑定店铺
- (void)requestBindShopWithNumber:(NSString *)sharenumber
{
    NSString *deviceCode = [Tools getDeviceUUid];
    NSString *apiid = @"0148";
    NSString *sharenumberKey = @"shopnumber";
    if ([self.bindshareNum isEqualToString:@"-1"]) {
        apiid = @"0143";
        sharenumberKey = @"sharenumber";
    }
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:apiid,@"apiid",deviceCode,@"deviceCode",sharenumber,sharenumberKey, nil];
    [[AFOSCClient sharedClient] postPath:nil parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject){
        [self hideHud];
        NSString *respondStr = operation.responseString;
        NSDictionary *dic = [respondStr objectFromJSONString];
        NSString *result = [dic objectForKey:@"result"];
        if ([result compare:@"true" options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            [self showHint:@"绑定成功"];
            self.bindshareNum = sharenumber;
            NSString *deviceCode = [Tools getDeviceUUid];
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys:@"0144",@"apiid",deviceCode,@"deviceCode", nil];
            [self getBindInfoWithParams:params];
        }
        else{
            [self showHint:@"绑定失败"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [self hideHud];
        [self showHint:@"绑定失败"];
        NSLog(@"%@",error);
    }];
}

-(NSString*)getTitle
{
    return @"设置";
}

//重写父类方法
-(void)onClickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

//退出登录
- (void)signOut:(UIButton *)button
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"userLoginInfo"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"确认要退出当前账户吗"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alert addButtonWithTitle:@"退出"];
        [alert setTag:1];
        [alert show];
    }else{
        [self.view makeToast:@"您还未登录" duration:2.0 position:@"center"];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 1) {
        if(buttonIndex == 1){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:[[defaults valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"] forKey:@"OldUserAccountKey"];
            [defaults removeObjectForKey:@"userLoginInfo"];
            [Tools initPush];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SignOutNotification" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [settingArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    static NSString *cellIndentifier = @"CellIndentifier";
    
    CGSize cellSize = [tableView rectForRowAtIndexPath:indexPath].size;
    UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"  %@",settingArray[row]];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16.0];
    if (row == 0) {
        UILabel *sharenumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 250, 0, 200, cellSize.height)];
        sharenumberLabel.backgroundColor = [UIColor clearColor];
        sharenumberLabel.textAlignment = NSTextAlignmentRight;
        sharenumberLabel.textColor = [UIColor colorWithRed:196.0 / 255.0 green:0 blue:0 alpha:1.0];
        sharenumberLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        [cell addSubview:sharenumberLabel];
        if ([bindshareNum isEqualToString:@"-1"]) {
            sharenumberLabel.text = @"未绑定店铺";
        }
        else if (bindshareNum == nil){
            sharenumberLabel.text = @"获取中";
        }
        else{
            sharenumberLabel.text = bindShopName;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 10)];
    headerView.backgroundColor = settingTable.backgroundColor;
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
        {
            //修改绑定店铺
            [self bindShop];
            break;
        }
        case 1:
        {
            //地址管理
            AddressListController *addressList = [[AddressListController alloc] init];
            addressList.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressList animated:YES];
            break;
        }
        case 2:
        {
            //消息通知
            MeiMesSettingVC *mesSettingVC = [[MeiMesSettingVC alloc] init];
            mesSettingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mesSettingVC animated:YES];
            break;
        }
        case 3:
        {
            //修改密码
            ModifyPwdController *modifyPSWVC = [[ModifyPwdController alloc] init];
            modifyPSWVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:modifyPSWVC animated:YES];
            break;
        }
        case 4:
        {
            //关于单耳兔
            SettingsViewController *settingVC = [[SettingsViewController alloc] init];
            settingVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingVC animated:YES];
            break;
        }
        default:
            break;
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
