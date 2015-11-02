//
//  SellGoodEditViewController.m
//  单耳兔
//
//  Created by yang on 15/7/6.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//
//商家中心 -> 添加商品/编辑商品
#import "SellGoodEditViewController.h"
#import "UIViewController+HUD.h"
#import "Waiting.h"
#import "AFHTTPRequestOperation.h"
#import "UIView+Toast.h"
#import "AsynImageView.h"

@interface SellGoodEditViewController ()
{
    int addStatusBarHeight;
    AsynImageView *headImgView;
    UITextField *_nameTextField;
    UITextField *_originalPriceTextField;
    UITextField *_currentPriceTextField;
    UITextField *_leftTextField;
    UIButton *_selectButton;
    BOOL hadHeadImg;
    NSMutableDictionary *imgeData;
    UIScrollView *_bgView;
    int itemStart_Y;
    BOOL isShowDetailView;
    BOOL isInEditingMode;
    NSMutableArray *items;
    UIView *detailView;
    UIView *imageBgView;
    UITextView *_textView;
    UILabel *labeltext;
    NSInteger spaceHeight;
    float imageWide;
    BOOL isChooseDetailImage;  //区分选商品图片,详情图片(YES)
    NSMutableArray *detailImageArr;
    NSMutableArray *mixDetailImage;
}
@end

@implementation SellGoodEditViewController
@synthesize editGoodsDic;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    if (self.currentStyle == SellGood_Edity) {
        [self loadData];
    }
}

-(NSString*)getTitle{
    NSString *titleStr = @"";
    if (self.currentStyle == SellGood_Add) {
        titleStr = @"添加商品";
    }else if (self.currentStyle == SellGood_Edity){
        titleStr = @"编辑商品";
    }
    return titleStr;
}

//完成按钮
-(BOOL)isShowFinishButton{
    return YES;
}

//---跳转到搜索
-(void) clickFinish{
     NSLog(@"完成");
    NSString *tempMes = @"";
    if (!hadHeadImg) {
        tempMes = @"请上传商品图片";
    } else if ([_nameTextField.text isEqualToString:@""]) {
        tempMes = @"请输入商品名称";
    } else if ([_originalPriceTextField.text isEqualToString:@""]) {
        tempMes = @"请输入商品价格";
    } else if ([_leftTextField.text isEqualToString:@""]) {
        tempMes = @"请输入商品数量";
    }else if ([_nameTextField.text length] > 20){
        tempMes = @"商品名称不可超过20个字,请重新输入";
    }else if ([_textView.text length] > 400){
        tempMes = @"图片文字介绍不可超过400字";
    }
    if (![tempMes isEqualToString:@""]) {
        [self showHint:tempMes];
        return;
    }
    
    if (self.currentStyle == SellGood_Edity) {
        [self sendEditDataToServer];
    } else if (self.currentStyle == SellGood_Add){
        [self sendAddDataToServer];
    }
}

