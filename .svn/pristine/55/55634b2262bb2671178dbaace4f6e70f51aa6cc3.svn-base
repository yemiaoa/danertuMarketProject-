//
//  SearchShopViewController.m
//  单耳兔
//
//  Created by yang on 15/8/10.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

//搜索店铺
#import "SearchShopViewController.h"
#import "DetailViewController.h"
#import "DataModle.h"
#import "AFHTTPRequestOperation.h"
#import "UIView+Toast.h"
#import "SearchShopCell.h"
#import "SDRefresh.h"
@interface SearchShopViewController ()
{
    int addStatusBarHeight;
    UITableView *_tableView;
    NSMutableArray *dataSourceArr;
    UIView *noDataView;
    UIButton *reachTop;
    NSCache *imageCache;
    
    SDRefreshHeaderView *refreshHeader;
}
@end

@implementation SearchShopViewController
@synthesize keyWord;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self setupHeader];
    [self loadData];
}

- (NSString*)getTitle
{
    return [NSString stringWithFormat:@"搜索关键字:%@",keyWord];
}

- (void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupHeader
{
    refreshHeader = [SDRefreshHeaderView refreshView];
    // 默认是在navigationController环境下，如果不是在此环境下，请设置 refreshHeader.isEffectedByNavigationController = NO;
    [refreshHeader addToScrollView:_tableView];
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    __block typeof(self) bself = self;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [bself loadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}

- (void)initView{
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    [self.view setBackgroundColor:[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1]];
    int y = iOS7 ? 0 : 20;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT - addStatusBarHeight-TOPNAVIHEIGHT-y)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [Tools setExtraCellLineHidden:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //没有数据显示的view
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPNAVIHEIGHT+addStatusBarHeight, MAINSCREEN_WIDTH, CONTENTHEIGHT+49)];
    [self.view addSubview:noDataView];
    
    int topDistance = (CONTENTHEIGHT + 49- 130)/2;
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(110, topDistance, 100, 100)];
    [noDataView addSubview:imgV];
    [imgV setImage:[UIImage imageNamed:@"noData"]];
    
    UILabel *textV = [[UILabel alloc] initWithFrame:CGRectMake(60, topDistance+100, 200, 30)];
    [noDataView addSubview:textV];
    textV.backgroundColor = [UIColor clearColor];
    textV.textAlignment = NSTextAlignmentCenter;
    textV.text = @"抱歉!没有数据";

    noDataView.hidden = YES;
    
    //回到顶部按钮
    reachTop = [[UIButton alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH - 60,MAINSCREEN_HEIGHT-60-49,  60, 60)];
    [self.view addSubview:reachTop];
    [reachTop setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:0.8]];//
    [reachTop setImage:[UIImage imageNamed:@"arrow-u-orange"] forState:UIControlStateNormal];
    [reachTop setImage:[UIImage imageNamed:@"arrow-u-black"] forState:UIControlStateHighlighted];
    [reachTop addTarget:self action:@selector(pageTop) forControlEvents:UIControlEventTouchUpInside];
    reachTop.hidden = YES;
   
    dataSourceArr = [[NSMutableArray alloc] init];
    imageCache = [[NSCache alloc] init];
}

- (void)loadData{
    [Waiting show];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0044",@"apiid",keyWord, @"kword" , nil];
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
    
        NSString* jsonDataStr  = [Tools deleteErrorStringInData:responseObject];
        NSData *jsonDataTmp    = [jsonDataStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:jsonDataTmp options:NSJSONReadingMutableLeaves error:nil];//json解析
        DataModle *model       = [[DataModle alloc] init];//对象数据模型
        NSMutableArray *temp   = [[jsonData objectForKey:@"supplierprocuctList"] objectForKey:@"supplierproductbean"];
        if ([dataSourceArr count] > 0) {
            [dataSourceArr removeAllObjects];
        }
        if(temp.count > 0){
            noDataView.hidden = YES;
            for(int i=0;i<temp.count;i++){
                model = [[DataModle alloc] initWithDataDic:[temp objectAtIndex:i]];//对象属性的拷贝
                [dataSourceArr addObject:model];
            }
        }else{
            noDataView.hidden = NO;
        }
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    [operation start];

}

- (void)pageTop{
    reachTop.hidden = YES;//----隐藏------
    [UIView animateWithDuration:1.0 animations:^{
        [_tableView setContentOffset:CGPointMake(0, 0) animated:YES];
//        [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    }];
    
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSourceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"SearchShopCell";
    SearchShopCell *cell = (SearchShopCell *)[_tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SearchShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    DataModle *modle = nil;
    modle = [dataSourceArr objectAtIndex:indexPath.item];
    NSInteger index = [indexPath row];
    //商品图片
    NSString *smallImage = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,modle.id, modle.e];
    NSString *imageKey = [NSString stringWithFormat:@"%@%lu",smallImage,(long)index];
    AsynImageView *image = [imageCache objectForKey:imageKey];
    if (image == nil) {
        cell.shopImage.imageURL = smallImage;
        image = cell.shopImage;
        [imageCache setObject:image forKey:imageKey];
    }
    else{
        cell.shopImage = image;
    }
    
    if ([modle.s isEqualToString:@""]) {
        cell.shopNameL.text = @"--";
    }else{
        cell.shopNameL.text = [NSString stringWithFormat:@"%@",modle.s];
    }
    
    if ([modle.jyfw isEqualToString:@""]) {
        cell.shopProductL.text = @"主营:  --";
    }else{
        cell.shopProductL.text = [NSString stringWithFormat:@"主营:%@",modle.jyfw];
    }
    
    if ([modle.m isEqualToString:@""]) {
        cell.shopTelL.text = @"电话:  --";
    }else{
        cell.shopTelL.text = [NSString stringWithFormat:@"电话:%@",modle.m];
    }
    
    if ([modle.w isEqualToString:@""]) {
        cell.shopAddressL.text = @"地址:  --";
    }else{
        cell.shopAddressL.text = [NSString stringWithFormat:@"地址:%@",modle.w];
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 92;
} 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [indexPath row];
    DetailViewController *deView = [[DetailViewController alloc] init];
    deView.hidesBottomBarWhenPushed = YES;
    //取得选中的字典数据,
    DataModle *modle = [dataSourceArr objectAtIndex:index];
    deView.modle = modle;
    [self.navigationController pushViewController:deView animated:YES];
}

#pragma mark scrollview 委托函数
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_tableView.contentOffset.y > 644) {
        reachTop.hidden = NO;//-----显示回到顶部----
    }else{
        reachTop.hidden = YES;//----隐藏回到顶部----
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
