//
//  WebViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-6.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
#import "ShopCommentController.h"
#define MAXIMGNUM 6
@implementation ShopCommentController{
    UILabel *starTextLb ;
    NSMutableArray *photoImageArr;//展示的图片的数组
    NSMutableArray *imgDataForUploadArr;//上传的图片数据数组
    UIButton *addPhotoBtn;//添加图片视图点击按钮
    AFHTTPClient *httpClient;
    NSInteger starLevel;//评星
    NSString *isCommentAnonymity;//匿名评论
    NSArray *commentTextArr;
    UIView *photoView;
    bool isContentEdited;//----内容是否编辑过----
}
@synthesize addStatusBarHeight;
@synthesize backHomeIcon;
@synthesize refreshIcon;
@synthesize webView;
@synthesize activityIndicator;
@synthesize webURL;
@synthesize webTitle;
@synthesize _textView;
@synthesize tapRateView;
@synthesize defaults;
@synthesize labeltext;
@synthesize shopInfoDic;
- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    addStatusBarHeight = [TopNaviViewController getStatusBarHeight];//--默认是0 ,ios6
    defaults =[NSUserDefaults standardUserDefaults];
    httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
    isCommentAnonymity = @"0";
    isContentEdited = NO;
    imgDataForUploadArr = [[NSMutableArray alloc] initWithCapacity:MAXIMGNUM];//最多上传6个
    commentTextArr = @[@"很差,来了就是吃亏上当",@"不太好,明显低于平均水平呢",@"一般般,和普通店家区别不大",@"还不错哟,值得下次再来",@"非常棒,值得向所有人推荐"];
    UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, addStatusBarHeight+TOPNAVIHEIGHT, MAINSCREEN_WIDTH, CONTENTHEIGHT+49)];
    [self.view addSubview:scrollV];
    scrollV.backgroundColor = VIEWBGCOLOR;
    NSLog(@"fjeopwfpwkfpwfkow---------%@----%@",shopInfoDic,isCommentAnonymity);
    
    //---店铺信息----
    UIView *shopInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 100)];
    [scrollV   addSubview:shopInfoView];//
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
    [shopInfoView addSubview:imgV];
    imgV.layer.borderColor = [UIColor grayColor].CGColor;
    imgV.layer.borderWidth = 0.5;
    NSString *imgName = [shopInfoDic objectForKey:@"EntityImage"];
    if ([imgName length]>3) {
        NSURL *realUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%@",MEMBERPRODUCT,[shopInfoDic objectForKey:@"m"],imgName]];
        [imgV sd_setImageWithURL:realUrl];
    }else{
        [imgV setImage:[UIImage imageNamed:@"onesui.jpg"]];
    }
    UILabel *shopNameLb = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 30)];
    [shopInfoView addSubview:shopNameLb];
    shopNameLb.backgroundColor = [UIColor clearColor];
    shopNameLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    shopNameLb.text = [shopInfoDic objectForKey:@"ShopName"];

    //-------边-------
    UILabel *borderLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 99, MAINSCREEN_WIDTH, 1)];
    [shopInfoView addSubview:borderLb];
    borderLb.backgroundColor = BORDERCOLOR;
    
    //-----总体评价----
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, shopInfoView.frame.size.height, MAINSCREEN_WIDTH, 80)];
    [scrollV    addSubview:commentView];
    commentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *textLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 80, 30)];
    [commentView addSubview:textLb];
    textLb.backgroundColor = [UIColor clearColor];
    textLb.textAlignment = NSTextAlignmentCenter;
    textLb.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    textLb.text = @"总体评价";
    
    //---评星级区域---
    /*
    tapRateView = [[RSTapRateView alloc] initWithFrame:CGRectMake(80, 0, 240, 60)];
    tapRateView.delegate = self;
    [commentView addSubview:tapRateView];
    */
    
    UIView *starView = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 200, 40)];
    [commentView addSubview:starView];
    int startWidth = 40;
    for (int i=0;i<5;i++) {
        UIButton *starBtn = [[UIButton alloc] initWithFrame:CGRectMake(i*startWidth, 0, startWidth, startWidth)];
        [starView addSubview:starBtn];
        [starBtn setImage:[UIImage imageNamed:@"starYellow"] forState:UIControlStateNormal];
        [starBtn setImage:[UIImage imageNamed:@"starGray"] forState:UIControlStateHighlighted];
        [starBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        starBtn.tag = 100+i;
        
        [starBtn addTarget:self action:@selector(tapStar:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    starLevel = commentTextArr.count;//-----默认最高星,,五星------
    starTextLb = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 240, 40)];
    [commentView addSubview:starTextLb];
    starTextLb.font = TEXTFONT;
    starTextLb.textColor = [UIColor grayColor];
    starTextLb.textAlignment = NSTextAlignmentCenter;
    starTextLb.text = commentTextArr[commentTextArr.count-1];
    
    UILabel *borderLb_1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, MAINSCREEN_WIDTH, 1)];
    [commentView addSubview:borderLb_1];
    borderLb_1.backgroundColor = BORDERCOLOR;
    
    //---评论内容区---
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, shopInfoView.frame.size.height+commentView.frame.size.height, MAINSCREEN_WIDTH, 80)];
    [scrollV   addSubview:contentView];//
    contentView.backgroundColor = [UIColor whiteColor];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 60)];
    [contentView addSubview:_textView];//
    _textView.delegate = self;
    _textView.font = TEXTFONT;
    //textView.placeholder = @"点击进行评语编辑，最少评论15字，最多不超多300字，您的评价将是其他用户的重要参考。）";

    _textView.backgroundColor = [UIColor whiteColor];//白色
    
    labeltext = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 280, 50)];
    labeltext.font = TEXTFONT;
    labeltext.numberOfLines = 3;
    labeltext.backgroundColor = [UIColor clearColor];
    labeltext.text = @"(点击进行评语编辑，最少评论15字，最多不超多300字，您的评价将是其他用户的重要参考。）";
    labeltext.textColor = [UIColor grayColor];//----灰色----
    [_textView addSubview:labeltext];//

    
    UILabel *borderLb_2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 79, MAINSCREEN_WIDTH, 1)];
    [contentView addSubview:borderLb_2];
    borderLb_2.backgroundColor = BORDERCOLOR;
    
    //-----添加评论图片---
    photoView = [[UIView alloc] initWithFrame:CGRectMake(0, shopInfoView.frame.size.height+commentView.frame.size.height+contentView.frame.size.height, MAINSCREEN_WIDTH, 160)];
    [scrollV   addSubview:photoView];//
    photoView.backgroundColor = [UIColor whiteColor];
    
    addPhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
    [photoView addSubview:addPhotoBtn];
    addPhotoBtn.layer.borderColor = [UIColor grayColor].CGColor;
    addPhotoBtn.layer.borderWidth = 1;
    addPhotoBtn.layer.cornerRadius = 3;
    UIImage *photoImg = [UIImage imageNamed:@"xiangji.png" ];
    photoImageArr = [[NSMutableArray alloc] initWithArray:@[addPhotoBtn]];
    
    [addPhotoBtn setImage:photoImg forState:UIControlStateNormal];
    [addPhotoBtn addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    
    
    //---------边-----
    UILabel *borderLb_3 = [[UILabel alloc] initWithFrame:CGRectMake(0, photoView.frame.size.height-1, MAINSCREEN_WIDTH, 1)];
    [photoView addSubview:borderLb_3];
    borderLb_3.tag = 1000;//----特殊标记----
    borderLb_3.backgroundColor = BORDERCOLOR;
    
    int spaceHeight = 20;
    //-----匿名评论----
    UIView *additionalView = [[UIView alloc] initWithFrame:CGRectMake(0, shopInfoView.frame.size.height+commentView.frame.size.height+contentView.frame.size.height+photoView.frame.size.height+spaceHeight, MAINSCREEN_WIDTH, 60)];
    [scrollV   addSubview:additionalView];//
    additionalView.backgroundColor = [UIColor whiteColor];
    
    UILabel *textLb_addtion = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 80, 20)];
    [additionalView addSubview:textLb_addtion];
    textLb_addtion.textColor = [UIColor grayColor];
    textLb_addtion.text = @"匿名评价";
    
    UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(220, 10, 40, 20)];
    [switchButton setOn:NO];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [additionalView addSubview:switchButton];
    //--------滑动区域-----
    scrollV.contentSize = CGSizeMake(MAINSCREEN_WIDTH, shopInfoView.frame.size.height+commentView.frame.size.height+contentView.frame.size.height+photoView.frame.size.height+spaceHeight+60);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    //点击空白处关闭键盘
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    [scrollV addGestureRecognizer:tapGes];
    
}
//------评分-----
-(void)tapStar:(UIButton *)btn{
    NSInteger tag = btn.tag - 100;
    if (starLevel!=tag + 1) {
        isContentEdited = YES;
        if (starLevel>tag + 1) {
            //-----黄变灰
            for (NSInteger i=tag+1; i<starLevel; i++) {
                UIButton *starBtn = (UIButton *)[[btn superview] viewWithTag:i+100];
                [starBtn setImage:[UIImage imageNamed:@"starGray"] forState:UIControlStateNormal];
                [starBtn setImage:[UIImage imageNamed:@"starYellow"] forState:UIControlStateHighlighted];
            }
        }else{
            for (NSInteger i=starLevel; i<tag+1; i++) {
                UIButton *starBtn = (UIButton *)[[btn superview] viewWithTag:i+100];
                [starBtn setImage:[UIImage imageNamed:@"starYellow"] forState:UIControlStateNormal];
                [starBtn setImage:[UIImage imageNamed:@"starGray"] forState:UIControlStateHighlighted];
            }
        }
        starLevel = tag + 1;
        starTextLb.text = commentTextArr[tag];
    }
}

