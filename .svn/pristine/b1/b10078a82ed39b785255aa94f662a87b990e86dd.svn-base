//
//  WineActiveInfoViewController.m
//  单耳兔
//
//  Created by administrator on 15-5-21.
//  Copyright (c) 2015年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "WineActiveInfoViewController.h"
#import "UIView+Toast.h"
#import "AFOSCClient.h"
#import "SDRefresh.h"
#import "AsynImageView.h"
#import "SubStoreCell.h"
@interface WineActiveInfoViewController ()
{
    NSInteger currentItemTag;
    UIView *topSegmentView;
    UILabel *underLine;
    int pageIndex;
    SDRefreshFooterView *refreshFooter;
    int _totalPageCount;
    UIView *noItemView;
}

@property(strong,nonatomic)NSMutableArray *dataSource;

@end

@implementation WineActiveInfoViewController
@synthesize addStatusBarHeight;
@synthesize infoLb;
@synthesize tableView;
@synthesize dataSource;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self initView];  //界面初始化
    [self setupFooter];
    [self loadData];  //加载数据
    [self loadListData]; //加载子店铺数据
}

-(void)setupFooter{
    refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
}

- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshFooter endRefreshing];
        if (_totalPageCount == pageIndex) {
            return;
        }
        pageIndex = pageIndex + 1;
        [self loadListData];
    });
}

# pragma mark method - initView
//视图的初始化
- (void)initView
{
    dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    currentItemTag = 0;
    pageIndex = 1;
    _totalPageCount = 1;
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    [self.view setBackgroundColor:[UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0]];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT, MAINSCREEN_WIDTH, 100)];
    bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:240/255.0 blue:205/255.0 alpha:1.0];
    [self.view addSubview:bgView];
    
    AsynImageView *headImage = [[AsynImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
    [bgView addSubview:headImage];
    //商品图片
    NSString *imageUrl = @"http://115.28.55.222:8018/images/jiu.png";
     headImage.imageURL         = imageUrl;
    headImage.backgroundColor = [UIColor clearColor];
    
    infoLb = [[UILabel alloc] initWithFrame:CGRectMake(110, 20, MAINSCREEN_WIDTH-130, 30)];
    infoLb.font = TEXTFONT;
    infoLb.backgroundColor = [UIColor clearColor];
    infoLb.textColor = TOPNAVIBGCOLOR;
    infoLb.text = @"累计送出: 0 瓶";
    [bgView addSubview:infoLb];
    
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, MAINSCREEN_WIDTH-130, 20)];
    titleLb.backgroundColor = [UIColor clearColor];
    titleLb.font = TEXTFONTSMALL;
    titleLb.text = @"陌生送成朋友，朋友送出友谊";
    titleLb.textColor = [UIColor grayColor];
    [bgView addSubview:titleLb];
    
    topSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT+100, MAINSCREEN_WIDTH, 40)];
    [self.view addSubview:topSegmentView];
    
    NSArray *titleArr_order = @[@"我送出的",@"下级店铺送出"];
    NSInteger itemNum_order = titleArr_order.count;
    NSInteger itemWide = MAINSCREEN_WIDTH/2;
    for (int i = 0; i < itemNum_order; i++) {
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(itemWide * i, 0, itemWide, 40)];
        text.text = titleArr_order[i];
        text.userInteractionEnabled = YES;
        if (i==currentItemTag) {
            text.textColor = TOPNAVIBGCOLOR;
        }
        text.textAlignment = NSTextAlignmentCenter;
        text.font = TEXTFONT;
        text.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0];
        [topSegmentView addSubview:text];//text
        text.tag = 100+i;
        
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickItem:)];
        [text addGestureRecognizer:singleTap];//---添加点击事件
    }
    
    underLine = [[UILabel alloc] initWithFrame:CGRectMake(itemWide*currentItemTag, 39, itemWide, 1)];
    [topSegmentView addSubview:underLine];
    underLine.backgroundColor = TOPNAVIBGCOLOR;
    
    noItemView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT +220, MAINSCREEN_WIDTH, 150)];
    [self.view addSubview:noItemView];
    
    //图片
    UIImageView *noItemImage = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 100, 100)];
    [noItemView addSubview:noItemImage];
    [noItemImage setImage:[UIImage imageNamed:@"noOrder"]];
    //文字
    UILabel *noItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 110, 200, 40)];
    [noItemView addSubview:noItemLabel];
    [noItemLabel setBackgroundColor:[UIColor clearColor]];
    [noItemLabel setTextAlignment:NSTextAlignmentCenter];
    [noItemLabel setTextColor:[UIColor grayColor]];
    [noItemLabel setText:@"暂无送酒数据"];
    
    noItemView.hidden = YES;
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT+140, MAINSCREEN_WIDTH, self.view.frame.size.height - addStatusBarHeight - TOPNAVIHEIGHT-140) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    [Tools setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    
    //滑动手势
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [tableView addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [tableView addGestureRecognizer:recognizer];
    
}

// 滑动手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    NSInteger indexs = currentItemTag;
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            if (indexs == 1) return;
            [self removeOldView];
            currentItemTag = 1;
            [self rebuildTheView];
        }
            break;
        default:
        {
            if (indexs == 0) return;
            [self removeOldView];
            currentItemTag = 0;
            [self rebuildTheView];
        }
            break;
    }
}