-(void)onClickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initView{
    
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];
    [self.view setBackgroundColor:[UIColor colorWithRed:232.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
    hadHeadImg = NO;
    isChooseDetailImage = NO;
    itemStart_Y = addStatusBarHeight + TOPNAVIHEIGHT;
    imgeData = [[NSMutableDictionary alloc] init];
    isShowDetailView = NO;
    spaceHeight = self.view.frame.size.height - itemStart_Y;
    
    _bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, itemStart_Y, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT-itemStart_Y)];
    [self.view addSubview:_bgView];
    _bgView.scrollEnabled = NO;
    _bgView.contentSize = CGSizeMake(MAINSCREEN_WIDTH, spaceHeight*2);
    [_bgView setBackgroundColor:[UIColor colorWithRed:232.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
    
    //白色背景
    UIView *topSegmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 100)];
    [_bgView addSubview:topSegmentView];
    [topSegmentView setBackgroundColor:[UIColor whiteColor]];
    
    headImgView = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    [topSegmentView addSubview:headImgView];
    headImgView.contentMode = UIViewContentModeScaleAspectFill;
    headImgView.layer.masksToBounds = YES;
    headImgView.layer.borderWidth = 0;
    headImgView.layer.borderColor = [UIColor clearColor].CGColor;
    headImgView.userInteractionEnabled = YES;
    [headImgView setImage:[UIImage imageNamed:@"sell_add"]];
    [headImgView setBackgroundColor:VIEWBGCOLOR];
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeHeadPhotoAction)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [headImgView addGestureRecognizer:singleTap];
    
    UILabel *headTip = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, 200, 30)];
    [topSegmentView addSubview:headTip];
    [headTip setFont:TEXTFONT];
    [headTip setText:@"(点击上传商品图片)"];
    
    //白色背景
    UIView *nameBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 110, MAINSCREEN_WIDTH, 40)];
    [_bgView addSubview:nameBgView];
    [nameBgView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *nameTip = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 50, 30)];
    [nameBgView addSubview:nameTip];
    [nameTip setFont:TEXTFONT];
    [nameTip setText:@"名称:"];
    [nameTip setTextAlignment:NSTextAlignmentLeft];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 8, 220, 25)];
    [nameBgView addSubview:_nameTextField];
    _nameTextField.font                     = TEXTFONT;
    _nameTextField.placeholder              = @"请输入商品名称";
    _nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _nameTextField.textAlignment            = NSTextAlignmentLeft;
    _nameTextField.delegate                 = self;
    _nameTextField.tag                      = 1;
    
    //白色背景
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 155, MAINSCREEN_WIDTH, 80)];
    [_bgView addSubview:bottomBgView];
    [bottomBgView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *priceTip = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 50, 30)];
    [bottomBgView addSubview:priceTip];
    [priceTip setFont:TEXTFONT];
    [priceTip setText:@"原价:"];
    [priceTip setTextAlignment:NSTextAlignmentLeft];
    
    _originalPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 8, 220, 25)];
    [bottomBgView addSubview:_originalPriceTextField];
    _originalPriceTextField.font                     = TEXTFONT;
    _originalPriceTextField.placeholder              = @"请输入商品原价(元)";
    _originalPriceTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _originalPriceTextField.textAlignment            = NSTextAlignmentLeft;
    _originalPriceTextField.delegate                 = self;
    _originalPriceTextField.tag                      = 2;
    _originalPriceTextField.keyboardType             = UIKeyboardTypeDecimalPad;
    
    //分割线
    UIView *nameLine = [[UIView alloc] initWithFrame:CGRectMake(5, 40, MAINSCREEN_WIDTH-10, 0.6)];
    [bottomBgView addSubview:nameLine];
    [nameLine setBackgroundColor:[UIColor grayColor]];
    
    UILabel *currentPriceTip = [[UILabel alloc] initWithFrame:CGRectMake(5, 45, 50, 30)];
    [bottomBgView addSubview:currentPriceTip];
    [currentPriceTip setFont:TEXTFONT];
    [currentPriceTip setText:@"优惠价:"];
    [currentPriceTip setTextAlignment:NSTextAlignmentLeft];
    
    _currentPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 48, 220, 25)];
    [bottomBgView addSubview:_currentPriceTextField];
    _currentPriceTextField.font                     = TEXTFONT;
    _currentPriceTextField.placeholder              = @"请输入优惠价(元)";
    _currentPriceTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _currentPriceTextField.textAlignment            = NSTextAlignmentLeft;
    _currentPriceTextField.delegate                 = self;
    _currentPriceTextField.tag                      = 3;
    _currentPriceTextField.keyboardType             = UIKeyboardTypeDecimalPad;
    //白色背景
    UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 240, MAINSCREEN_WIDTH, 40)];
    [_bgView addSubview:leftBgView];
    [leftBgView setBackgroundColor:[UIColor whiteColor]];
    
    
    UILabel *leftTip = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 50, 30)];
    [leftBgView addSubview:leftTip];
    [leftTip setFont:TEXTFONT];
    [leftTip setText:@"库存:"];
    [leftTip setTextAlignment:NSTextAlignmentLeft];
    
    _leftTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 8, 220, 25)];
    [leftBgView addSubview:_leftTextField];
    _leftTextField.font                     = TEXTFONT;
    _leftTextField.placeholder              = @"请输入商品库存数量";
    _leftTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _leftTextField.textAlignment            = NSTextAlignmentLeft;
    _leftTextField.delegate                 = self;
    _leftTextField.tag                      = 4;
    _leftTextField.keyboardType     = UIKeyboardTypeDecimalPad;
    
    if (self.currentStyle == SellGood_Add){
        CGFloat labelH = 20;
        CGFloat labelW = 80;
        CGFloat labelX = SCREENWIDTH - 90;
        CGFloat labelY = leftBgView.frame.origin.y + leftBgView.frame.size.height + 20;
        UILabel *sellTipLabel = [[UILabel alloc] init];
        sellTipLabel.frame = CGRectMake(labelX, labelY, labelW, labelH);
        sellTipLabel.backgroundColor = [UIColor clearColor];
        sellTipLabel.textColor = [UIColor redColor];
        sellTipLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        sellTipLabel.text = @"立即上架";
        sellTipLabel.textAlignment = NSTextAlignmentLeft;
        [_bgView addSubview:sellTipLabel];
        
        CGFloat buttonW = 20;
        CGFloat buttonH = 20;
        CGFloat buttonX = SCREENWIDTH - labelW - 20 - buttonW;
        CGFloat buttonY = labelY;
        
        _bgView.userInteractionEnabled = YES;
        _selectButton = [[UIButton alloc] init];
        _selectButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"check_off"] forState:UIControlStateNormal];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"check_on"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _selectButton.selected = YES;
        [_bgView addSubview:_selectButton];
    }
    
    //更多介绍信息
    UIView *detailBtn = [[UIView alloc] initWithFrame:CGRectMake(70, 350, MAINSCREEN_WIDTH-140, 40)];
    [_bgView addSubview:detailBtn];
    detailBtn.userInteractionEnabled = YES;
    detailBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    detailBtn.layer.borderWidth = 0.5;
    detailBtn.layer.cornerRadius = 2;
    
    UITapGestureRecognizer *tapDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addMoreDetailAction)];
    [detailBtn addGestureRecognizer:tapDetail];
    
    UILabel *detailTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 140, 30)];
    [detailBtn addSubview:detailTip];
    detailTip.text = @"补充更多介绍信息";
    detailTip.userInteractionEnabled = YES;
    detailTip.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    detailTip.textColor = [UIColor grayColor];
    detailTip.backgroundColor = [UIColor clearColor];
    
    UIImageView *downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(155, 13, 15, 15)];
    [detailBtn addSubview:downImageView];
    [downImageView setBackgroundColor:[UIColor clearColor]];
    [downImageView setImage:[UIImage imageNamed:@"ic_arrow_down_gray"]];
    
    //点击空白处关闭键盘
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapGes];
    
    [self addDetailView];
