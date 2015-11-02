//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "SearchViewController.h"
#import "DataModle.h"
#import "GridViewCell.h"
#import "DetailViewController.h"
#import "SearchShopViewController.h"

@interface SearchViewController (){
    NSMutableArray *arrays;
    NSString *defaultHistoryTypeStr;
    UIScrollView *hotScrollView;
    NSArray *hotItemArray;//热门搜索
    enum searchType currentSearchType;
}
@end

@implementation SearchViewController
@synthesize cachedImage;
@synthesize keyWord;
@synthesize distanceParameter;
@synthesize segment1;
@synthesize segment2;
@synthesize segment3;
@synthesize item2AreaLb;
@synthesize item3AreaLb;
@synthesize item3Area_delete;
@synthesize item3Area_list;
@synthesize scrollView;

@synthesize defaults;
@synthesize scrollViewStartY;
@synthesize hotItemIndex,distanceItemIndex,historyItemIndex;
@synthesize segmentBlock1;
@synthesize segmentBlock2;


@synthesize topNaviClassifyText;
@synthesize classifyView;
@synthesize classifyArr;
@synthesize searchText;
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [searchText becomeFirstResponder];
}

- (void)viewDidLoad
{
    //searchItemIndex = [NSArray arrayWithObjects:@"-1",@"-1",@"-1", nil];
    hotItemIndex = distanceItemIndex = historyItemIndex = -1;//初始化
    defaults =[NSUserDefaults standardUserDefaults];//读取本地化存储
    arrays = [[NSMutableArray alloc] init];//初始化
    hotItemArray = [[NSArray alloc] init];
    
    //[self.navigationController.tabBarItem setBadgeValue:@"11"];//设置badge
    
    [super viewDidLoad];
    
    self.view.backgroundColor = VIEWBGCOLOR;
    currentSearchType = SEARCHSHOP;
    
    [self loadData];
    
}