- (void)onClickItem:(id)sender{
    NSInteger tag = [[sender view] tag] - 100;
    if (tag!=currentItemTag) {
        [self removeOldView];
        currentItemTag = tag;
        [self rebuildTheView];
    }
}

- (void)removeOldView{
    UILabel *preItem = [[topSegmentView subviews] objectAtIndex:currentItemTag];
    preItem.textColor = [UIColor blackColor];
    noItemView.hidden = YES;
}

- (void)rebuildTheView{
    
    [UIView animateWithDuration:0.4 animations:^{
        CGRect frame =  underLine.frame;
        frame.origin.x = MAINSCREEN_WIDTH/2*currentItemTag;
        underLine.frame = frame;
    } completion:^(BOOL finish){
        UILabel *preItem = [[topSegmentView subviews] objectAtIndex:currentItemTag];
        preItem.textColor = TOPNAVIBGCOLOR;
        
        pageIndex = 1;
        _totalPageCount = 1;
        if ([dataSource count] > 0) {
            [dataSource removeAllObjects];
        }
        [self loadListData];
    }];
}



# pragma mark method - loadData
//加载送酒的具体数据
- (void)loadData
{
    [Waiting show];
    NSDictionary * params  = @{@"apiid": @"0137",@"shopid" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"]};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loadin
        NSString *score = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if(score.length > 0){
            [infoLb setText:[NSString stringWithFormat:@"累计送出: %@ 瓶",score]];
        }else{
            [self.view makeToast:@"系统错误,请稍后重试" duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operaxtion, NSError *error) {
        [Waiting dismiss];//隐藏loading
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    [operation start];
}

- (void)loadListData
{
    [Waiting show];
    NSString *apiidStr = @"";
    if (currentItemTag == 0) {
        //店铺送酒明细
        apiidStr = @"0152";
    }else{
        //下级店铺送酒汇总
        apiidStr = @"0153";
    }
    NSString *agentid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"];
    
    NSDictionary * params  = @{@"apiid": apiidStr,@"pageSize":@10,@"shopid":agentid,@"pageIndex":[NSString stringWithFormat:@"%d",pageIndex]};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loadin
        NSString *respondstring = [Tools deleteErrorStringInString:operation.responseString];
        NSDictionary *dict = [respondstring objectFromJSONString];
        if(dict){
            [dataSource addObjectsFromArray:[dict objectForKey:@"val"]];
            if (dataSource.count == 0) {
                [noItemView setHidden:NO];
            }
            _totalPageCount = [[[dict valueForKey:@"count"] valueForKey:@"TotalPageCount_o"] intValue];
            [tableView reloadData];
        }else{
            [noItemView setHidden:NO];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];//隐藏loading
        [self showHint:@"请检查网络连接是否正常"];
    }];
    [operation start];
}

- (NSString*)getTitle{
    return @"送酒活动统计";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)mytableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSDictionary *dict = nil;
    @try {
        dict = [dataSource objectAtIndex:row];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
    if (currentItemTag == 0) {
        static NSString *cellIndentifier = @"HeWineActivityCell";
        HeWineActivityCell *winecell  = (HeWineActivityCell *)[mytableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (!winecell) {
            winecell = [[HeWineActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            winecell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        winecell.name.text      = [dict valueForKey:@"Name"];
        winecell.telephone.text = [dict valueForKey:@"Mobile"];
        winecell.wineNums.text  = [dict valueForKey:@"RequestNum"];
        winecell.address.text   = [NSString stringWithFormat:@"地址: %@",[dict valueForKey:@"Adress"]];
        winecell.timeLabel.text = [NSString stringWithFormat:@"时间: %@",[dict valueForKey:@"CreateTime"]];
        return winecell;
    }else{
        static NSString *cellIndentifier = @"SubStoreCell";
        SubStoreCell *cell  = (SubStoreCell *)[mytableView dequeueReusableCellWithIdentifier:cellIndentifier];
        
        if (!cell) {
            cell = [[SubStoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.shopName.text  = [dict valueForKey:@"ShopName"];
        cell.wineCount.text = [dict valueForKey:@"RequestNum"];
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (currentItemTag == 0) {
        return 100;
    }else{
        return 50;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
