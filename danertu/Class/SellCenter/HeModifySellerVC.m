//
//  HeModifySellerVC.m
//  单耳兔
//
//  Created by Tony on 15/9/21.
//  Copyright © 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "HeModifySellerVC.h"
#import "AFHTTPRequestOperation.h"
#import "UIView+Toast.h"
#import <BaiduMapAPI/BMKLocationService.h>
#import <BaiduMapAPI/BMKGeocodeSearch.h>

#define MinLocationSucceedNum 1   //要求最少成功定位的次数

@interface HeModifySellerVC ()<BMKLocationServiceDelegate>
{
    NSMutableDictionary *imgeData;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geoSearch;
}
@property (nonatomic,assign)NSInteger locationSucceedNum; //定位成功的次数
@property (nonatomic,strong)NSMutableDictionary *userLocationDict;

@end

@implementation HeModifySellerVC
@synthesize locationSucceedNum;
@synthesize userLocationDict;
@synthesize myShopDataInfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imgeData = [[NSMutableDictionary alloc] init];
    [self initView];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_locService stopUserLocationService];
    _geoSearch.delegate = nil;
}

-(NSString*)getTitle
{
    return @"店铺设置";
}

- (BOOL)isShowFinishButton{
    return YES;
}

- (void) clickFinish{
    NSLog(@"完成!");
}

- (void)initView{
    [self.view setBackgroundColor:[UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1]];
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:5.f];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc] init];
    _locService.delegate = self;
    //启动LocationService
    
    _geoSearch = [[BMKGeoCodeSearch alloc] init];
    _geoSearch.delegate = self;
    
    userLocationDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    locationSucceedNum = 0;
    
}

//选择头像
- (void)func_chooseHeadImage{
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

//提交头像图片,在信息提交成功之后
- (void)sendImageDataToSever{
    if ([imgeData valueForKey:@"dataKey"]) {
        [self uploadOneFileData:[imgeData valueForKey:@"dataKey"] imgType:[imgeData valueForKey:@"imageTypeKey"] imgName:[NSString stringWithFormat:@"%@",[imgeData valueForKey:@"fileNameKey" ]]];
    }
    else{
        NSDictionary *dict = [self.jsJsonString objectFromJSONString];
        NSString *callBackMethod = [dict objectForKey:@"callBackMethod"];
        NSString *fileName = [[[myShopDataInfo valueForKey:@"val"] objectAtIndex:0] valueForKey:@"EntityImage"];
        NSString *jsFunc = [NSString stringWithFormat:@"%@('%@')",callBackMethod,fileName];
        [self.webView stringByEvaluatingJavaScriptFromString:jsFunc];
    }
}

- (void)json_upLoadImage:(NSString *)jsonString
{
    self.jsJsonString = jsonString;
    [self sendImageDataToSever];
}

//提交上传
-(void)uploadOneFileData:(NSData *)woodImgData imgType:(NSString*)typeStr imgName:(NSString *)fileName{
    if (woodImgData) {
        [Waiting show];
        //上传图片文件
        NSDictionary *dict = [self.jsJsonString objectFromJSONString];
        NSString *agentid = [dict objectForKey:@"shopid"];
        NSString *shopType = [dict objectForKey:@"leveltype"];
        if ([shopType isMemberOfClass:[NSNull class]] || shopType == nil || [shopType isEqualToString:@""]) {
            shopType = @"0";
        }
        //shopType  0:店铺  1:供应商
        NSDictionary *params = @{@"agentid":agentid,@"shopType":shopType};
        
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:APIURL]];
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
                NSLog(@"图片上传成功");
                //图片上传成功
                
                NSString *callBackMethod = [dict objectForKey:@"callBackMethod"];
                
                NSString *jsFunc = [NSString stringWithFormat:@"%@('%@')",callBackMethod,[imgeData valueForKey:@"fileNameKey" ]];
                [self.webView stringByEvaluatingJavaScriptFromString:jsFunc];
//                [self.view makeToast:@"头像设置成功" duration:1.2 position:@"center"];
            }
            else{
//                [self showHint:@"图片上传出错"];
                //假如图片上传出错，就先直接提交资料
                NSDictionary *dict = [self.jsJsonString objectFromJSONString];
                NSString *callBackMethod = [dict objectForKey:@"callBackMethod"];
                NSString *fileName = [[[myShopDataInfo valueForKey:@"val"] objectAtIndex:0] valueForKey:@"EntityImage"];
                NSString *jsFunc = [NSString stringWithFormat:@"%@('%@')",callBackMethod,fileName];
                [self.webView stringByEvaluatingJavaScriptFromString:jsFunc];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Waiting dismiss];
            [self showHint:REQUESTERRORTIP];
        }];
        [client.operationQueue addOperation:op];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        switch (buttonIndex) {
            case 0:
                [_locService stopUserLocationService];
                return;
                break;
            case 1:
            {
                NSString *latitudeStr = [userLocationDict objectForKey:@"latitude"];
                if (latitudeStr == nil) {
                    latitudeStr = @"";
                }
                NSString *longitudeStr = [userLocationDict objectForKey:@"longitude"];
                if (longitudeStr == nil) {
                    longitudeStr = @"";
                }
                
                NSString *jsFunction = [NSString stringWithFormat:@"getShopLat('%@','%@')",latitudeStr,longitudeStr];
                [self.webView stringByEvaluatingJavaScriptFromString:jsFunction];
                break;
            }
            default:
                break;
        }
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
        UIImage *scaleImage = [self thumbnailWithImage:image size:CGSizeMake(300, 300)];
        
        NSData *data;
        NSString *imgTypeStr;
        
        NSDate *senddate=[NSDate date];
        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"YYYYMMddhhmmss"];
        NSString *timeStr   = [dateformatter stringFromDate:senddate];
        NSString * imageStr = nil;
        data = UIImagePNGRepresentation(scaleImage);
        imgTypeStr = @"image/png";//jpeg和安卓保持一致
        imageStr = [NSString stringWithFormat:@"%@sell_headImage.png",timeStr];
        NSArray *array = [imageStr componentsSeparatedByString:@":"];
        NSMutableString *mutableString = [[NSMutableString alloc] initWithCapacity:0];
        for (NSString *str in array) {
            [mutableString appendString:str];
        }
        //把需要的图片信息保存到imgeData中
        [imgeData setObject:data forKey:@"dataKey"];
        [imgeData setObject:imgTypeStr forKey:@"imageTypeKey"];
        [imgeData setObject:mutableString forKey:@"fileNameKey"];

        /*
         image就是所需要的头像
         */

        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [self uploadPhotoToJs];
        }];
    }
}