- (void)initView{
    
    int addStatusBarHeight = STATUSBAR_HEIGHT;
    
    //返回图标
    UIButton *goBack = [[UIButton alloc] initWithFrame:CGRectMake(10, 2+addStatusBarHeight, 53.5, 40)];
    [self.view addSubview:goBack];
    [goBack setBackgroundImage:[UIImage imageNamed:@"gobackBtn"] forState:UIControlStateNormal];
    [goBack addTarget:self action:@selector(onClickBack) forControlEvents:UIControlEventTouchUpInside];
    
    //分类,可以点击
    UIView *classifyBlock = [[UIView alloc] initWithFrame:CGRectMake(65, 0+addStatusBarHeight, 50, TOPNAVIHEIGHT)];
    [self.view addSubview:classifyBlock];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showClassify)];
    [classifyBlock addGestureRecognizer:singleTap];//添加大图片点击事件
    
    //文字
    topNaviClassifyText = [[UILabel alloc] initWithFrame:CGRectMake(0, 12, 40, 25)];
    [classifyBlock addSubview:topNaviClassifyText];
    topNaviClassifyText.backgroundColor = [UIColor clearColor];
    topNaviClassifyText.text = @"店铺";
    topNaviClassifyText.font = [UIFont systemFontOfSize:18];
    topNaviClassifyText.textColor = [UIColor whiteColor];
    topNaviClassifyText.userInteractionEnabled = YES;//这样才可以点击
    [topNaviClassifyText setNumberOfLines:1];
    [topNaviClassifyText sizeToFit];//自适应
    defaultHistoryTypeStr = @"searchHistory";
    
    CGRect frame = topNaviClassifyText.frame;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width, 20, 10, 10)];
    [classifyBlock addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"classifyTopImg"];
    
    //搜索
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(115, 7+addStatusBarHeight, 200, 30)];
    [self.view addSubview:searchView];
    searchView.userInteractionEnabled = YES;
    searchView.backgroundColor = [UIColor whiteColor];
    [searchView.layer setMasksToBounds:YES];
    [searchView.layer setCornerRadius:15.0];//设置矩形四个圆角半径
    UITapGestureRecognizer *tapInput =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickInput)];
    [searchView addGestureRecognizer:tapInput];//---添加点击事件
    //搜索图标
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    [searchView addSubview:searchIcon];
    searchIcon.backgroundColor = [UIColor clearColor];
    searchIcon.image = [UIImage imageNamed:@"magnifying"];
    //索搜文字
    searchText = [[UITextField alloc] initWithFrame:CGRectMake(33, 1, 170, 30)];
    [searchView addSubview:searchText];
    searchText.keyboardType = UIKeyboardTypeDefault;
    searchText.backgroundColor = [UIColor whiteColor];
    searchText.font = TEXTFONT;
    searchText.delegate = self;
    searchText.placeholder = @"店铺名称关键字";
    searchText.returnKeyType = UIReturnKeySearch;
    searchText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //分类下啦;
    classifyArr = @[@"店铺",@"商品",@"searchShopIcon",@"searchWoodsIcon",@"店铺名称关键字",@"商品名称关键字"];
    NSInteger count = [classifyArr count] / 3;
    int itemH = 40;
    classifyView = [[UIView alloc] initWithFrame:CGRectMake(65, 0+addStatusBarHeight+TOPNAVIHEIGHT, 80, itemH*count)];
    [self.view addSubview:classifyView];
    classifyView.hidden = YES;
    classifyView.userInteractionEnabled = YES;//这样才可以点击
    classifyView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.8];
    for (int i=0;i<count;i++) {
        UIView *item = [[UIView alloc] initWithFrame:CGRectMake(0, itemH*i, 80, itemH)];
        [classifyView addSubview:item];
        item.tag = 100+i;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectClassify:)];
        [item addGestureRecognizer:singleTap];//---添加大图片点击事件
        //图片
        UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
        [item addSubview:searchIcon];
        searchIcon.backgroundColor = [UIColor clearColor];
        searchIcon.image = [UIImage imageNamed:classifyArr[i+count]];
        //文字
        UILabel *itemText = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 50, itemH)];
        [item addSubview:itemText];
        itemText.text = classifyArr[i];
        itemText.backgroundColor = [UIColor clearColor];
        itemText.textColor = [UIColor whiteColor];
        itemText.textAlignment = NSTextAlignmentCenter;
        if (i<count-1) {
            UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(0,itemH-1, 80, 1)];
            [item addSubview:border];
            border.backgroundColor = BORDERCOLOR;
        }
    }
    
    //上半部分
    NSInteger itemLines = [hotItemArray count]%4>0 ? 1 : 0;
    itemLines = [hotItemArray count]/4 + itemLines;
    
    NSInteger hotScrollView_y = itemLines*40;
    
    UILabel *hotSearchLb = [[UILabel alloc] initWithFrame:CGRectMake(10, addStatusBarHeight+TOPNAVIHEIGHT, 50, 30)];//上半部分
    [self.view addSubview:hotSearchLb];
    hotSearchLb.backgroundColor = [UIColor clearColor];
    hotSearchLb.textColor = [UIColor grayColor];
    hotSearchLb.text = @"热搜:";
    
    //----热门搜索
    hotScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT+30, MAINSCREEN_WIDTH, hotScrollView_y)];
    [self.view insertSubview:hotScrollView belowSubview:classifyView];
    hotScrollView.backgroundColor = [UIColor whiteColor];
    hotScrollView.userInteractionEnabled = YES;
    hotScrollView.contentSize = CGSizeMake( 65*HOT_ITEM_COUNT+SCROLL_CONTENT_GAP, 30);
    hotScrollView.showsHorizontalScrollIndicator = NO;
    for (int i=0; i<hotItemArray.count; i++) {
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(75*(i%4)+10, 35*(i/4)+8, 60, 30)];
        [hotScrollView addSubview:item];
        item.tag = i;
        
        item.layer.cornerRadius = 5;
        item.layer.borderColor = [UIColor grayColor].CGColor;
        item.layer.borderWidth = 0.6;
        
        item.titleLabel.font = TEXTFONT;
        [item setTitle:hotItemArray[i] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [item setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [item addTarget:self action:@selector(goToSearchByHotItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    scrollViewStartY = hotScrollView_y+30+addStatusBarHeight+TOPNAVIHEIGHT;// 50+44+addStatusBarHeight+10;
    //历史搜索,标题----
    UILabel *historyTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, scrollViewStartY, MAINSCREEN_WIDTH, 30)];//上半部分
    [self.view insertSubview:historyTitle belowSubview:classifyView];
    [historyTitle setBackgroundColor:[UIColor clearColor]];
    historyTitle.textColor = [UIColor grayColor];
    [historyTitle drawTextInRect:CGRectMake(10, 0, 310, 30)];
    historyTitle.text = @"最近搜索:";
    //搜索记录
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scrollViewStartY+30, MAINSCREEN_WIDTH, self.view.frame.size.height-scrollViewStartY-30)];//上半部分
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(280, self.view.frame.size.height-scrollViewStartY-30);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.userInteractionEnabled = YES;
    [self.view insertSubview:scrollView belowSubview:classifyView];
    
    //----搜索记录
    NSArray *searchHistory = [defaults objectForKey:defaultHistoryTypeStr];
    int historyItemHeight = 35;
    item3AreaLb = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, historyItemHeight*(searchHistory.count+1)+10)];
    item3AreaLb.userInteractionEnabled = YES;
    [scrollView addSubview:item3AreaLb];
    
    //----记录
    item3Area_list =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, historyItemHeight*searchHistory.count)];
    item3Area_list.userInteractionEnabled = YES;
    [item3AreaLb addSubview:item3Area_list];
    
    //----清空搜索记录按钮
    item3Area_delete = [[UIButton alloc] initWithFrame:CGRectMake(40, historyItemHeight*searchHistory.count+10, 240, historyItemHeight)];
    [item3AreaLb addSubview:item3Area_delete];
    [item3Area_delete setTitle:@"清空搜索记录" forState:UIControlStateNormal];
    [item3Area_delete setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [item3Area_delete setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [item3Area_delete setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [item3Area_delete setBackgroundColor:[UIColor whiteColor]];
    item3Area_delete.layer.cornerRadius = 5;
    item3Area_delete.layer.borderWidth = 0.6;
    item3Area_delete.layer.borderColor = BORDERCOLOR.CGColor;
    [item3Area_delete addTarget:self action:@selector(onClickDelete) forControlEvents:UIControlEventTouchUpInside];
    [self reCreateSearHistory];
}

- (void)loadData{
    [Waiting show];
    //获取搜索关键字
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"0158",@"apiid", nil];
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];//隐藏loading
        NSString *respondStr = [Tools deleteErrorStringInString:operation.responseString];
        hotItemArray = [[Tools replaceUnicode:respondStr] componentsSeparatedByString:@","];
        
        [self initView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    [operation start];
}

//-----取消输入
- (void)cancleInput{
    [searchText resignFirstResponder];
}
//-----输入文字
- (void)clickInput{
    [searchText becomeFirstResponder];
}

#pragma mark UITextFieldDelegate
//-----这里是按下搜索键,索搜-----
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"fejoiregkoppth");
    if(searchText.text.length>0){
        [searchText resignFirstResponder];//隐藏键盘
        //添加搜索记录
        NSMutableArray* tempArray = [defaults objectForKey:defaultHistoryTypeStr];
        NSMutableArray* searchHistory = [[NSMutableArray alloc]init];
        if(tempArray.count>0){
            searchHistory = [tempArray mutableCopy];
        }
        //--遍历删除重复
        for (id temp in searchHistory) {
            if ([temp isEqualToString:searchText.text]) {
                [searchHistory removeObject:temp];
                break;
            }
        }
        [searchHistory addObject:searchText.text];
        NSArray *temp = [searchHistory mutableCopy];
        [defaults setObject:temp forKey:defaultHistoryTypeStr];
        [self reCreateSearHistory];
        //搜索
        keyWord = searchText.text;
        distanceParameter = @"";
        [self goToSearch];//搜所
        //清空输入框
        searchText.text = nil;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // i0S6 UITextField的bug
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
}

