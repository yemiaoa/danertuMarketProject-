//
//  SellOrderManageViewController.m
//  单耳兔
//
//  Created by yang on 15/6/30.
//  Copyright (c) 2015年 无锡恩梯梯数据有限公司. All rights reserved.
//
//卖家中心->订单管理

#import "SellOrderManageViewController.h"
#import "SellOrderCell.h"
#import "SellOrderDetailViewController.h"
#import "Waiting.h"
#import "UIView+Toast.h"
#import "AFHTTPRequestOperation.h"
#import "AsynImageView.h"
#import "SDRefresh.h"

@interface SellOrderManageViewController ()
{
    int addStatusBarHeight;
    UIView *topSegmentView;
    UIView *secondSegmentView;
    UIView *noItemView;
    
    UILabel *noPayLabel;
    UILabel *noConsignmentLabel;
    UILabel *noRefundmentLabel;
    int pageIndex;
    int currentOrderState; //待付款:0,待发货:1,退款中:2,已完成:3
    NSString *payState;    //支付状态 0:未付款 1:付款中 2:已付款 3:退款
    NSString *shipState;   //发货状态 0:未发货 1:已发货 4:已退货
    NSCache *imageCache;
    NSString *orderState;  //发货状态 0:未确认 1:已确定 2:已取消 3:无效 4:申请退货 5.已完成
    BOOL isNeedCleanOrder; //上拉动作不需要清除数据,切换选项时需要清除数据
    int _totalPageCount;   //后台返回总页数
    
    SDRefreshFooterView *refreshFooter;
}
@end

@implementation SellOrderManageViewController
@synthesize currentClickTag;
@synthesize gridView;
@synthesize currentSecondSegTag;
@synthesize dataSourceArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"reloadShopOrderListNotification" object:nil];
    
    [self initView];
    [self setupFooter];
    isNeedCleanOrder = NO;
    [self loadData];
    
}

-(NSString*)getTitle{
    return @"订单管理";
}

-(void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupFooter{
    refreshFooter = [SDRefreshFooterView refreshView];
    [refreshFooter addToScrollView:gridView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
}

- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [refreshFooter endRefreshing];
        if (_totalPageCount == pageIndex) {
            return;
        }
        isNeedCleanOrder = NO;
        [self loadData];
    });
}

