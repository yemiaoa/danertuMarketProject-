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
#import "CommentViewController.h"
@implementation CommentViewController
@synthesize addStatusBarHeight;
@synthesize backHomeIcon;
@synthesize gridView;;
@synthesize commendModle;
@synthesize defaults;
@synthesize arrays;
@synthesize p;
@synthesize reachTop;
@synthesize addCommentIcon;
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
    arrays = [[NSMutableArray alloc] init];//初始化
    self.p = @"1";//当前页
    self.isHaveMore = YES;
    self.isHaveData = YES;
    self.isNetWorkRight = YES;
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
    topNaviText.text = [NSString stringWithFormat:@"商品评论(%@)",[[defaults objectForKey:@"currentWoodsInfo"] objectForKey:@"commentNum"]];
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
    
    //---添加新评论---
    UILabel *addCommentLb = [[UILabel alloc]initWithFrame:CGRectMake(240, 0, 80, 44)];
    addCommentLb.userInteractionEnabled = YES;
    addCommentLb.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *singleTap2 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addComment)];
    [addCommentLb addGestureRecognizer:singleTap2];//---添加点击事件
    [topNavi addSubview:addCommentLb];
    
    addCommentIcon = [[UIImageView alloc]initWithFrame:CGRectMake(50, 15, 15, 15)];
    addCommentIcon.image = [UIImage imageNamed:@"plus-orange"];
    addCommentIcon.userInteractionEnabled = YES;
    [addCommentLb addSubview:addCommentIcon];
    
    //-------数据区域--------
    gridView = [[UITableView alloc] initWithFrame:CGRectMake(0, 45 + addStatusBarHeight, MAINSCREEN_WIDTH, self.view.frame.size.height-(45+addStatusBarHeight))];//中间区域,出去不可滑动的区域
    gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gridView.autoresizesSubviews = YES;
    gridView.delegate = self;
    gridView.dataSource = self;
    [self.view addSubview: gridView];
    //NSLog(@"kdsoakdposakpdoa-------%f",gridView.frame.size.height);
    
    //-------回到顶部按钮------
    reachTop = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60,self.view.frame.size.height-60-49,  60, 60)];
    [reachTop setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8]];//
    [reachTop setImage:[UIImage imageNamed:@"arrow-u-orange"] forState:UIControlStateNormal];
    [reachTop setImage:[UIImage imageNamed:@"arrow-u-black"] forState:UIControlStateHighlighted];
    [reachTop addTarget:self action:@selector(pageTop) forControlEvents:UIControlEventTouchUpInside];
    reachTop.hidden = YES;
    [self.view insertSubview:reachTop aboveSubview:gridView];
    
    //---------读取评论--------
    [self getComments];//------读取评论数据------
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
//-----点击返回
-(void)onClickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"----backLogin---图片被点击!------");
}
//-----点击添加
-(void)addComment{
    [self performSegueWithIdentifier:@"addComment" sender:self];
}

/*
 AgentID = 13715598598;
 Content = "\U8fd9\U9152\U4e0d\U9519\Uff0c\U9187\U9999";
 Guid = "2a785068-9d58-4ec1-8528-d8a3e246b916";
 MemLoginID = 13135675677;
 ProductGuid = "e4358ec8-1265-4182-b7ed-119ae4c8265a";
 Rank = 1;
 SendTime = "2014-1-21 17:30:17";
 */
//------获取评论------
-(void)getComments{
    if (self.isHaveMore) {
        [Waiting show];//-----loading-----
        NSDictionary *wood = [defaults objectForKey:@"currentWoodsInfo"];
        NSString *guid = [wood objectForKey:@"productguid"] ;//-----获取当前的guid-----
        AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        NSDictionary * params = @{@"apiid": @"0066",@"productguid":guid,@"pagesize":@"10",@"pageindex":self.p};
        NSURLRequest * request = [client requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject){
            NSString *data = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            SBJsonParser * parser = [[SBJsonParser alloc] init];
            NSMutableDictionary *jsonData = [parser objectWithString:[data stringByReplacingOccurrencesOfString:@"\\" withString:@" "]];//----字符串替换---
            NSArray *temp = [[jsonData objectForKey:@"procommentList"] objectForKey:@"procommentbean"];//读取城市相关信息
            CommentModle *model = [[CommentModle alloc] init];//对象数据模型
            if(temp.count > 0){
                for(int i = 0; i < temp.count;i++){
                    model = [[CommentModle alloc] initWithDataDic:[temp objectAtIndex:i]];//对象属性的拷贝
                    [arrays addObject:model];//追加到数组
                }
                //一次读取的数量小于10
                if (temp.count<10) {
                    self.isHaveMore = NO;
                }
                //一次读取的数量=10,并且和总数相等
                if (temp.count==10&&arrays.count==[[[defaults objectForKey:@"currentWoodsInfo"] objectForKey:@"commentNum"] intValue]) {
                    self.isHaveMore = NO;
                }
                
            }else{
                self.isHaveMore = NO;//没有更多数据
                if(arrays.count==0){
                    self.isHaveData = NO;//没有数据,arrays为空,第一次就没有请求到数据
                    [arrays addObject:model];
                }//这里添加一个空的  数据对象,否则无法执行,添加数据
            }
            [gridView reloadData];//这里没有数据也用执行,因为不执行,就一直显示之前的数据,切换城市时出错
            [Waiting dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];
        }];
        [operation start];//发起请求
    }
}

//回到顶部
- (void)pageTop{
    reachTop.hidden = YES;//隐藏
    [gridView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

//scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollViewTmp
{
    if (gridView.contentOffset.y>1000) {
        reachTop.hidden = NO;//显示回到顶部
    }else{
        reachTop.hidden = YES;//隐藏回到顶部
    }
}
//停止滑动后判断是否滑到了底部,决定是否加载  新数据
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollViewTmp willDecelerate:(BOOL)decelerate
{
    if((gridView.contentOffset.y>=fmaxf(.0f, scrollViewTmp.contentSize.height - scrollViewTmp.frame.size.height))){
        self.p = [NSString stringWithFormat:@"%d",[self.p intValue]+1];
        [self getComments];
    }
}
#pragma mark AQGridViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrays  count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

//数据填充
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModle *modle = [arrays objectAtIndex:indexPath.row];
    static NSString *identifier = @"PlainCell";//没意义的cell,id变量
    CommentViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        //cell = [[GridViewCell alloc] initWithFrame:CGRectMake(0, 0, 160, 175) reuseIdentifier:identifier];
        cell = [[CommentViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.clientLabel setText:modle.MemLoginID];//客户id
    [cell.contentLabel setText:modle.Content];//内容
    [cell.dateLabel setText:modle.SendTime];//时间
    [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"star%@",modle.Rank]]];
    
    return cell;
}
//----触摸事件,点击热区状态变化
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self.view];
    if (point.x<60&point.y<44+addStatusBarHeight) {
        backHomeIcon.image = [UIImage imageNamed:@"carat-d-black"];
    }else if(point.x>260&point.y<44){
        addCommentIcon.image = [UIImage imageNamed:@"plus-black"];
    }
    NSLog(@"nveojoejwfojwgoehgo-----%f,%f",point.x,point.y);
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    backHomeIcon.image = [UIImage imageNamed:@"carat-d-orange"];
    addCommentIcon.image = [UIImage imageNamed:@"plus-orange"];
}
- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    backHomeIcon.image = [UIImage imageNamed:@"carat-d-orange"];
    addCommentIcon.image = [UIImage imageNamed:@"plus-orange"];
}
//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
