//
//  SellWoodsManageViewController.m
//  单耳兔
//
//  Created by yang on 15/6/30.
//  Copyright (c) 2015年 无锡恩梯梯数据有限公司. All rights reserved.
//
//卖家中心->商品管理

#import "SellWoodsManageViewController.h"
#import "SellGoodCell.h"
#import "SellGoodEditViewController.h"
#import "Tools.h"
#import "Waiting.h"
#import "AFHTTPRequestOperation.h"
#import "UIView+Toast.h"
#import "AsynImageView.h"

@interface SellWoodsManageViewController ()
{
    int addStatusBarHeight;
    int currentClickTag;
    UIView *topSegmentView;
    UIView *noItemView;
    UITableView *_tableView;
    NSMutableArray *dataSourceArr;
    UIImageView *noItemImage;
    UILabel *noItemLabel;
    int clickItemTag;
    NSCache *imageCache;
    int currentClickIndex;
    int currentClickType;
}
@end

@implementation SellWoodsManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGoodsList) name:@"reloadGoodsList" object:nil];
    
    [self initView];
    //0 未上架(待上线) ,1 出售中(已上架)
    clickItemTag = 1;
    [self loadGoodsList];
}

-(NSString*)getTitle
{
    return @"商品管理";
}

-(void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initView{
    
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    [self.view setBackgroundColor:[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1]];
    currentClickTag = 0; //0 出售中商品  1 待上线商品

    dataSourceArr = [[NSMutableArray alloc] init];
    imageCache = [[NSCache alloc] init];
    
    UIButton *topAddBtn = [[UIButton alloc] initWithFrame:CGRectMake(240+10, addStatusBarHeight+7, 60,30)];
    [self.view addSubview:topAddBtn];
    topAddBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [topAddBtn setTitle:@"+添加" forState:UIControlStateNormal];
    [topAddBtn addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    //白色背景
    topSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT, MAINSCREEN_WIDTH, 40)];
    [self.view addSubview:topSegmentView];
    [topSegmentView setBackgroundColor:[UIColor whiteColor]];
    
    NSArray *itemArr = @[@"出售中",@"待上线"];
    int itemCount = (int)itemArr.count;
    
    for (int i = 0; i < itemCount; i++) {
        UILabel *itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * MAINSCREEN_WIDTH / 2.0, 0, MAINSCREEN_WIDTH/2, 40)];
        [topSegmentView addSubview:itemLabel];
        [itemLabel setText:[itemArr objectAtIndex:i]];
        [itemLabel setFont:TEXTFONT];
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
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH / 2.0, 10, 0.8, 20)];
    [topSegmentView addSubview:line];
    [line setBackgroundColor:BORDERCOLOR];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT+50, MAINSCREEN_WIDTH, self.view.frame.size.height - addStatusBarHeight-TOPNAVIHEIGHT-50)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [Tools setExtraCellLineHidden:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    noItemView = [[UIView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight + TOPNAVIHEIGHT + 180, MAINSCREEN_WIDTH, 150)];
    [self.view addSubview:noItemView];
    
    //图片
    noItemImage = [[UIImageView alloc] initWithFrame:CGRectMake(110, 0, 100, 100)];
    [noItemView addSubview:noItemImage];
    
    //文字
    noItemLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 110, 200, 40)];
    [noItemView addSubview:noItemLabel];
    [noItemLabel setBackgroundColor:[UIColor clearColor]];
    [noItemLabel setTextAlignment:NSTextAlignmentCenter];
    [noItemLabel setTextColor:[UIColor grayColor]];
    [self resetNoItemView];
    
    noItemView.hidden = YES;
    
    //滑动手势
    UISwipeGestureRecognizer * recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:recognizer];
    
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:recognizer];
}

-(void)resetNoItemView{
    
    NSString *noItemStr = @"添加商品";
    UIImage *noItemImg  = [UIImage imageNamed:@"sellgood_add"];
    if (currentClickTag == 1) {
        noItemStr       = @"暂无商品";
        noItemImg       = [UIImage imageNamed:@"sellgood_empty"];
    }
    [noItemImage setImage:noItemImg];
    [noItemLabel setText:noItemStr];
}