- (UIImage *)thumbnailWithImage:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    if (nil == image) {
        
        newimage = nil;
        
    }
    
    else{
        
        UIGraphicsBeginImageContext(asize);
        
        [image drawInRect:CGRectMake(0, 0, asize.width, asize.height)];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    return newimage;
    
}

- (void)uploadPhotoToJs
{
    NSData *imageData = [imgeData objectForKey:@"dataKey"];
    NSString *imageTypeKey = [imgeData objectForKey:@"imageTypeKey"];
    
    NSString *baseString = [GTMBase64 stringByEncodingData:imageData];
    NSString *jsFunction = [NSString stringWithFormat:@"callBack('data:%@;base64,%@')",imageTypeKey,baseString];
    [self.webView stringByEvaluatingJavaScriptFromString:jsFunction];
}

- (void)func_getLocation
{
    if([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务设置->隐私->定位服务" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alertView show];
    }else{
        [self showHudInView:self.view hint:@"定位中..."];
        [_locService startUserLocationService];
    }
}

//获取商家的坐标位置
-(void)sendLocationToSever{
    NSString *latitudeStr = [userLocationDict objectForKey:@"latitude"];
    if (latitudeStr == nil) {
        latitudeStr = @"";
    }
    NSString *longitudeStr = [userLocationDict objectForKey:@"longitude"];
    if (longitudeStr == nil) {
        longitudeStr = @"";
    }
    //修改店铺坐标
    NSDictionary * params  = @{@"apiid": @"0242",
                               @"shopid" : [[[NSUserDefaults standardUserDefaults] valueForKey:@"userLoginInfo"] valueForKey:@"MemLoginID"],
                               @"la" : latitudeStr,
                               @"lt" : longitudeStr};
    NSURLRequest * request = [[AFOSCClient sharedClient] requestWithMethod:@"POST"
                                                                      path:@""
                                                                parameters:params];
    AFHTTPRequestOperation * operation = [[AFOSCClient sharedClient] HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Waiting dismiss];
        NSString *respondStr = operation.responseString;
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[respondStr objectFromJSONString]];
        if ([[tempDic valueForKey:@"result"] isEqualToString:@"true"]){
            [self.view makeToast:@"已成功设置店铺坐标" duration:2.0 position:@"center"];
        }else{
            [self.view makeToast:@"设置店铺坐标失败,请重新设置" duration:2.0 position:@"center"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Waiting dismiss];
        [self.view makeToast:@"请检查网络连接是否正常" duration:2.0 position:@"center"];
    }];
    
    [operation start];
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    CLLocation *newLocation = userLocation.location;
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    
    NSString *latitudeStr = [NSString stringWithFormat:@"%.6f",coordinate.latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%.6f",coordinate.longitude];
    
    
    if (newLocation) {
        locationSucceedNum = locationSucceedNum + 1;
        if (locationSucceedNum >= MinLocationSucceedNum) {
            [self hideHud];
            locationSucceedNum = 0;
            [userLocationDict setObject:latitudeStr forKey:@"latitude"];
            [userLocationDict setObject:longitudeStr forKey:@"longitude"];
            [_locService stopUserLocationService];
            
            BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
            reverseGeoCodeOption.reverseGeoPoint = coordinate;
            _geoSearch.delegate = self;
            //进行反地理编码
            [_geoSearch reverseGeoCode:reverseGeoCodeOption];
            //上传坐标
            NSString *latitudeStr = [userLocationDict objectForKey:@"latitude"];
            if (latitudeStr == nil) {
                latitudeStr = @"";
            }
            latitudeStr = [NSString stringWithFormat:@"%.6f",[latitudeStr floatValue] * 100000];
            NSString *longitudeStr = [userLocationDict objectForKey:@"longitude"];
            if (longitudeStr == nil) {
                longitudeStr = @"";
            }
            longitudeStr = [NSString stringWithFormat:@"%.6f",[longitudeStr floatValue] * 100000];
            
            NSString *jsFunction = [NSString stringWithFormat:@"getShopLat('%@','%@')",latitudeStr,longitudeStr];
            [self.webView stringByEvaluatingJavaScriptFromString:jsFunction];
            [self showHint:@"上传坐标成功"];
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"是否将当前定位坐标作为您店铺的地址？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//            alertView.tag = 100;
//            [alertView show];
        }
    }
    //NSLog(@"heading is %@",userLocation.heading);
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
//    NSLog(@"地址是：%@,%@",result.address,result.addressDetail);
    NSString *jsFunction = [NSString stringWithFormat:@"setAddressDetail('%@')",result.address];
    [self.webView stringByEvaluatingJavaScriptFromString:jsFunction];
}

- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSLog(@"%@",result.address);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

#pragma mark CLLocationManagerDelegate
//iOS6.0以后定位更新使用的代理方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations objectAtIndex:0];
    CLLocationCoordinate2D coordinate1 = newLocation.coordinate;
    
    CLLocationCoordinate2D coordinate = [self returnBDPoi:coordinate1];
    NSString *latitudeStr = [NSString stringWithFormat:@"%.6f",coordinate.latitude];
    NSString *longitudeStr = [NSString stringWithFormat:@"%.6f",coordinate.longitude];
    
    
    if (newLocation) {
        locationSucceedNum = locationSucceedNum + 1;
        if (locationSucceedNum >= MinLocationSucceedNum) {
            [self hideHud];
            locationSucceedNum = 0;
            [userLocationDict setObject:latitudeStr forKey:@"latitude"];
            [userLocationDict setObject:longitudeStr forKey:@"longitude"];
            [_locService stopUserLocationService];
            
            BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
            reverseGeoCodeOption.reverseGeoPoint = coordinate;
            _geoSearch.delegate = self;
            //进行反地理编码
            [_geoSearch reverseGeoCode:reverseGeoCodeOption];
            //上传坐标
            NSString *latitudeStr = [userLocationDict objectForKey:@"latitude"];
            if (latitudeStr == nil) {
                latitudeStr = @"";
            }
            NSString *longitudeStr = [userLocationDict objectForKey:@"longitude"];
            if (longitudeStr == nil) {
                longitudeStr = @"";
            }
            
            NSString *jsFunction = [NSString stringWithFormat:@"getShopLat('%@','%@')",latitudeStr,longitudeStr];
            [self.webView stringByEvaluatingJavaScriptFromString:jsFunction];
            [self showHint:@"上传坐标成功"];
        }
    }
    
}

#pragma 火星坐标系 (GCJ-02) 转 mark-(BD-09) 百度坐标系 的转换算法
-(CLLocationCoordinate2D)returnBDPoi:(CLLocationCoordinate2D)PoiLocation
{
    const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    float x = PoiLocation.longitude + 0.0065, y = PoiLocation.latitude + 0.006;
    float z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    float theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    CLLocationCoordinate2D GCJpoi=
    CLLocationCoordinate2DMake( z * sin(theta),z * cos(theta));
    return GCJpoi;
}

//定位失误时触发
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
    //    [self.view makeToast:@"定位失败,请重新定位" duration:2.0 position:@"center"];
}

//编辑图片
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end