//    [detailView setHidden:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)addDetailView{

    isInEditingMode = NO;
    
    detailView = [[UIView alloc] initWithFrame:CGRectMake(0, spaceHeight, MAINSCREEN_WIDTH, spaceHeight)];
    [_bgView addSubview:detailView];
    [detailView setBackgroundColor:[UIColor colorWithRed:232.0/255 green:220.0/255 blue:220.0/255 alpha:1]];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 5, 30)];
    [detailView addSubview:line];
    line.backgroundColor = [UIColor redColor];
    
    UILabel *infolTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 140, 30)];
    [detailView addSubview:infolTip];
    infolTip.backgroundColor =[UIColor clearColor];
    infolTip.text = @"图文介绍";
    infolTip.textColor = [UIColor redColor];
    
    //---评论内容区---
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 40, MAINSCREEN_WIDTH, 80)];
    [detailView   addSubview:contentView];//
    contentView.backgroundColor = [UIColor whiteColor];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, 300, 80)];
    [contentView addSubview:_textView];//
    _textView.delegate = self;
    _textView.font = TEXTFONT;
    _textView.backgroundColor = [UIColor whiteColor];//白色
    
    labeltext = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 280, 20)];
    labeltext.font = TEXTFONT;
    labeltext.backgroundColor = [UIColor clearColor];
    labeltext.text = @"输入产品描述内容(不要超过400字)";
    labeltext.textColor = [UIColor grayColor];//----灰色----
    [_textView addSubview:labeltext];//
    
    
    UILabel *picTip = [[UILabel alloc] initWithFrame:CGRectMake(10, 125, 140, 30)];
    [detailView addSubview:picTip];
    picTip.backgroundColor =[UIColor clearColor];
    picTip.text = @"介绍图片";
    picTip.textColor = [UIColor grayColor];
    
    //--图片区--上限是4张
    imageBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 160, MAINSCREEN_WIDTH, 200)];
    [detailView addSubview:imageBgView];
    imageBgView.userInteractionEnabled = YES;
    [imageBgView setBackgroundColor:[UIColor whiteColor]];
    
    UITapGestureRecognizer *imageBgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageButton)];
    imageBgTap.numberOfTapsRequired = 1;
    imageBgTap.numberOfTouchesRequired = 1;
    [imageBgView addGestureRecognizer:imageBgTap];

    items = [[NSMutableArray alloc] init];
    [items addObject:[DelMenuItem initWithImage:[UIImage imageNamed:@"reduce.png"] imageurl:@"" movable:NO]];
    [items addObject:[DelMenuItem initWithImage:[UIImage imageNamed:@"add.png"] imageurl:@"" movable:NO]];

    detailImageArr = [[NSMutableArray alloc] init];
    [self resetContentView];

    //更多介绍信息
    UIView *detailBtn = [[UIView alloc] initWithFrame:CGRectMake(70, 370, MAINSCREEN_WIDTH-140, 40)];
    [detailView addSubview:detailBtn];
    detailBtn.userInteractionEnabled = YES;
    detailBtn.layer.borderColor = [[UIColor grayColor] CGColor];
    detailBtn.layer.borderWidth = 0.5;
    detailBtn.layer.cornerRadius = 2;
    
    UILabel *detailTip = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 140, 30)];
    [detailBtn addSubview:detailTip];
    detailTip.text = @"收起更多介绍信息";
    detailTip.userInteractionEnabled = YES;
    detailTip.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    detailTip.textColor = [UIColor grayColor];
    detailTip.backgroundColor = [UIColor clearColor];
    
    UIImageView *upImageView = [[UIImageView alloc] initWithFrame:CGRectMake(155, 13, 15, 15)];
    [detailBtn addSubview:upImageView];
    [upImageView setBackgroundColor:[UIColor clearColor]];
    [upImageView setImage:[UIImage imageNamed:@"ic_arrow_up_gray"]];
    
    UITapGestureRecognizer *tapDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMoreDetailAction)];
    [detailBtn addGestureRecognizer:tapDetail];
}

