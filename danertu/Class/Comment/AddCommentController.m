//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
/*
 已经弃用
 */
#import "AddCommentController.h"
@implementation AddCommentController
@synthesize addStatusBarHeight;
@synthesize backHomeIcon;
@synthesize refreshIcon;
@synthesize webView;
@synthesize activityIndicator;
@synthesize webURL;
@synthesize webTitle;
@synthesize textView;
@synthesize tapRateView;
@synthesize defaults;
@synthesize labeltext;
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    addStatusBarHeight = STATUSBAR_HEIGHT;
    defaults =[NSUserDefaults standardUserDefaults];
    //--ios7 or later  添加 bar
    if (iOS7) {
        UILabel *addStatusBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 20)];
        addStatusBar.backgroundColor = [UIColor blackColor];
        [self.view addSubview:addStatusBar];
    }
    //top
    UIView *topNavi = [[UIView alloc] initWithFrame:CGRectMake(0, 0+addStatusBarHeight, MAINSCREEN_WIDTH, 45)];
    topNavi.userInteractionEnabled = YES;//这样才可以点击
    [self.view addSubview:topNavi];
    //文字
    UILabel *topNaviText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 44)];
    topNaviText.text = @"写评论";
    topNaviText.font = [UIFont systemFontOfSize:18];
    topNaviText.textAlignment = NSTextAlignmentCenter;
    topNaviText.userInteractionEnabled = YES;//这样才可以点击
    topNaviText.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    [topNavi addSubview:topNaviText];
    //线条
    UILabel *borderLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 44, MAINSCREEN_WIDTH, 1)];
    borderLine.backgroundColor = [UIColor orangeColor];
    [topNavi addSubview:borderLine];
    //-------导航头部
    //退回到上一页
    //----退回到上一页,temp扩大热区
    UILabel *temp = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    temp.userInteractionEnabled = YES;
    temp.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickBack)];
    [temp addGestureRecognizer:singleTap];//---添加点击事件
    [topNavi addSubview:temp];
    backHomeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 15, 15)];
    [backHomeIcon setImage:[UIImage imageNamed:@"carat-d-orange"]];
    backHomeIcon.userInteractionEnabled = YES;//这样才可以点击
    [temp addSubview:backHomeIcon];
    
    
    //---提交按钮------
    UIButton *submit = [[UIButton alloc] initWithFrame:CGRectMake(240, 0, 80, 44)];
    [topNavi addSubview:submit];
    [submit setTitle:@"提交" forState:UIControlStateNormal];//-----提交-----
    [submit setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];//--
    [submit setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];//
    [submit addTarget:self action:@selector(addNewComment) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];//--view背景色--
    
    //---评星级区域---
    UIView *starView = [[UIView alloc] initWithFrame:CGRectMake(0, 45+addStatusBarHeight, MAINSCREEN_WIDTH, 80)];
    [self.view addSubview:starView];//
    
    tapRateView = [[RSTapRateView alloc] initWithFrame:CGRectMake(0, 45+addStatusBarHeight, MAINSCREEN_WIDTH, 80)];
    tapRateView.delegate = self;
    [self.view addSubview:tapRateView];
    
    
    //---评论内容区---
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 45 + addStatusBarHeight + 80, MAINSCREEN_WIDTH, 150)];
    [self.view addSubview:contentView];//
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, 300, 150)];
    [contentView addSubview:textView];//
    textView.delegate = self;
    textView.font = [UIFont systemFontOfSize:14];//字体
    textView.layer.cornerRadius = 8; //给图层的边框设置为圆角
    textView.layer.masksToBounds = YES;
    //textView.content
    //textView.layer.borderWidth = 5;
    //textView.layer.borderColor = [[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:0.5] CGColor];
    textView.backgroundColor = [UIColor whiteColor];//白色
    [textView becomeFirstResponder];
    
    labeltext = [[UILabel alloc]initWithFrame:CGRectMake(100, 65, 100, 20)];
    labeltext.backgroundColor = [UIColor clearColor];
    labeltext.textAlignment = NSTextAlignmentCenter;
    labeltext.text = @"评论内容";
    labeltext.textColor = [UIColor grayColor];//----灰色----
    [textView addSubview:labeltext];//
}
//-----textview-----placeholder-----
-(BOOL)textView:(UITextView *)textViewTmp shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textViewTmp.text.length==0){//textview长度为0
        if ([text isEqualToString:@""]) {//判断是否为删除键
            labeltext.hidden=NO;//隐藏文字
        }else{
            labeltext.hidden=YES;
        }
    }else{//textview长度不为0
        if (textViewTmp.text.length==1){//textview长度为1时候
            if ([text isEqualToString:@""]) {//判断是否为删除键
                labeltext.hidden=NO;
            }else{//不是删除
                labeltext.hidden=YES;
            }
        }else{//长度不为1时候
            labeltext.hidden=YES;
        }
    }
    return YES;
}
//-----点击返回
-(void)onClickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark RSTapRateViewDelegate
- (void)tapDidRateView:(RSTapRateView*)view rating:(NSInteger)rating
{
    
}
//-----点击添加新评论-----
-(void)addNewComment{
    NSDictionary *wood = [defaults objectForKey:@"currentWoodsInfo"];
    NSDictionary  *userLoginInfo = [defaults objectForKey:@"userLoginInfo"];
    if (userLoginInfo) {
        if (tapRateView.rating==0){
            [self.view makeToast:@"请点击星形评分" duration:1.2 position:@"center"];//----评论内容----
        }else if (textView.text.length==0) {
            [self.view makeToast:@"请填写评论内容" duration:1.2 position:@"center"];//----评论内容----
        }else{
            [Waiting show];//-----loading-----
            AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
            NSDictionary * params = @{@"apiid": @"0067",@"productguid":[wood objectForKey:@"productguid"],@"memloginid":[userLoginInfo objectForKey:@"MemLoginID"],@"content":textView.text,@"agentID":[wood objectForKey:@"agentID"],@"rank":[NSString stringWithFormat:@"%d",tapRateView.rating]};
            NSURLRequest * request = [client requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
            
            AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
                NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                [Waiting dismiss];
                if ([data isEqualToString:@"true"]) {
                    //评论成功后发送通知,在待评论里删除      该产品
                    NSDictionary *commentWoodInfo = @{@"productguid":[wood objectForKey:@"productguid"],@"agentID":[wood objectForKey:@"agentID"]};
                    NSMutableArray *itemsArray = [[defaults objectForKey:@"PayedOrderWoodsArray"] mutableCopy];
                    //int itemsCount = itemsArray.count;
                    for (int i=0;i<itemsArray.count;i++) {
                        NSDictionary *item = itemsArray[i];
                        NSMutableArray *woodsArray = [[item objectForKey:@"woodsArray"] mutableCopy];
                        int woodsCount = woodsArray.count;
                        for (int j=0;j<woodsCount;j++) {
                            NSDictionary *woodItem = woodsArray[j];
                            if ([[woodItem objectForKey:@"Guid"] isEqualToString:[wood objectForKey:@"productguid"]]) {
                                [woodsArray removeObject:woodItem];//---删掉订单里的一个商品
                                if (woodsArray.count==0) {
                                    [itemsArray removeObject:item];
                                }else{
                                    NSMutableDictionary *itemTmp = [item mutableCopy];
                                    [itemTmp setObject:woodsArray forKey:@"woodsArray"];
                                    [itemsArray insertObject:itemTmp atIndex:0];
                                    [itemsArray removeObject:item];
                                }
                                if (itemsArray.count==0) {
                                    [defaults removeObjectForKey:@"PayedOrderWoodsArray"];
                                }else{
                                    [defaults setObject:itemsArray forKey:@"PayedOrderWoodsArray"];
                                }
                            }
                        }
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadCommentWoodList" object:nil userInfo:commentWoodInfo];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [self.view makeToast:@"评论失败,请重试" duration:1.2 position:@"center"];//----
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [Waiting dismiss];
                [self.view makeToast:@"网络错误,请重试" duration:1.2 position:@"center"];//----评论内
            }];
            [operation start];//-----发起请求------
        }
    }else{
        [self.view makeToast:@"请先登录" duration:1.2 position:@"center"];
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//----触摸事件,点击热区状态变化
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if (point.x<60&point.y<44+addStatusBarHeight) {
        backHomeIcon.image = [UIImage imageNamed:@"carat-d-black"];
    }else if(point.x>260&point.y<44){
        refreshIcon.image = [UIImage imageNamed:@"refresh-black"];
    }
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    backHomeIcon.image = [UIImage imageNamed:@"carat-d-orange"];
    refreshIcon.image = [UIImage imageNamed:@"refresh-orange"];
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    backHomeIcon.image = [UIImage imageNamed:@"carat-d-orange"];
    refreshIcon.image = [UIImage imageNamed:@"refresh-orange"];
}
//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
}
@end