-(void)initView{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    [self.view setBackgroundColor:[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1]];
    
    //初始化数据
    dataSourceArr = [[NSMutableArray alloc] init];
    currentClickTag = 0;
    currentSecondSegTag = 0;
    pageIndex = 1;
    _totalPageCount = 1;
    //默认选中[全部]
    payState   = @"";
    shipState  = @"";
    orderState = @"";
    
    imageCache = [[NSCache alloc] init];
    
    //白色背景
    topSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT, MAINSCREEN_WIDTH, 40)];
    [self.view addSubview:topSegmentView];
    [topSegmentView setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *itemArr = @[@"进行中",@"已完成"];
    int itemCount = (int)itemArr.count;
    
    for (int i = 0; i < itemCount; i ++) {
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH/2*i, 0, MAINSCREEN_WIDTH/2, 40)];
        [topSegmentView addSubview:itemLabel];
        [itemLabel setText:[itemArr objectAtIndex:i]];
        [itemLabel setFont:[UIFont systemFontOfSize:16]];
        [itemLabel setTextAlignment:NSTextAlignmentCenter];
        [itemLabel setTag:100+i];
        [itemLabel setUserInteractionEnabled:YES];
        if (i == currentClickTag) {
            [itemLabel setTextColor:[UIColor redColor]];
        }
        //添加点击事件
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickItem:)];
        [itemLabel addGestureRecognizer:singleTap];
    }
    
    //白色背景
    secondSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT + 50, MAINSCREEN_WIDTH, 30)];
    [self.view addSubview:secondSegmentView];
    [secondSegmentView setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *onItemArr = @[@"全部",@"待付款",@"待发货",@"退款中"];
    for (int i = 0; i < (int)[onItemArr count]; i++) {
        UILabel *itemL = [[UILabel alloc] initWithFrame:CGRectMake(i*80, 0, 80, 30)];
        [secondSegmentView addSubview:itemL];
        [itemL setBackgroundColor:[UIColor clearColor]];
        [itemL setText:[onItemArr objectAtIndex:i]];
        [itemL setFont:TEXTFONT];
        [itemL setTextAlignment:NSTextAlignmentCenter];
        [itemL setTag:500+i];
        [itemL setUserInteractionEnabled:YES];
        if (i == currentSecondSegTag) {
            [itemL setTextColor:[UIColor redColor]];
        }
        //---添加点击事件
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickSecondSegmentItem:)];
        [itemL addGestureRecognizer:singleTap];
    }
    
    for (int i = 1; i < (int)[onItemArr count]; i++) {
        //分割线
        UIView *borderLabel = [[UIView alloc] initWithFrame:CGRectMake(i*80, 0, 0.6, 30)];
        [secondSegmentView addSubview:borderLabel];
        [borderLabel setBackgroundColor:BORDERCOLOR];
    }
    
    //待付款数量
    noPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(142, 0, 20, 30)];
    [secondSegmentView addSubview:noPayLabel];
    [noPayLabel setBackgroundColor:[UIColor clearColor]];
    [noPayLabel setFont:TEXTFONT];
    [self setNoPayLabelText:0];
    //待发货数量consignment
    noConsignmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(222, 0, 20, 30)];
    [secondSegmentView addSubview:noConsignmentLabel];
    [noConsignmentLabel setBackgroundColor:[UIColor clearColor]];
    [noConsignmentLabel setFont:TEXTFONT];
    [self setNoConsignmentLabelText:0];
    //退款中数量refundment
    noRefundmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(302, 0, 20, 30)];
    [secondSegmentView addSubview:noRefundmentLabel];
    [noRefundmentLabel setBackgroundColor:[UIColor clearColor]];
    [noRefundmentLabel setFont:TEXTFONT];
    [self setNoRefundmentLabelText:0];
    //判断初始化时是否隐藏
    [secondSegmentView setHidden:(currentClickTag != 0)];
    
    //gridView
    int tableView_Y = (currentClickTag != 0) ? (addStatusBarHeight + TOPNAVIHEIGHT + 45) : (addStatusBarHeight + TOPNAVIHEIGHT + 85);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = layout.minimumInteritemSpacing;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    gridView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, tableView_Y, MAINSCREEN_WIDTH, self.view.frame.size.height-tableView_Y) collectionViewLayout:layout];
    gridView.delegate            = self;
    gridView.dataSource          = self;
    [gridView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:gridView];
    [gridView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    noItemView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT + 180, MAINSCREEN_WIDTH, 150)];
    [self.view addSubview:noItemView];
    //图片
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 100, 100)];
    [noItemView addSubview:imgView];
    [imgView setImage:[UIImage imageNamed:@"noOrder"]];
    //文字
    UILabel *noOrderText = [[UILabel alloc] initWithFrame:CGRectMake(60, 110, 200, 40)];
    [noItemView addSubview:noOrderText];
    [noOrderText setBackgroundColor:[UIColor clearColor]];
    [noOrderText setTextAlignment:NSTextAlignmentCenter];
    [noOrderText setTextColor:[UIColor grayColor]];
    [noOrderText setText:@"抱歉,没有找到相关订单"];
    
    noItemView.hidden = YES;
}
//待付款数量
-(void)setNoPayLabelText:(int)num{
    if (num != 0) {
        [noPayLabel setTextColor:[UIColor redColor]];
    }
    [noPayLabel setText:[NSString stringWithFormat:@"%d",num]];
}
//待发货数量
-(void)setNoConsignmentLabelText:(int)num{
    if (num != 0) {
        [noConsignmentLabel setTextColor:[UIColor redColor]];
    }
    [noConsignmentLabel setText:[NSString stringWithFormat:@"%d",num]];
}
//退款中数量
-(void)setNoRefundmentLabelText:(int)num{
    if (num != 0) {
        [noRefundmentLabel setTextColor:[UIColor redColor]];
    }
    [noRefundmentLabel setText:[NSString stringWithFormat:@"%d",num]];
}