//------切换-----
-(void)switchAction:(UISwitch *)btn{
    if (btn.isOn) {
        isCommentAnonymity = @"1";
    }else{
        isCommentAnonymity = @"0";
    }
    isContentEdited = YES;
}
-(NSString*)getTitle{
    return @"评价";
}
//-----完成按钮标题
-(NSString*)getFinishBtnTitle{
    return @"发布";
}
//-----完成按钮
-(BOOL)isShowFinishButton{
    return YES;
}
//---点击发布评论-----
-(void) clickFinish{
    NSLog(@"fjaofjeijgiorjgr");
    NSDictionary  *userLoginInfo = [defaults objectForKey:@"userLoginInfo"];
    NSString *memberId = @"";
    if (userLoginInfo) {
        if (_textView.text.length<15) {
            [self.view makeToast:@"评论至少15字" duration:1.2 position:@"center"];
        }else if (_textView.text.length>300){
            [self.view makeToast:@"评论不能超过300字" duration:1.2 position:@"center"];
        }else{
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSMutableArray *fileNameArr = [[NSMutableArray alloc] initWithCapacity:MAXIMGNUM];
            int q = arc4random()%10,w = arc4random()%10,e = arc4random()%10;
            int imgCount = (int)imgDataForUploadArr.count;
            for (int i=0;i+1<imgCount;i++) {
                if (i%2==0) {
                    NSString *imgType = imgDataForUploadArr[i+1];
                    NSString *fileName = [NSString stringWithFormat:@"%@%d%d%d%d.%@",str,q,w,e,i/2,imgType];
                    //-----图片名称数组-----
                    [fileNameArr addObject:fileName];
                    NSData *imgData = imgDataForUploadArr[i];
                    //-----上传图片-----
                    [self uploadOneFileData:imgData imgType:imgType imgName:fileName];
                }
            }
            //-----上传其他评论数据------
            NSString *imgUrlStr = @"";
            if (fileNameArr.count>0) {
                imgUrlStr = fileNameArr[0];
                for (NSString *item in fileNameArr) {
                    imgUrlStr = [imgUrlStr stringByAppendingString:@","];
                    imgUrlStr = [imgUrlStr stringByAppendingString:item];
                }
            }
            memberId = [userLoginInfo objectForKey:@"MemLoginID"];//----登录手机号-------
            NSDictionary * params = @{@"apiid": @"0101",@"shopid" :[shopInfoDic objectForKey:@"ShopId"],@"memberid": memberId,@"xinglevel": [NSString stringWithFormat:@"%ld",(long)starLevel],@"info": _textView.text,@"imgstr":imgUrlStr,@"isanonymity":isCommentAnonymity};
            NSLog(@"urdsadadadfdfewioutolocationString---------:%@--",params);
            NSURLRequest * request = [httpClient requestWithMethod:@"POST"
                                                          path:@""
                                                    parameters:params];
            AFHTTPRequestOperation * operation = [httpClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSString *source = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                if ([source isEqualToString:@"true"]) {
                    [self.view makeToast:@"评价成功" duration:1.2 position:@"center"];
                    [self performSelector:@selector(goBack) withObject:nil afterDelay:1.0f];
                }
                NSLog(@"------------weqqfasdfeawf--%@---%@",shopInfoDic,source);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"faild , error == %@ ", error);
                [self.view makeToast:@"提交数据错误" duration:1.2 position:@"center"];
                [Waiting dismiss];
            }];
            [operation start];//-----发起请求------
        }
    }else{
        [self.view makeToast:@"请到个人中心登录才能评论" duration:1.2 position:@"center"];
    }
}
//--返回--
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)onClickBack{
    if (isContentEdited) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"正在编辑的内容还没有提交,返回就丢失已编辑的内容" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert addButtonWithTitle:@"返回"];
        [alert setTag:12];
        [alert show];
    }else{
        [self goBack];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] ==12 ) {    // it's the Error alert
        if(buttonIndex==1){
            [self goBack];
        }
    }
}