- (void)resetContentView{
    
    //全部移除
    for (DelMenuItem *item in items) {
        [item removeFromSuperview];
    }
    
    int counter = 0; //计数
    int _x = 5;
    int _y = 5;
    imageWide = MAINSCREEN_WIDTH/2-55;//(MAINSCREEN_WIDTH-30)/3;
    for (int i = items.count-1; i < items.count; i--) {
        DelMenuItem *item = [items objectAtIndex:i];
        item.tag = i;
        [item setFrame:CGRectMake(_x+imageWide*(counter%3), _y+(counter/3)*90, imageWide, imageWide)];
        [imageBgView addSubview:item];
        item.delegate = self;
        item.isInEditingMode = NO;
        counter = counter+1;
    }
}


// 编辑模式下,点击空白区域,显示 "+" "-"
- (void)showImageButton{
    if (isInEditingMode) {
        [self disableEditingMode];
        NSArray *tempItem = [NSArray arrayWithArray:items];
        if (items.count > 0) {
            [items removeAllObjects];
        }
        [items addObject:[DelMenuItem initWithImage:[UIImage imageNamed:@"reduce.png"] imageurl:@"" movable:NO]];
        [items addObject:[DelMenuItem initWithImage:[UIImage imageNamed:@"add.png"] imageurl:@"" movable:NO]];
        [items addObjectsFromArray:tempItem];
       
        [self resetContentView];
    }
}