-(void)loadData{
    //有下一页
    if (pageIndex < _totalPageCount) {
        pageIndex ++;
    }
    
    [Waiting show];
    NSDictionary * params  = @{@"apiid": @"0237",
                           @"memberid" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"],
                             @"pState" : payState,
                             @"sState" : shipState,
                             @"oState" : orderState,
                          @"pageIndex" : [NSNumber numberWithInt:pageIndex],
                           @"pageSize" : [NSNumber numberWithInt:8]};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        NSString *respondStr = operation.responseString;
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[respondStr objectFromJSONString]];
        
        if (isNeedCleanOrder){
            [dataSourceArr removeAllObjects];
        }
        
        if ([[tempDic valueForKey:@"orderList"] count] > 0) {
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:[tempDic valueForKey:@"orderList"]];
            
            if ([payState isEqualToString:@""]&&[shipState isEqualToString:@""]&&[orderState isEqualToString:@""]) {
                //[全部]中的数据,[全部]中要除去[已完成]中的数据
                for (int i = 0; i < [tempArr count]; i++) {
                    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[tempArr objectAtIndex:i]];
                    int tempOderStatus     = [[dic valueForKey:@"OderStatus"] intValue];
                    if (tempOderStatus == 5) {
                    }else{
                        [dataSourceArr addObject:dic];
                    }
                }
                if ([dataSourceArr count] == 0) {
                    noItemView.hidden = NO;
                }
            }else{
                //其他选项的数据
                [dataSourceArr addObjectsFromArray:tempArr];
            }
            //订单数据不为空
            _totalPageCount = [[tempDic valueForKey:@"TotalPageCount_o"] intValue];
        }else{
            noItemView.hidden = NO;
        }
        
        if (currentClickTag == 0) {
            [self loadOrderListCountData];
        }
        
        [gridView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    
    [operation start];
}