//关闭键盘
-(void)closeKeyboard{
    if ([_textView isFirstResponder]) {
        [_textView resignFirstResponder];
    }
}

//键盘关闭时触发
-(void)keyboardWillHide{
    [UIView animateWithDuration:0.5 animations:^{
        [self.view  setFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
    }];
}

//-----textview-----placeholder-----
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
        [self.view setFrame:CGRectMake(0, -60, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
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
    isContentEdited = YES;
    NSLog(@"weqrqrqqewqr--------%@--%@",_textView.text,text);
    return YES;
}
#pragma mark RSTapRateViewDelegate
- (void)tapDidRateView:(RSTapRateView*)view rating:(NSInteger)rating {
    NSLog(@"Current rating: %ld", rating);
    starLevel = rating;
    starTextLb.text = commentTextArr[rating-1];
}
-(void)openCamera
{
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
    }}
//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
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
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        image = [self OriginImage:image scaleToSquareWidth:300];
        NSData *data;
        NSString *imgTypeStr;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
            imgTypeStr = @"jpg";
        }
        else
        {
            data = UIImagePNGRepresentation(image);
            imgTypeStr = @"png";
        }
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:[NSString stringWithFormat: @"/shopCommentImg.%@",imgTypeStr]] contents:data attributes:nil];
        NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  [NSString stringWithFormat: @"/shopCommentImg.%@",imgTypeStr]];
        NSLog(@"jgreojpopewfpkhtph------%@--%@",filePath,NSStringFromCGSize(image.size));
        [self dismissViewControllerAnimated:YES completion:nil];
        //portrait.image = image;
        //---添加image---
        [photoImageArr insertObject:image atIndex:0];
        [self createPhotoView];//重新排序imgView
        [imgDataForUploadArr addObject:data];//----data
        [imgDataForUploadArr addObject:imgTypeStr];//图片类型
    }
}
//----------点击取消-------
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//-----更加图片数组刷新view----
-(void)createPhotoView{
    NSInteger photoImgCount = photoImageArr.count;
    
    if (photoImgCount>0) {
        //------删除子view,重新绘制------
        for (UIView *item in [photoView  subviews]) {
            if (item.tag!=1000) {
                [item removeFromSuperview];
            }
        }
        int sizeLength = 80;
        int space = 5;
        for (int i=0; i<photoImgCount; i++) {
            int lineNum = floor(i/4.0);
            int columnNum = i%4;
            if (i==photoImgCount-1) {
                if (i!=MAXIMGNUM) {
                    addPhotoBtn.frame = CGRectMake(sizeLength*columnNum+space, sizeLength*lineNum+space, sizeLength-space*2, sizeLength-space*2);
                    [photoView addSubview:addPhotoBtn];
                }
            }else{
                UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(sizeLength*columnNum, sizeLength*lineNum, sizeLength, sizeLength)];
                [photoView addSubview:itemView];
                
                
                //----图片-----
                UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(space, space, sizeLength-space*2, sizeLength-space*2)];
                imgV.image = photoImageArr[i];
                imgV.layer.borderColor = [UIColor grayColor].CGColor;
                imgV.layer.borderWidth = 1;
                imgV.layer.cornerRadius = 3;
                [itemView addSubview:imgV];
                imgV.contentMode = UIViewContentModeScaleAspectFit;
                
                //----删除----20/18  38/35--15/13
                UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 40)];
                [itemView addSubview:deleteBtn];
                deleteBtn.tag = 100 + i;
                [deleteBtn setImage:[UIImage imageNamed:@"selected_bg.9.png"] forState:UIControlStateNormal];
                [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 25, 27, 0)];
                [deleteBtn addTarget:self action:@selector(deletePhoto:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
}
//------删除图片-----
-(void)deletePhoto:(UIButton *)btn{
    NSInteger tag = btn.tag - 100;
    if ([btn.accessibilityIdentifier isEqualToString:@"deleteState"]) {
        //------删除----
        [photoImageArr removeObjectAtIndex:tag];
        [self createPhotoView];
    }else{
        //-----待删除---
        [btn setImage:[UIImage imageNamed:@"selected_del.9.png"] forState:UIControlStateNormal];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 22, 20, 0)];
        btn.accessibilityIdentifier  = @"deleteState";
    }
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSquareWidth:(double)imgMaxWidth
{
    double imgWidth,imgHeight;
    if (image.size.width>image.size.height) {
        imgWidth = imgMaxWidth;
        imgHeight = image.size.height/image.size.width*imgWidth;
    }else{
        imgHeight = imgMaxWidth;
        imgWidth = image.size.width/image.size.height*imgHeight;
    }
    CGSize size = CGSizeMake(imgWidth, imgHeight);
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    NSLog(@"jfioafjeiofiowoeifwji------%@--%@",NSStringFromCGSize(image.size),NSStringFromCGSize(size));
    
    
    return scaledImage;   //返回的就是已经改变的图片
}

//-----提交上传-----
-(void)uploadOneFileData:(NSData *)woodImgData imgType:(NSString*)typeStr imgName:(NSString *)fileName{
    NSLog(@"clickFinish--------------%@",typeStr);
    if (woodImgData) {
        [Waiting show];
        //---------上传图片文件--------
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
        //------   http://1.qqupfile.sinaapp.com/Index/upFile
        NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:@"http://115.28.77.246:8098/" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [Waiting show];
            /*
             32          此方法参数
             33          1. 要上传的[二进制数据]
             34          2. 对应网站上[upload.php中]处理文件的[字段"file1"]
             35          3. 要保存在服务器上的[文件名]
             36          4. 上传文件的[mimeType]
             */
            [formData appendPartWithFileData:woodImgData name:@"file1" fileName:fileName mimeType:typeStr];
            
            NSLog(@"qeqweqfjaiogjrogitrhkpowefkw-------%@",fileName);
        }];
        // 3. operation包装的urlconnetion
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Waiting dismiss];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];
            [self.view makeToast:@"部分图片保存失败" duration:1.2 position:@"center"];
        }];
        [client.operationQueue addOperation:op];
    }
}

@end