//获取店铺商品数据
-(void)loadGoodsList{
    NSString *goodsType = [NSString stringWithFormat:@"%d",clickItemTag];
    [Waiting show];
    NSDictionary * params  = @{@"apiid" : @"0230",@"shopid" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"],@"type" : goodsType};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        
        //上次请求有数据时需要先移除
        if ([dataSourceArr count] > 0) {
            [dataSourceArr removeAllObjects];
        }
        NSString *respondStr = [Tools deleteErrorStringInString:operation.responseString];
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[respondStr objectFromJSONString]];
        if ([[[[tempDic valueForKey:@"productList"] valueForKey:@"productBean"] valueForKey:@"result"] objectAtIndex:0] != [NSNull null]) {
            
            [self.view makeToast:[NSString stringWithFormat:@"%@",[[[[tempDic valueForKey:@"productList"] valueForKey:@"productBean"] valueForKey:@"result"] objectAtIndex:0]] duration:1.0 position:@"center"];
            [noItemView setHidden:NO];
            [self resetNoItemView];
        }else{
            [dataSourceArr addObjectsFromArray:[[tempDic valueForKey:@"productList"] valueForKey:@"productBean"]];
            [noItemView setHidden:YES];
        }
        
        [_tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    [operation start];
}

-(void) addButtonAction{
    SellGoodEditViewController *sellGoodEditVC = [[SellGoodEditViewController alloc] init];
    sellGoodEditVC.hidesBottomBarWhenPushed = YES;
    sellGoodEditVC.currentStyle = SellGood_Add;
    [self.navigationController pushViewController:sellGoodEditVC animated:YES];
}

-(void)onClickItem:(id)sender{
    
    int clickTag = (int)[[sender view] tag] - 100;
    [self resetViewWithClickTag:clickTag];
    
}

// 滑动手势
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    NSInteger indexs = currentClickTag;
    switch (recognizer.direction) {
        case UISwipeGestureRecognizerDirectionLeft:
        {
            if (indexs == 1) return;
            [self resetViewWithClickTag:1];
        }
            break;
        default:
        {
            if (indexs == 0) return;
            [self resetViewWithClickTag:0];
        }
            break;
    }
}