//请求订单列表的数量统计
-(void)loadOrderListCountData{
    [Waiting show];
    NSDictionary * params  = @{@"apiid": @"0241",@"shopid" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"]};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        NSString *respondStr = operation.responseString;
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[respondStr objectFromJSONString]];
        if ([tempDic valueForKey:@"val"]) {
            [self setNoPayLabelText:[[[[tempDic valueForKey:@"val"] objectAtIndex:0] valueForKey:@"dfk"] intValue]];
            [self setNoConsignmentLabelText:[[[[tempDic valueForKey:@"val"] objectAtIndex:0] valueForKey:@"dfh"] intValue]];
            [self setNoRefundmentLabelText:[[[[tempDic valueForKey:@"val"] objectAtIndex:0] valueForKey:@"tkz"] intValue]];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    
    [operation start];
}

-(void)onClickItem:(id)sender{
    
    int clickTag = (int)[[sender view] tag];
    if (currentClickTag == clickTag-100) {
        return;
    }
    pageIndex = 1;//初始化页数
    _totalPageCount = 1;
    isNeedCleanOrder = YES;
    noItemView.hidden = YES;
    
    //先移除原来的选中界面
    UILabel *tempItem = [[topSegmentView subviews] objectAtIndex:currentClickTag];
    tempItem.textColor = [UIColor blackColor];

    currentClickTag = clickTag -100;
    [UIView animateWithDuration:0.4 animations:^{
    } completion:^(BOOL finish){
        UILabel *preItem = [[topSegmentView subviews] objectAtIndex:currentClickTag];
        preItem.textColor = [UIColor redColor];
        
        //重新设置tableview的位置
        [self rebuildTopSegmentView];
        
        [self resetParamsItems];
        
        [self loadData];
    }];
}

-(void)rebuildTopSegmentView{
    [secondSegmentView setHidden:(currentClickTag != 0)];
    int tableView_Y = (currentClickTag != 0) ? (addStatusBarHeight + TOPNAVIHEIGHT + 45) : (addStatusBarHeight + TOPNAVIHEIGHT + 85);
    [gridView setFrame:CGRectMake(0, tableView_Y, MAINSCREEN_WIDTH, self.view.frame.size.height-tableView_Y)];
}

-(void)onClickSecondSegmentItem:(id)sender{
    int onSegTag = (int)[[sender view] tag];
    if (currentSecondSegTag == onSegTag-500) {
        return;
    }
    pageIndex = 1;//初始化页数
    _totalPageCount = 1;
    isNeedCleanOrder = YES;
    noItemView.hidden = YES;
    
    //先移除原来的选中界面
    UILabel *tempItem = [[secondSegmentView subviews] objectAtIndex:currentSecondSegTag];
    tempItem.textColor = [UIColor blackColor];
    
    currentSecondSegTag = onSegTag - 500;
    
    [UIView animateWithDuration:0.4 animations:^{
    } completion:^(BOOL finish){
        UILabel *preItem  = [[secondSegmentView subviews] objectAtIndex:currentSecondSegTag];
        preItem.textColor = [UIColor redColor];

        [self resetParamsItems];
        
        [self loadData];
    }];
}

//设置请求数据的参数值
-(void)resetParamsItems{
    if (currentClickTag == 0) {
        //进行中 (默认选中全部)
        if (currentSecondSegTag == 0) {
            //全部
            payState   = @"";
            shipState  = @"";
            orderState = @"";
        }else if (currentSecondSegTag == 1){
            //待付款
            payState   = @"0";
            shipState  = @"0";
            orderState = @"1";
        }else if (currentSecondSegTag == 2){
            //待发货
            payState   = @"2";
            shipState  = @"0";
            orderState = @"1"; //发货状态 0:未确认 1:已确定 2:已取消 3:无效 4:申请退货
        }else if (currentSecondSegTag == 3){
            //退款中
            payState   = @"2";
            shipState  = @"";
            orderState = @"4";
        }
    }else if (currentClickTag == 1){
        //已完成
        payState   = @"";
        shipState  = @"";
        orderState = @"5";
    }
}

-(NSString *)setOrderStatusWithDic:(NSDictionary*)tempDic
{
    int paymentStatus  = [[tempDic valueForKey:@"PaymentStatus"] intValue];
    int shipmentStatus = [[tempDic valueForKey:@"ShipmentStatus"] intValue];
    int oderStatus     = [[tempDic valueForKey:@"OderStatus"] intValue];
    
    NSString *OrderStatusStr = @"";
    if (paymentStatus==0&&shipmentStatus==0&&oderStatus==1) {
         OrderStatusStr  = @"待付款";
    }else if (paymentStatus==2&&shipmentStatus==0&&oderStatus==1){
        OrderStatusStr = @"待发货";
    }else if (paymentStatus==2&&oderStatus==4){
         OrderStatusStr = @"退款中";
    }else if (oderStatus==2){
         OrderStatusStr  = @"已取消";
    }else if (oderStatus==3){
         OrderStatusStr  = @"已无效";
    }else if (paymentStatus==3&&oderStatus==4){
        OrderStatusStr   = @"已退款";
    }else if(oderStatus==0){
        OrderStatusStr   = @"未确认";
    }else if(oderStatus==5){
        OrderStatusStr   = @"已完成";
    }
    
    return OrderStatusStr;
}

#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [dataSourceArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.item;
    static NSString *cellIdentifier = @"cell";
    UICollectionViewCell *cell = [gridView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    //大的cell会显示一部分,当前cell的尺寸是小的,,所以大cell的图像还会被当前cell之后的cell遮住
    for (id t in [cell subviews]) {
        [t removeFromSuperview];
    }
    
    NSDictionary *tempDic = [NSDictionary dictionaryWithDictionary:[dataSourceArr objectAtIndex:index]];
    
    //---------最大整个view
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 145-50)];
    contentView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:contentView];

    //标题view
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 35)];
    [contentView addSubview:titleView];
    
    //----订单号---
    UILabel *orderNo = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 15)];
    [titleView addSubview:orderNo];
    orderNo.font = TEXTFONTSMALL;
    orderNo.textColor = [UIColor orangeColor];
    orderNo.text = [NSString stringWithFormat:@"订单号: %@", [tempDic valueForKey:@"OrderNumber"]] ;
    
    UILabel *orderTime = [[UILabel alloc] initWithFrame:CGRectMake(170, 0, 130, 15)];
    [titleView addSubview:orderTime];
    orderTime.font = TEXTFONTSMALL;
    orderTime.textColor = [UIColor grayColor];
    orderTime.textAlignment = NSTextAlignmentRight;
    orderTime.text = [NSString stringWithFormat:@"%@", [tempDic valueForKey:@"CreateTime"]];
    
    UILabel *consignee = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 170, 15)];
    [titleView addSubview:consignee];
    consignee.font = TEXTFONTSMALL;
    consignee.textColor = [UIColor grayColor];
    [consignee setText:[NSString stringWithFormat:@"收货人:%@",[tempDic valueForKey:@"Name"]]];
    
    UILabel *orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 18, 130, 15)];
    [titleView addSubview:orderStateLabel];
    [orderStateLabel setTextColor:[UIColor redColor]];
    [orderStateLabel setFont:TEXTFONTSMALL];
    orderStateLabel.textAlignment = NSTextAlignmentRight;
    [orderStateLabel setText:[self setOrderStatusWithDic:tempDic]];
    
    UILabel *border_t = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, 300, 1)];
    [titleView addSubview:border_t];
    border_t.backgroundColor = VIEWBGCOLOR;
    
    //商品view
    NSArray *woodArray = [tempDic objectForKey:@"productList"];
    NSInteger woodsNum = woodArray.count;
    
    UIView *woodsView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, 300, 55 * woodsNum)];
    [contentView addSubview:woodsView];
    contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 90+55*woodsNum-50);
    
    for (int i = 0; i < woodsNum; i++) {
        
        NSDictionary *itemDic = [[tempDic valueForKey:@"productList"] objectAtIndex:i];
        
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0, 55*i, 300, 55)];
        item.accessibilityIdentifier = [NSString stringWithFormat:@"%ld/%d",(long)index,i];
        [woodsView addSubview:item];
        
        AsynImageView *woodImage = [[AsynImageView alloc] initWithFrame:CGRectMake(0, 5, 45, 45)];
        [item addSubview:woodImage];
        //商品图片
        NSString *imageUrl = [Tools getGoodsImageUrlWithData:[[tempDic valueForKey:@"productList"] objectAtIndex:i]];
        if ([[tempDic valueForKey:@"SmallImage"] isEqualToString:@""]) {
            woodImage.image         = [UIImage imageNamed:@"noData1"];
        }else{
            woodImage.placeholderImage = [UIImage imageNamed:@"noData1"];
            woodImage.imageURL         = imageUrl;
        }
        
        //商品名称
        UILabel *woodName = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 240, 20)];
        [item addSubview:woodName];
        woodName.font = TEXTFONT;
        woodName.text = [NSString stringWithFormat:@"名称: %@",[itemDic objectForKey:@"productName"]];
        
        //数量
        UILabel *woodCount = [[UILabel alloc] initWithFrame:CGRectMake(60, 30, 200, 20)];
        [item addSubview:woodCount];
        woodCount.font = TEXTFONT;
        woodCount.text = [NSString stringWithFormat:@"数量: %@",[itemDic objectForKey:@"BuyNumber"]];
        
        if (i != woodsNum-1) {
            //分割线
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            [shapeLayer setBounds:item.bounds];
            [shapeLayer setPosition:item.center];
            [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
            // 设置虚线颜色为black
            [shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
            // 3.0f设置虚线的宽度
            [shapeLayer setLineJoin:kCALineJoinRound];
            // 3=线的宽度 1=每条线的间距
            [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],nil]];
            // Setup the path
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, 0, 54);       //100 ,67 初始点 x,y
            CGPathAddLineToPoint(path, NULL, 300,54);     //67终点x,y
            [shapeLayer setPath:path];
            CGPathRelease(path);
            [[item layer] addSublayer:shapeLayer];
        }
    }
    return cell;
}