- (void) disableEditingMode {
    // loop thu all the items of the board and disable each's editing mode
    for (DelMenuItem *item in items){
        [item disableEditing];
    }
    isInEditingMode = NO;
    [self resetContentView];
}

- (void)hideImageButton{
    int i = 0;
    do {
        DelMenuItem *menuItem = [items objectAtIndex:0];
        [menuItem removeFromSuperview];
        [items removeObjectAtIndex:0];
        [self resetDelMenuItemTag];
        i ++;
    } while (i == 1);
}

//删除后重新设置tag
- (void)resetDelMenuItemTag{
    //重新设定tag值
    __block int counter = 0; //计数
    for (int i = items.count-1; i >= 0; i--) {
        
        DelMenuItem *item = [items objectAtIndex:i];
        [UIView animateWithDuration:0.2 animations:^{
            [item updateTag:i];
            [item setFrame:CGRectMake(5+imageWide*(counter%3), 5+(counter/3)*90, imageWide, imageWide)];
            counter = counter + 1;
        }];
    }
}

#pragma mark MenuItemDelegate
//删除指定图片
- (void)removeFromSpringboard:(int)index{
    if (self.currentStyle == SellGood_Edity) {
        [mixDetailImage removeObjectAtIndex:index];
    }else{
        [detailImageArr removeObjectAtIndex:index];
    }
    
    NSLog(@"dele:%d",index);
    DelMenuItem *menuItem = [items objectAtIndex:index];
    [menuItem removeFromSuperview];
    [items removeObjectAtIndex:index];

    //只剩一张时要重新显示出 + -
    if (items.count == 0) {
        [self showImageButton];
    }else{
        [self resetDelMenuItemTag];
    }
}

- (void)launch:(int)index{
    if (index == 0) {
        // - 
        if (isInEditingMode || items.count == 2) {
            return;
        }
        //开启编辑模式
        isInEditingMode = YES;
        
        for (DelMenuItem *item in items) {
            [item enableEditing];
        }
        //隐藏 "+" "-"
        [self hideImageButton];
        
    }else if (index == 1){
        // +
        if ([items count] >= 6) {
            [self showHint:@"亲!最多只能上传4张图片"];
            return;
        }
        isChooseDetailImage = YES;
        [self openPhotoActionSheet];
    }else{
        return;
    }
}

- (void) enableEditingMode {
    for (DelMenuItem *item in items)
        [item enableEditing];
    isInEditingMode = YES;
}

//收起更多介绍信息
- (void)closeMoreDetailAction{
    if (isShowDetailView) {
        
        [UIView animateWithDuration:0.8 animations:^{
            [_bgView setContentOffset:CGPointMake(0, 0) animated:YES];
            isShowDetailView = NO;
        }];
    }

}

//打开更多介绍信息
- (void)addMoreDetailAction{
    if (!isShowDetailView) {
        isShowDetailView = YES;
        [UIView animateWithDuration:0.5 animations:^{
            _bgView.contentOffset = CGPointMake(0, spaceHeight);
        }];
    }
}

- (void)selectButtonClick:(UIButton *)button
{
    button.selected = !button.selected;
}

-(void)sendAddDataToServer{
    NSString *imageStr     = [NSString stringWithFormat:@"%@",[imgeData valueForKey:@"fileNameKey"]];
    NSString *nameStr      = [NSString stringWithFormat:@"%@",_nameTextField.text];
    NSString *marketPrice  = [NSString stringWithFormat:@"%@",_originalPriceTextField.text];
    NSString *shopPrice    = [NSString stringWithFormat:@"%@",_currentPriceTextField.text];
    NSString *repertoryStr = [NSString stringWithFormat:@"%@",_leftTextField.text];
    NSString *type         = (_selectButton.selected) ? @"1" : @"0";
    NSString *detailsStr   = [NSString stringWithFormat:@"%@",_textView.text];
    NSMutableString *productImage = [NSMutableString string];
    for (int i = 0; i < detailImageArr.count; i++) {
        if (i == 0) {
            [productImage appendString:[[detailImageArr objectAtIndex:i] valueForKey:@"fileNameKey"]];
        }else{
            [productImage appendString:[NSString stringWithFormat:@",%@",[[detailImageArr objectAtIndex:i] valueForKey:@"fileNameKey"]]];
        }
    }
    
    [Waiting show];
    NSDictionary * params  = @{@"apiid" : @"0233",
                               @"shopid" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"],
                               @"name" : nameStr,
                               @"image" : imageStr,
                               @"shopprice" : shopPrice,
                               @"marketprice" : marketPrice,
                               @"repertoryCount" : repertoryStr,
                               @"type":type,
                               @"pdetails":detailsStr,
                               @"productImglist":productImage};
    
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        NSString *respondStr = operation.responseString;
        NSDictionary *dataDic = [respondStr objectFromJSONString];
        if ([[dataDic valueForKey:@"result"] isEqualToString:@"true"]){
            
            [self sendImageDataToSever];
            [self.view makeToast:@"商品添加成功" duration:1.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"提交数据错误" duration:1.2 position:@"center"];
    }];
    [operation start];

}