//-----展示分类----
-(void)showClassify{
    classifyView.hidden = !classifyView.hidden;
}
//-----选择其他分类
-(void)selectClassify:(id)sender{
    NSString *preType = topNaviClassifyText.text;
    NSInteger tag = [[sender view] tag] - 100;
    classifyView.hidden = YES;
    //当前搜索类型
    topNaviClassifyText.text = classifyArr[tag];
    searchText.placeholder = classifyArr[tag+4];
    if (tag == 0) {
        defaultHistoryTypeStr = @"searchHistory";
        currentSearchType = SEARCHSHOP;
    }else if(tag==1){
        currentSearchType = SEARCHWOOD;
        defaultHistoryTypeStr = @"searchHistoryWoods";
    }
    //----调整文字,小标大小------
    [topNaviClassifyText sizeToFit];
    CGRect frame = topNaviClassifyText.frame;
    UIImageView *imgView = [[[topNaviClassifyText superview] subviews] objectAtIndex:1];
    imgView.frame = CGRectMake(frame.size.width, 20, 10, 10);
    //搜索分类有改变
    if (![preType isEqualToString:classifyArr[tag]]) {
        [self reCreateSearHistory];
    }
}
//-----点击返回
-(void)onClickBack
{
    [self.navigationController popViewControllerAnimated:YES];
}
//---点击热门搜索
-(void) goToSearchByHotItem:(UIButton *)sender{
    NSInteger index = [sender tag];
    if (currentSearchType==SEARCHSHOP) {
        //店铺热搜
        keyWord = hotItemArray[index];
        distanceParameter = @"";
    }
    else if (currentSearchType==SEARCHWOOD){
        //商品热搜
        keyWord = hotItemArray[index];
    }
    
    [self goToSearch];
}
//---清空搜索记录
-(void) onClickDelete{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"确定要清空搜索记录吗"] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    [alert addButtonWithTitle:@"清空"];
    [alert setTag:1];
    [alert show];
}