#pragma mark UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    int index = (int)indexPath.row;
    int height = (int)[[[dataSourceArr objectAtIndex:index] valueForKey:@"productList"] count];
    height = 90 + 55*height - 50;
    CGSize size = CGSizeMake(MAINSCREEN_WIDTH,height);
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int OderStatusNum = [[[dataSourceArr objectAtIndex:indexPath.row] valueForKey:@"OderStatus"] intValue];
    int ShipmentStatusNum = [[[dataSourceArr objectAtIndex:indexPath.row] valueForKey:@"ShipmentStatus"] intValue];
    int PaymentStatusNum = [[[dataSourceArr objectAtIndex:indexPath.row] valueForKey:@"PaymentStatus"] intValue];
    
    if (OderStatusNum == 1) {
        if (ShipmentStatusNum == 0 && PaymentStatusNum == 2) {
            currentOrderState = 1; //待发货
        }else if (ShipmentStatusNum == 0 && PaymentStatusNum == 0){
            currentOrderState = 0; //待付款
        }else if(ShipmentStatusNum == 1 && PaymentStatusNum == 2){
            currentOrderState = 6; //已完成
        }
    }else if(OderStatusNum == 4){
        currentOrderState = 2; //退款中
    }else if (OderStatusNum==4&&PaymentStatusNum == 3){
        currentOrderState = 3; //已退款
    }else if (OderStatusNum==2){
        currentOrderState = 4; //已取消
    }else if (OderStatusNum==0){
        currentOrderState = 5; //未确认
    }
    
    SellOrderDetailViewController * sellOrderDetailVC = [[SellOrderDetailViewController alloc] init];
    sellOrderDetailVC.sellOrderDic = [dataSourceArr objectAtIndex:indexPath.row];
    //0: 待付款"1:"待发货",2:"退款中",3:"已退款",4:"已取消",5:"未确认",6:"已完成
    sellOrderDetailVC.currentOrderStype = currentOrderState;
    sellOrderDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sellOrderDetailVC animated:YES];
}

- (void)dealloc
{
    [refreshFooter removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