-(void)sendEditDataToServer{
    NSString *imageStr     = @"";
    if ([imgeData valueForKey:@"fileNameKey"] && [[imgeData valueForKey:@"fileNameKey"] length] > 0) {
        imageStr = [NSString stringWithFormat:@"%@",[imgeData valueForKey:@"fileNameKey"]];
    }else{
        imageStr = [NSString stringWithFormat:@"%@",[editGoodsDic valueForKey:@"smallImage"]];
    }
    
    NSString *nameStr      = [NSString stringWithFormat:@"%@",_nameTextField.text];
    NSString *marketPrice  = [NSString stringWithFormat:@"%@",_originalPriceTextField.text];
    NSString *shopPrice    = [NSString stringWithFormat:@"%@",_currentPriceTextField.text];
    NSString *repertoryStr = [NSString stringWithFormat:@"%@",_leftTextField.text];
    NSString *guidStr      = [NSString stringWithFormat:@"%@",[editGoodsDic valueForKey:@"guid"]];
    NSString *detailsStr   = [NSString stringWithFormat:@"%@",_textView.text];
    NSMutableString *productImage = [NSMutableString string];
    for (int i = 0; i < mixDetailImage.count; i++) {
        if (i == 0) {
            [productImage appendString:[mixDetailImage objectAtIndex:i]];
        }else{
            [productImage appendString:[NSString stringWithFormat:@",%@",[mixDetailImage objectAtIndex:i]]];
        }
    }
    
    [Waiting show];
    NSDictionary * params  = @{@"apiid" : @"0236",
                               @"guid" : guidStr,
                               @"name" : nameStr,
                               @"image" : imageStr,
                               @"shopprice" : shopPrice,
                               @"marketprice" : marketPrice,
                               @"repertoryCount" : repertoryStr,
                               @"pdetails":detailsStr,
                               @"productImglist":productImage};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        NSString *respondStr = operation.responseString;
        NSDictionary *dataDic = [respondStr objectFromJSONString];
        if ([[dataDic valueForKey:@"result"] isEqualToString:@"true"]){
            
            [self sendImageDataToSever];
            [self.view makeToast:@"商品编辑成功" duration:1.2 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"提交数据错误" duration:1.2 position:@"center"];
    }];
    [operation start];

}

-(void)sendImageDataToSever{
    //有更换图片时才需要上传图片
    if ([imgeData valueForKey:@"dataKey"] && [[imgeData valueForKey:@"dataKey"] length] > 0) {
        [self uploadOneFileData:[imgeData valueForKey:@"dataKey"] imgType:[imgeData valueForKey:@"imageTypeKey"] imgName:[NSString stringWithFormat:@"%@",[imgeData valueForKey:@"fileNameKey" ]]];
    }
    if (detailImageArr.count > 0) {
        for (int i = 0; i < detailImageArr.count; i++) {
            [self uploadOneFileData:[[detailImageArr objectAtIndex:i] valueForKey:@"dataKey"] imgType:[[detailImageArr objectAtIndex:i] valueForKey:@"imageTypeKey"] imgName:[NSString stringWithFormat:@"%@",[[detailImageArr objectAtIndex:i] valueForKey:@"fileNameKey" ]]];
        }
    }else{
        [self performSelector:@selector(onClickBack) withObject:nil afterDelay:1.0f];
        //刷新界面数据
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadGoodsList" object:nil userInfo:nil];
    }
}