//----------确定清空
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] ==1 ) {
        if(buttonIndex==1){
            //删除  之前的  item  [[item2Area_list subviews]];
            for (id tmpView in [item3Area_list subviews] ) {
                [tmpView removeFromSuperview];
            }
            item3Area_delete.frame = CGRectMake(40, 10, 240, 35);//调整位置
            scrollView.frame = CGRectMake(0, scrollViewStartY+30, MAINSCREEN_WIDTH, 50);
            scrollView.contentSize = CGSizeMake( MAINSCREEN_WIDTH, 35+SCROLL_CONTENT_GAP);
            [defaults removeObjectForKey:defaultHistoryTypeStr];
        }
    }
}
//--搜索记录,重新绘制
- (void)reCreateSearHistory
{
    NSArray *searchHistory = [defaults objectForKey:defaultHistoryTypeStr];
    int historyItemHeight = 35;
    int historyItemCount = (int)searchHistory.count;
    if ([item3Area_list subviews].count > 0) {
        for (id tmpView in [item3Area_list subviews] ) {
            [tmpView removeFromSuperview];
        }
    }
    int height = historyItemHeight*(historyItemCount+1)+20;
    if (height>self.view.frame.size.height - scrollViewStartY-30) {
        height = self.view.frame.size.height - scrollViewStartY-30;
    }
    scrollView.frame = CGRectMake(0, scrollViewStartY + 30, MAINSCREEN_WIDTH, height);
    scrollView.contentSize = CGSizeMake(280 ,historyItemHeight * (historyItemCount + 1) + SCROLL_CONTENT_GAP);
    
    item3AreaLb.frame = CGRectMake(0, 0, 280, historyItemHeight*(historyItemCount + 1));
    item3Area_list.frame = CGRectMake(0, 0, 280, historyItemHeight*historyItemCount);
    
    for (int i=0; i<historyItemCount; i++) {
        UIButton *item = [[UIButton alloc] initWithFrame:CGRectMake(10, historyItemHeight * i, 300, historyItemHeight)];
        item.userInteractionEnabled = YES;
        [item3Area_list addSubview:item];
        
        UILabel *border = [[UILabel alloc] initWithFrame:CGRectMake(0, historyItemHeight - 1, 300, 1)];
        border.backgroundColor = BORDERCOLOR;
        [item addSubview:border];
        item.tag = historyItemCount - 1 - i;
        
        [item setTitle:searchHistory[historyItemCount - 1 - i] forState:UIControlStateNormal];
        item.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        item.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
        [item setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [item setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
        [item setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [item addTarget:self action:@selector(goToSearchByHistoryItem:) forControlEvents:UIControlEventTouchUpInside];
    }
    item3Area_delete.frame = CGRectMake(40, historyItemHeight*historyItemCount+10, 240, historyItemHeight);//调整位置
}
//---点击历史记录搜索
-(void) goToSearchByHistoryItem:(UIButton *)sender{
    int index = (int)[sender tag];
    NSMutableArray* temp = [defaults objectForKey:defaultHistoryTypeStr];
    keyWord = temp[index];
    distanceParameter = @"";
    NSMutableArray* tempArray = [temp mutableCopy];
    [tempArray removeObjectAtIndex:index];
    [tempArray addObject:keyWord];//调整到数组最后一个,,数组遍历时是倒序
    [defaults setObject:tempArray forKey:defaultHistoryTypeStr];
    [self reCreateSearHistory];//重构记录列表
    [self goToSearch];
}
//-----执行搜索
- (void)goToSearch{
    //搜店铺
    if (currentSearchType == SEARCHSHOP) {
        
        SearchShopViewController *searchShopVC = [[SearchShopViewController alloc] init];
        searchShopVC.keyWord = keyWord;
        searchShopVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:searchShopVC animated:YES];
        
//        ShopDataController *shopController = [[ShopDataController alloc] init];
//        shopController.isFromShopSearch = YES;
//        shopController.keyWord = keyWord;
//        shopController.distanceParameter = distanceParameter;
//        shopController.isDataByClassifyType = NO;
//        shopController.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:shopController animated:YES];
    }else if (currentSearchType==SEARCHWOOD){
    //搜商品
        
        WoodDataController *woodController = [[WoodDataController alloc] init];
        woodController.searchKeyWord = keyWord;
        woodController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:woodController animated:YES];
    }
}
@end
