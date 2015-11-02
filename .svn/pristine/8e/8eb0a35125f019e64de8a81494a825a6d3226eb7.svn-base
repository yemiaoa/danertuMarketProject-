//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "AnnouncementController.h"
#import "NoItemView.h"

@implementation AnnouncementController{
    NoItemView *noDataView;
}
@synthesize addStatusBarHeight;
@synthesize scrollView;
@synthesize messageArr;
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initView];
    [self getMessageData];
}

//修改标题,重写父类方法
- (NSString *)getTitle
{
    return @"资讯中心";
}

- (void)initView{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    self.view.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
    
    messageArr = [[NSMutableArray alloc] init];
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, CONTENTHEIGHT + 49)];
    [self.view addSubview:scrollView];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
    
    //没有数据显示的view,下方按钮高70
    noDataView = [[NoItemView alloc] initWithY:TOPNAVIHEIGHT+addStatusBarHeight+(CONTENTHEIGHT-150)/2+30 Image:[UIImage imageNamed:@"noData"] mes:@"亲，当前暂时没有消息"];
    [self.view addSubview:noDataView];
    //默认隐藏
    noDataView.hidden = YES;
}

//获取消息信息
- (void)getMessageData
{
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    NSDictionary * params = @{@"apiid": @"0007"};
    if (self.shopID) {
        params = @{@"apiid": @"0007",@"memberId":self.shopID};
    }
    
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSError *error;
        NSDictionary *jsonData = [[CJSONDeserializer deserializer]deserialize:responseObject error:&error];
        if (jsonData) {
            messageArr = [[jsonData objectForKey:@"messageList"] objectForKey:@"messagebean"];
            
            if ([messageArr count] == 0) {
                noDataView.hidden = NO;
                return ;
            }
            [self createView];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
        [Waiting dismiss];//隐藏loading
    }];
    [operation start];
}

//生成view
- (void)createView{
    NSInteger count = messageArr.count;
    int itemHeight = 50;
    int itemGap = 10;
    scrollView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, (itemHeight+itemGap)*count);
    for (int i=0;i<count;i++) {
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0, (itemHeight+itemGap) * i, MAINSCREEN_WIDTH, itemHeight)];
        [scrollView addSubview:item];
        item.userInteractionEnabled = YES;
        item.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goDetail:)];
        [item addGestureRecognizer:singleTap];//---添加点击事件
        
        //标题
        UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 20)];
        [item addSubview:titleLb];
        titleLb.textAlignment = NSTextAlignmentCenter;
        titleLb.text = [messageArr[i] objectForKey:@"messageTitle"];
        //边
        UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(0, 29, MAINSCREEN_WIDTH, 1)];
        [item addSubview:border];
        border.backgroundColor = VIEWBGCOLOR;
        
        //内容
        UILabel *contentLb = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 280, 20)];
        [item addSubview:contentLb];
        contentLb.textAlignment = NSTextAlignmentRight;
        contentLb.font = TEXTFONT;
        contentLb.textColor = BORDERCOLOR;
        contentLb.text = [messageArr[i] objectForKey:@"ModiflyTime"];
        item.tag = 100 + i;
    }
}
//------点击进入详情页----
- (void)goDetail:(id)sender{
    NSInteger tag = [[sender view] tag] - 100;
    AnnounceDetailController *findV = [[AnnounceDetailController alloc]init];
    findV.hidesBottomBarWhenPushed = YES;
    findV.msgInfo = messageArr[tag];
    [self.navigationController pushViewController:findV animated:YES];
}

//-----------内存不足报警------
- (void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
}
@end