-(void)loadData{
    //加载数据
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,[[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"],[editGoodsDic valueForKey:@"smallImage"]];
    if ([[editGoodsDic valueForKey:@"smallImage"] isEqualToString:@""]) {
        imageUrl = @"";
    }else{
        //已存在商品图片
        hadHeadImg = YES;
        headImgView.placeholderImage = [UIImage imageNamed:@"noData2"];
        headImgView.imageURL         = imageUrl;
    }
    
    _nameTextField.text          = [NSString stringWithFormat:@"%@",[editGoodsDic valueForKey:@"productName"]];
    _originalPriceTextField.text = [NSString stringWithFormat:@"%@",[editGoodsDic valueForKey:@"marketPrice"]];
    _currentPriceTextField.text  = [NSString stringWithFormat:@"%@",[editGoodsDic valueForKey:@"shopPrice"]];
    _leftTextField.text          = [NSString stringWithFormat:@"%@",[editGoodsDic valueForKey:@"repertoryCount"]];
    if (![[editGoodsDic valueForKey:@"details"] isEqualToString:@""]) {
        labeltext.hidden = YES;
        _textView.text = [NSString stringWithFormat:@"%@",[editGoodsDic valueForKey:@"details"]];
    }
    
    mixDetailImage = [[NSMutableArray alloc] init];
    if (![[editGoodsDic valueForKey:@"detailsimglist"] isEqualToString:@""]) {
        
        NSString *namestr = [editGoodsDic valueForKey:@"detailsimglist"];
        NSArray *tempArr = [namestr componentsSeparatedByString:@","];

        for (NSString *str in tempArr) {
            NSString *tempUrl = [NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,[[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"],str];
            [mixDetailImage addObject:str];
            [items addObject:[DelMenuItem initWithImage:nil imageurl:tempUrl movable:YES]];
        }
        [self resetContentView];
    }
}

//-----提交上传-----
-(void)uploadOneFileData:(NSData *)woodImgData imgType:(NSString*)typeStr imgName:(NSString *)fileName{
    if (woodImgData) {
        [Waiting show];
        //上传图片文件
        NSString *agentid = [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] objectForKey:@"MemLoginID"];
        //shopType  0:店铺  1:供应商
        NSString *shopType = @"0";
        NSDictionary *params = @{@"agentid":agentid,@"shopType":shopType};
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        //------   http://1.qqupfile.sinaapp.com/Index/upFile
        NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"http://115.28.77.246:8098/AppProductUpload.aspx" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [Waiting show];
            /*
             32          此方法参数
             33          1. 要上传的[二进制数据]
             34          2. 对应网站上[upload.php中]处理文件的[字段"file1"]
             35          3. 要保存在服务器上的[文件名]
             36          4. 上传文件的[mimeType]
             */
            [formData appendPartWithFileData:woodImgData name:@"file1" fileName:fileName mimeType:typeStr];
        }];
        // 3. operation包装的urlconnetion
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];
            NSString *responseString = operation.responseString;
            
            if ([responseString compare:@"Success"] == NSOrderedSame) {
                //图片上传成功
                //发送数据
                [self performSelector:@selector(onClickBack) withObject:nil afterDelay:1.0f];
                //刷新界面数据
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadGoodsList" object:nil userInfo:nil];
            }
            else{
                [self showHint:@"图片上传出错"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];
            [self showHint:REQUESTERRORTIP];
        }];
        [client.operationQueue addOperation:op];
    }
}

//更换头像
-(void)changeHeadPhotoAction{
    isChooseDetailImage = NO;
    [self closeKeyboard];
    [self openPhotoActionSheet];
}

