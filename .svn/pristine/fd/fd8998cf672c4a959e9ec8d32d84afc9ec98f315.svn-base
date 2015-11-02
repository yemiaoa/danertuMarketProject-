//
//  KKFirstViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-3.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "DanertuWoodsController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
@interface DanertuWoodsController (){
    NSMutableArray *arrays;
    UIView *topSegmentView;//---分类,待支付,待评价
    UILabel *flagLb;//编辑,取消lb
}
@end
@implementation DanertuWoodsController
@synthesize gridView;
@synthesize cachedImage;
@synthesize defaults;
@synthesize isShowingActivity;
@synthesize addStatusBarHeight;
@synthesize selectedM;
@synthesize modle;
@synthesize shopId;
@synthesize shopName;
@synthesize imageCache;
@synthesize currentSegmentNo;

- (void)viewDidLoad
{
    //defaults较先初始化,否则在执行[super viewDidLoad]时,需要用到defaults
    defaults =[NSUserDefaults standardUserDefaults];
    [super viewDidLoad];//没有词句,会执行多次
    [self initialization];
    [self getDanDataFormHttp];//读取单耳兔商品
}

- (void)initialization
{
    imageCache = [[NSCache alloc] init];
    isShowingActivity = YES;
    shopId = @"";
    shopName = @"";
    if (!currentSegmentNo) {
        currentSegmentNo = 1;//默认是1
    }
    NSMutableArray *arrays1 = [[NSMutableArray alloc] init];//初始化
    NSMutableArray *arrays2 = [[NSMutableArray alloc] init];//初始化
    NSMutableArray *arrays3 = [[NSMutableArray alloc] init];//初始化
    NSMutableArray *arrays4 = [[NSMutableArray alloc] init];//初始化
    NSMutableArray *arrays5 = [[NSMutableArray alloc] init];//初始化
    arrays = [NSMutableArray arrayWithObjects:arrays1,arrays2,arrays3,arrays4,arrays5, nil];
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    self.navigationController.navigationBar.hidden = YES;
    
    
    NSDictionary *shop = [defaults objectForKey:@"currentShopInfo"];
    NSLog(@"ieopqiqwieiqpeiqpeiq---------%@",shop);
    if ([shop objectForKey:@"type"]) {
        //-------从search网店直接过来的----,没有modle,
        //-------二维码
        UIButton *QRCode = [[UIButton alloc] initWithFrame:CGRectMake(260, 0, 60, 44)];
        //[topNavi addSubview:QRCode];//----二维码
        [QRCode setImage:[UIImage imageNamed:@"grid-white"] forState:UIControlStateNormal];
        [QRCode setImage:[UIImage imageNamed:@"grid-black"] forState:UIControlStateSelected|UIControlStateHighlighted];
        [QRCode addTarget:self action:@selector(onClickQR:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [self createSegment];//创建自定义Segment
    
    //self.navigationItem.backBarButtonItem.title = @"返回商城";//这个值在storyboard里设置,
    //背景
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    self.gridView = [[UITableView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+44+40, MAINSCREEN_WIDTH, self.view.frame.size.height-(addStatusBarHeight+44+40))];//中间区域
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.gridView.autoresizesSubviews = YES;
    self.gridView.delegate = self;
    self.gridView.dataSource = self;
    [self.view addSubview:gridView];
    [Tools setExtraCellLineHidden:gridView];
}

//修改标题
-(NSString*)getTitle{
    NSDictionary *currentShopInfo = [defaults objectForKey:@"currentShopInfo"];
    NSString *title = @"";
    if (currentShopInfo) {
        title =  [currentShopInfo objectForKey:@"shopName"];//商铺 名称;
    }else{
        //-----首页直接过来的-------需要登录判断是否绑定推广店铺
        //[self checkBindShop];
        title = @"单耳兔商城";
    }
    NSLog(@"kgoprhjtrpjhopt----%@",title);
    return title;
}
//-----自定义segment
-(void)createSegment{
    topSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, 40)];
    [self.view addSubview:topSegmentView];
    topSegmentView.backgroundColor = [UIColor whiteColor];
    
    NSArray *titleArr_order = @[@"晓镇香",@"红酒",@"养生酒",@"祛神痛",@"土豪醇"];
    NSInteger itemNum_order = titleArr_order.count;
    int width = 64;
    for (int i=0; i<itemNum_order; i++) {
        UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(width*i, 0, width, 40)];
        text.text = titleArr_order[i];
        text.userInteractionEnabled = YES;
        if (i==currentSegmentNo-1) {
            text.textColor = [UIColor redColor];
        }
        text.textAlignment = NSTextAlignmentCenter;
        text.font = TEXTFONT;
        [topSegmentView addSubview:text];//text
        text.tag = 100+i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(change:)];
        [text addGestureRecognizer:singleTap];//---添加点击事件
    }
    UILabel *border1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 39, MAINSCREEN_WIDTH, 1)];
    [topSegmentView addSubview:border1];
    border1.backgroundColor = BORDERCOLOR;
    
    flagLb = [[UILabel alloc] initWithFrame:CGRectMake(width*(currentSegmentNo-1), 39, width, 1)];
    [topSegmentView addSubview:flagLb];
    flagLb.backgroundColor = [UIColor redColor];
}
//--热门搜索和搜索记录之间的切换
-(void)change:(id)sender{
    NSInteger tag = [[sender view] tag]-100;
    if (tag!=currentSegmentNo-1) {
        [Waiting show];
        [UIView animateWithDuration:0.4 animations:^{
            CGRect frame =  flagLb.frame;
            frame.origin.x = 64 * tag;
            flagLb.frame = frame;
        } completion:^(BOOL finish){
            NSLog(@"nortjhpjopwjopge------%ld--%d--%@",(long)tag,currentSegmentNo,[sender view]);
            UILabel *item = (UILabel *)[sender view] ;
            item.textColor = [UIColor redColor];
            UILabel *preItem = [[topSegmentView subviews] objectAtIndex:currentSegmentNo-1];
            preItem.textColor = [UIColor blackColor];
            currentSegmentNo = tag+1;
            
            if ([arrays[currentSegmentNo-1] count]==0) {
                [self getDanDataFormHttp];//读取单耳兔商品,没有加载过此数据-----
            }else{
                [self.gridView reloadData];//获取  arrays[]  数据重新加载,已经加载过此数据,直接load----
                [Waiting dismiss];
            }
        }];
    }
    NSLog(@"fjowefjopewjpjwpegje---------%ld--%lu",(long)tag,(unsigned long)[arrays[currentSegmentNo-1] count]);
}
//----返回detail页
-(void)onClickBack{
    NSLog(@"23jfieoieopqiqwieiqpeiqpeiq----1--%@",[defaults objectForKey:@"currentShopInfo"]);
    //-----网店,网店只能通过搜索显示,点击网店进入的是单耳兔酒,,这样退出时删除  defaults里的店铺信息
    if ([[[defaults objectForKey:@"currentShopInfo"] objectForKey:@"type"] isEqualToString:@"webShop"]) {
        [defaults removeObjectForKey:@"currentShopInfo"];//---默认当前店铺
    }
    NSLog(@"23jfieoieopqiqwieiqpeiqpeiq----2--%@",[defaults objectForKey:@"currentShopInfo"]);
    NSLog(@"8u9989nvoeioewjfoiejwfoewjfo---back-@%@",self.navigationController.viewControllers);
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:NO];
}
//-----显示二维码
-(void)onClickQR:(id)sender{
    NSDictionary *shop = [defaults objectForKey:@"currentShopInfo"];
    //------点击之后隐藏功能栏
    NSLog(@"eiqooeiwoqpiopeqio");
    NSDictionary *shareInfo = [NSDictionary dictionaryWithObjectsAndKeys:[shop objectForKey:@"shopName"],@"shareTitle",[shop objectForKey:@"shopId"],@"shareId",@"s",@"shareType",nil];
    [defaults setObject:shareInfo forKey:@"shareInfo"];
    
    ShareViewController *sView = [[ShareViewController alloc] init];
    sView.shareInfo = shareInfo;
    [self.navigationController pushViewController:sView animated:YES];
}
/*
//停止滑动后判断是否滑到了底部,决定是否加载  新数据
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"------dragging scroll----%f----%f",scrollView.contentOffset.y,fmaxf(.0f, scrollView.contentSize.height - scrollView.frame.size.height)
          );
    if(scrollView.contentOffset.y>=fmaxf(.0f, scrollView.contentSize.height - scrollView.frame.size.height)){
        self.p = [NSString stringWithFormat:@"%d",[self.p intValue]+1];
        NSLog(@"scroll to  end----%@--!!!!",self.p);
        [self getDanDataFormHttp];
    }
}
*/
//-----读取商品数据
-(void) getDanDataFormHttp{
    [Waiting show];
//    if (gridView) {
//        [self showHudInView:gridView hint:@"加载中..."];
//    }
    AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    NSDictionary * params = @{@"apiid": @"0040",@"type":[NSString stringWithFormat:@"%d",currentSegmentNo],@"kword": @""};
    NSURLRequest * request = [client requestWithMethod:@"POST"
                                                  path:@""
                                            parameters:params];
    AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
//        [self hideHud];
        NSDictionary *jsonData = [[CJSONDeserializer deserializer]deserialize:responseObject error:nil];
        NSArray* temp = [[jsonData objectForKey:@"danProductlist"] objectForKey:@"danProductbean"];//数组
        if(temp.count>0){
            for(int i=0;i<temp.count;i++){
                DanModle *model = [[DanModle alloc] initWithDataDic:[temp objectAtIndex:i]];//对象属性的拷贝
                //[model setOriginalImge:[NSString stringWithFormat:@"http://www.danertu.com%@" , [[temp objectAtIndex:i] objectForKey:@"OriginalImge"]]];//单独修改  图片路径属性,
                NSString *url = [[temp objectAtIndex:i] objectForKey:@"SmallImage"];
                if ([url hasPrefix:@"/ImgUpload/"]) {
                    url = [url stringByReplacingOccurrencesOfString:@"/ImgUpload/" withString:@""];
                }
                [model setSmallImage:[NSString stringWithFormat:@"%@%@" ,DANERTUPRODUCT,url]];//单独修改  图片路径属性,小图,有的没有小图
                [model setWoodFrom:@"danertu"];//-----来自单耳兔
                //-----屏蔽----------一元礼包------
                if (![model.Guid isEqualToString:LIBAOGUID]) {
                    [arrays[currentSegmentNo-1] addObject:model];//追加到数组
                }
                
            }
            [self.gridView reloadData];//获取  arrays  数据重新加载
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
//        [self hideHud];
        [self showHint:REQUESTERRORTIP];
        //[Waiting dismiss];//----隐藏loading----
    }];
    [operation start];//-----发起请求------
}
-(void) checkBindShop{
        [Waiting show];
//        if (isShowingActivity) {
//            [Waiting show];
//        }
        AFHTTPClient * client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        NSDictionary * params = @{@"apiid": @"0059",@"mobile" :[[defaults objectForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"]};
        NSLog(@"locationString---------:%@",params);
        NSURLRequest * request = [client requestWithMethod:@"POST"
                                                      path:@""
                                                parameters:params];
        AFHTTPRequestOperation * operation = [client HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];
            NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (str) {
                shopId = str;
            }
            NSLog(@"qweqeqeq-----%@",str);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"faild , error == %@ ", error);
            [Waiting dismiss];
        }];
        [operation start];//-----发起请求------
        NSLog(@"---start to checkBindShop------");
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
#pragma mark AQGridViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrays[currentSegmentNo-1]  count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"PlainCell";
    DanertuWoodsViewCell * cell = (DanertuWoodsViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        //cell = [[GridViewCell alloc] initWithFrame:CGRectMake(0, 0, 160, 175) reuseIdentifier:identifier];
        cell = [[DanertuWoodsViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //取得每一个数据
    DanModle *danModle = [arrays[currentSegmentNo-1]  objectAtIndex:indexPath.row];
    
    NSString *imageKey = [NSString stringWithFormat:@"%@%ld",danModle.SmallImage,(long)indexPath.row];
    AsynImageView *image = [imageCache objectForKey:imageKey];
    if (image) {
        cell.imageView = image;
        
    }
    else{
        cell.imageView.imageURL = danModle.SmallImage;
        image = cell.imageView;
        [imageCache setObject:image forKey:imageKey];
    }
    [cell.mainView addSubview:cell.imageView];
    //------这里加判断如果可以就去下载图片-------
    /*
    [cell.catView setBackgroundImage:[UIImage imageNamed:@"shopcat.png"] forState:UIControlStateNormal];
    [cell.catView setBackgroundImage:[UIImage imageNamed:@"shopcat-gray"] forState:UIControlStateHighlighted];
    cell.catView.tag = index;
    [cell.catView addTarget:self action:@selector(addToShopList:) forControlEvents:UIControlEventTouchUpInside];//----点击事件
    */
    [cell.woodsLabel setText:danModle.Name];//店铺名称
    [cell.marketPriceLabel setText:[NSString stringWithFormat:@"¥ %@", danModle.MarketPrice]];//价格
    //获取市场价格后,得到字符串的width,height
    UIFont *font = [UIFont systemFontOfSize:14];
    CGSize size = CGSizeMake(500, 2000);//足够大的个CGSize
    CGSize labelsize = [[NSString stringWithFormat:@"¥ %@", danModle.MarketPrice] sizeWithFont:font constrainedToSize:size lineBreakMode: NSLineBreakByWordWrapping];
    cell.lineLabel.frame = CGRectMake(100, 45,labelsize.width, 1);//这里修改width,以适应市场价格的width
    
   
    [cell.priceLabel setText:[NSString stringWithFormat:@"¥ %@", danModle.ShopPrice]];//价格
    return cell;
}
//选中Item
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedM = [arrays[currentSegmentNo-1] objectAtIndex:indexPath.row];
    GoodsDetailController *woodsController = [[GoodsDetailController alloc] init];
    woodsController.hidesBottomBarWhenPushed = NO;
    woodsController.danModleGuid =  selectedM.Guid;
    woodsController.modle = modle;
    [self.navigationController pushViewController:woodsController animated:YES];
    NSLog(@"jqwoepqjfpo=====");
}

//-----------内存不足报警------
-(void)didReceiveMemoryWarning
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    [super didReceiveMemoryWarning];
    NSLog(@"memory warning,kkappdelegate---");
}
@end