-(void)resetViewWithClickTag:(int)clickTag{
    //先移除原来的选中界面
    UILabel *tempItem = [[topSegmentView subviews] objectAtIndex:currentClickTag];
    tempItem.textColor = [UIColor blackColor];
    
    currentClickTag = clickTag;
    [UIView animateWithDuration:0.4 animations:^{
    } completion:^(BOOL finish){
        UILabel *preItem = [[topSegmentView subviews] objectAtIndex:currentClickTag];
        preItem.textColor = [UIColor redColor];
        // typeID = 0 未上架(待上线) ,1 出售中(已上架)
        int typeID = (currentClickTag == 0) ? 1 : 0;
        clickItemTag = typeID;
        [self loadGoodsList];
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataSourceArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIndentifier = @"SellGoodCell";
    SellGoodCell *cell = (SellGoodCell *)[_tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[SellGoodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    int index = (int)[indexPath row];
    NSDictionary *tempDic = [NSDictionary dictionaryWithDictionary:[dataSourceArr objectAtIndex:index]];
    
    cell.editLabel.text = @"编辑";
    cell.editImageView.image = [UIImage imageNamed:@"sellgood_edit"];
    cell.deleteLabel.text = @"删除";
    cell.deleteImageView.image = [UIImage imageNamed:@"sellgood_delete"];
    cell.onLineImageView.image = [UIImage imageNamed:@"sellgood_pin"];
    if (currentClickTag == 0) {
        cell.onLineLabel.text = @"下架";
    }else{
        cell.onLineLabel.text = @"上架";
    }
    
    //商品图片
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,[[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"],[tempDic valueForKey:@"smallImage"]];
    if ([[tempDic valueForKey:@"smallImage"] isEqualToString:@""]) {
         imageUrl = @"";
    }
    NSString *imageKey = [NSString stringWithFormat:@"%@%d",imageUrl,index];
    AsynImageView *image = [imageCache objectForKey:imageKey];
    if (image) {
        cell.goodImage = image;
    }else{
        if ([[tempDic valueForKey:@"smallImage"] isEqualToString:@""]) {
            imageUrl = @"";
        }
        cell.goodImage.imageURL         = imageUrl;
    }
    
    //名称
    cell.goodNameLabel.text         = [NSString stringWithFormat:@"%@",[tempDic valueForKey:@"productName"]];
    cell.oldPriceLabel.text         = [NSString stringWithFormat:@"￥%@",[tempDic valueForKey:@"marketPrice"]];
    cell.currentPriceLabel.text     = [NSString stringWithFormat:@"￥%@",[tempDic valueForKey:@"shopPrice"]];
    //总销量暂时不要
//    cell.totalCountLabel.text       = [NSString stringWithFormat:@"%@",[tempDic valueForKey:@"buyCount"]];
    cell.leftCountLabel.text        = [NSString stringWithFormat:@"%@",[tempDic valueForKey:@"repertoryCount"]];
    
    cell.goodEditBlock              = ^(){
        SellGoodEditViewController *sellGoodEditVC = [[SellGoodEditViewController alloc] init];
        sellGoodEditVC.hidesBottomBarWhenPushed = YES;
        sellGoodEditVC.currentStyle = SellGood_Edity;
        sellGoodEditVC.editGoodsDic = tempDic;
        [self.navigationController pushViewController:sellGoodEditVC animated:YES];
    };
    cell.onOrOffLineBlock           = ^(){
        currentClickIndex = index;
        if (currentClickTag == 0) {
            currentClickType  = 1;
        }else if (currentClickTag == 1){
            currentClickType = 3;
        }
        [self showAlertView];
    };
    cell.deleteBlock                = ^(){
        currentClickIndex = index;
        currentClickType  = 2;
        [self showAlertView];
    };
    
    return cell;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
}

-(void)showAlertView{
    NSString *mes = @"";
    switch (currentClickType) {
        case 1:
            mes = @"确认要下架当前商品吗";
            break;
        case 2:
            mes = @"确认要删除当前商品吗";
            break;
        case 3:
            mes = @"确认要上架当前商品吗";
            break;
        default:
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:mes delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alert show];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            NSLog(@"quxiao");
            break;
        case 1:
            {
                //操作类型:currentClickType = 1 下架, = 2 删除 , = 3 上架
                [Waiting show];
                NSString *guidStr = [NSString stringWithFormat:@"%@",[[NSDictionary dictionaryWithDictionary:[dataSourceArr objectAtIndex:currentClickIndex]] objectForKey:@"guid"]];
                NSString *typeStr = [NSString stringWithFormat:@"%d",currentClickType];
                NSString *tipStr = @"";
                switch (currentClickType) {
                    case 1:
                        tipStr = @"商品下架成功";
                        break;
                    case 2:
                        tipStr = @"商品删除成功";
                        break;
                    case 3:
                        tipStr = @"商品上架成功";
                        break;
                    default:
                        break;
                }
                
                NSDictionary * params  = @{@"apiid" : @"0232",@"guid" : guidStr,@"type" : typeStr};
                NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                                  path:@""
                                                                            parameters:params];
                AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    [Waiting dismiss];
                    NSString *respondStr = operation.responseString;
                    NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[respondStr objectFromJSONString]];
                    if ([[tempDic valueForKey:@"result"] isEqualToString:@"true"]){
                        //删除成功
                        [dataSourceArr removeObjectAtIndex:currentClickIndex];
                        [_tableView reloadData];
                        if (dataSourceArr.count == 0) {
                            [noItemView setHidden:NO];
                            [self resetNoItemView];
                        }
                        [self.view makeToast:tipStr duration:1.2 position:@"center"];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [Waiting dismiss];
                    [self.view makeToast:@"提交数据错误" duration:1.2 position:@"center"];
                }];
                [operation start];
            }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