- (void)openPhotoActionSheet{
    if (iOS8) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            //取消
        }];
        
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self takePhoto];
        }];
        
        UIAlertAction *libAction = [UIAlertAction actionWithTitle:@"从手机相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self LocalPhoto];
        }];
        
        // Add the actions.
        [alertController addAction:cameraAction];
        [alertController addAction:libAction];
        [alertController addAction:cancelAction];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else{
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                        initWithTitle:nil
                                        delegate:self
                                        cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles: @"打开照相机", @"从手机相册获取",nil];
        [myActionSheet showInView:[UIApplication sharedApplication].keyWindow];
    }
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == actionSheet.cancelButtonIndex){
        NSLog(@"取消");
    }
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self takePhoto];
            break;
        case 1:  //打开本地相册
            [self LocalPhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate                 = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing            = YES;
        picker.sourceType               = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType               = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate                 = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing            = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark UIImagePickerControllerDelegate
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData *data;
        NSString *imgTypeStr;
        
        NSDate *senddate=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYYMMddhhmmss"];
        NSString *timeStr = [dateformatter stringFromDate:senddate];
        NSString * fileName = nil;
        data = UIImageJPEGRepresentation(image, 0.5);
        imgTypeStr = @"image/jpg";//jpeg和安卓保持一致
        if (isChooseDetailImage) {
            fileName = [NSString stringWithFormat:@"%@detail.jpg",timeStr];
        }else{
            fileName = [NSString stringWithFormat:@"%@.jpg",timeStr];
        }
        NSArray *array = [fileName componentsSeparatedByString:@":"];
        NSMutableString *mutableString = [[NSMutableString alloc] initWithCapacity:0];
        for (NSString *str in array) {
            [mutableString appendString:str];
        }
        if (isChooseDetailImage) {
            
            if (self.currentStyle == SellGood_Edity) {
                [mixDetailImage addObject:mutableString];
            }
            
            [items addObject:[DelMenuItem initWithImage:image imageurl:@"" movable:YES]];
            [self resetContentView];
            
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
            [tempDic setObject:data forKey:@"dataKey"];
            [tempDic setObject:imgTypeStr forKey:@"imageTypeKey"];
            [tempDic setObject:mutableString forKey:@"fileNameKey"];
            [detailImageArr addObject:tempDic];
           
        }else{
            headImgView.image = image;
            hadHeadImg = YES;
            [imgeData setObject:data forKey:@"dataKey"];
            [imgeData setObject:imgTypeStr forKey:@"imageTypeKey"];
            [imgeData setObject:mutableString forKey:@"fileNameKey"];
        }
    
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }];
}


#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    if ([_nameTextField isFirstResponder]) {
        [_originalPriceTextField resignFirstResponder];
    }else if ([_originalPriceTextField isFirstResponder]){
        [_currentPriceTextField resignFirstResponder];
    }else if ([_currentPriceTextField isFirstResponder]){
        [_leftTextField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // i0S6 UITextField的bug
    if (!textField.window.isKeyWindow) {
        [textField.window makeKeyAndVisible];
    }
}

//键盘关闭时触发
-(void)keyboardWillHide{
    if (isShowDetailView) {
        [UIView animateWithDuration:0.5 animations:^{
            _bgView.contentOffset = CGPointMake(0, spaceHeight);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            _bgView.contentOffset = CGPointMake(0, 0);
        }];
    }
}

//关闭键盘
-(void)closeKeyboard{
    if (!isShowDetailView) {
        if ([_nameTextField isFirstResponder]) {
            [_nameTextField resignFirstResponder];
        }else if ([_originalPriceTextField isFirstResponder]){
            [_originalPriceTextField resignFirstResponder];
        }else if ([_leftTextField isFirstResponder]){
            [_leftTextField resignFirstResponder];
        }else if([_currentPriceTextField isFirstResponder]){
            [_currentPriceTextField resignFirstResponder];
        }else if ([_textView isFirstResponder]){
            [_textView resignFirstResponder];
        }
    }
}
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [labeltext removeFromSuperview];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    // i0S6 UITextField的bug
    if (!textView.window.isKeyWindow) {
        [textView.window makeKeyAndVisible];
    }
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.contentOffset = CGPointMake(0, spaceHeight);
    }];
}

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
            if ([text isEqualToString:@""]) {//判断是否为删除键,有可能光标到了字符坐标,此时判断失败
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
