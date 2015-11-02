//
//  DetailViewController.m
//  Tuan
//
//  Created by 夏 华 on 12-7-4.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//
//-----商品详细页----
#import "LocationSingleton.h"
#import <BaiduMapAPI/BMKLocationService.h>
#import <BaiduMapAPI/BMKGeocodeSearch.h>

#define MinLocationSucceedNum 1   //要求最少成功定位的次数

@interface LocationSingleton()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_geoSearch;
}

@end

static LocationSingleton *sharedObj = nil; //第一步：静态实例，并初始化。

@implementation LocationSingleton
@synthesize locationmanager;
@synthesize cityFromPos;//反地理编码当前坐标获取的城市信息
@synthesize pos;//当前坐标,以及当前城市名称
+ (LocationSingleton*) sharedInstance  //第二步：实例构造检查静态实例是否为nil
{
    @synchronized (self)
    {
        if (sharedObj == nil)
        {
            sharedObj = [[self alloc] init];
        }
    }
    return sharedObj;
}

+ (id) allocWithZone:(NSZone *)zone //第三步：重写allocWithZone方法
{
    @synchronized (self) {
        if (sharedObj == nil) {
            sharedObj = [super allocWithZone:zone];
            return sharedObj;
        }
    }
    return nil;
}

- (id) copyWithZone:(NSZone *)zone //第四步
{
    return self;
}

- (id)init
{
    @synchronized(self) {
        locationmanager = [[CLLocationManager alloc]init];
        [locationmanager setDesiredAccuracy:kCLLocationAccuracyBest];
        //实现协议
        locationmanager.delegate = self;//这里的self应该是AppDelegate里的self,不过使用这里的self可以得到坐标
        if(![CLLocationManager locationServicesEnabled]){
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"警告" message:@"定位服务不可用" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
        }else{
        
        }
        if ([[UIDevice currentDevice].systemVersion floatValue] > 7.9) {
            [locationmanager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
            [locationmanager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
            //开始定位
//            [locationmanager startUpdatingLocation];
            
            //设置定位精确度，默认：kCLLocationAccuracyBest
            [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyBest];
            //指定最小距离更新(米)，默认：kCLDistanceFilterNone
            [BMKLocationService setLocationDistanceFilter:100.f];
            
            //初始化BMKLocationService
            _locService = [[BMKLocationService alloc] init];
            _locService.delegate = self;
            
            _geoSearch = [[BMKGeoCodeSearch alloc] init];
            _geoSearch.delegate = self;
            
            [_locService startUserLocationService];
            
        }
        
        return self;
    }
}


//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    CLLocation *newLocation = userLocation.location;
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    
//    NSString *latitudeStr = [NSString stringWithFormat:@"%.6f",coordinate.latitude];
//    NSString *longitudeStr = [NSString stringWithFormat:@"%.6f",coordinate.longitude];
    
    pos=[NSMutableDictionary dictionary];
    [pos setValue:[NSString stringWithFormat:@"%f",coordinate.latitude]  forKey:@"lat"];
    [pos setValue:[NSString stringWithFormat:@"%f",coordinate.longitude]  forKey:@"lot"];
    if(coordinate.latitude){
        [_locService stopUserLocationService];//停止gps
        
        BMKReverseGeoCodeOption *reverseGeoCodeOption = [[BMKReverseGeoCodeOption alloc] init];
        reverseGeoCodeOption.reverseGeoPoint = coordinate;
        _geoSearch.delegate = self;
        //进行反地理编码
        [_geoSearch reverseGeoCode:reverseGeoCodeOption];
        
//        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
//        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error){
//            //得到的数组placemarks就是CLPlacemark对象数组，这里只取第一个就行
//            CLPlacemark *mark = nil;
//            if([placemarks count] > 0){
//                id tempMark = [placemarks objectAtIndex:0];
//                if([tempMark isKindOfClass:[CLPlacemark class]])
//                {
//                    mark = tempMark;
//                }
//                //具体业务逻辑，CLPlacemark的属性有很多，包括了街道名等相关属性
//                NSDictionary *addressDict = mark.addressDictionary;
//                NSString *address = [addressDict  objectForKey:@"Street"];
//                address = address == nil ? @"" : address;
//                NSString *state = [addressDict objectForKey:@"State"];
//                state = state == nil ? @"" : state;
//                NSString *city = [addressDict objectForKey:@"City"];
//                //                NSString *SubLocality = [addressDict objectForKey:@"SubLocality"];
//                //                if (SubLocality == nil || [SubLocality isEqualToString:@""]) {
//                //                    //如果城市为空，那就将省份作为当前地址
//                //                    city = (city == nil) ? (state) : (city);
//                //                }
//                //                else{
//                //                    city = SubLocality;
//                //                }
//                [pos setObject:city forKey:@"cityName"];
//                NSLog(@"%@",addressDict);
//                cityFromPos = @{@"cId":@"",@"cName":city,@"province":state};
//            }
//        }];
    }
   
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSString *city = result.addressDetail.city;
    NSString *state = result.addressDetail.province;
    [pos setObject:city forKey:@"cityName"];
    NSLog(@"%@",result.addressDetail);
    cityFromPos = @{@"cId":@"",@"cName":city,@"province":state};
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


/***********/
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations objectAtIndex:0];
    CLLocationCoordinate2D coordinate = newLocation.coordinate;
    pos=[NSMutableDictionary dictionary];
    [pos setValue:[NSString stringWithFormat:@"%f",coordinate.latitude]  forKey:@"lat"];
    [pos setValue:[NSString stringWithFormat:@"%f",coordinate.longitude]  forKey:@"lot"];
    if(coordinate.latitude){
        [locationmanager stopUpdatingLocation];//停止gps
        CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
        [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error){
            //得到的数组placemarks就是CLPlacemark对象数组，这里只取第一个就行
            CLPlacemark *mark = nil;
            if([placemarks count] > 0){
                id tempMark = [placemarks objectAtIndex:0];
                if([tempMark isKindOfClass:[CLPlacemark class]])
                {
                    mark = tempMark;
                }
                //具体业务逻辑，CLPlacemark的属性有很多，包括了街道名等相关属性
                NSDictionary *addressDict = mark.addressDictionary;
                NSString *address = [addressDict  objectForKey:@"Street"];
                address = address == nil ? @"" : address;
                NSString *state = [addressDict objectForKey:@"State"];
                state = state == nil ? @"" : state;
                NSString *city = [addressDict objectForKey:@"City"];
//                NSString *SubLocality = [addressDict objectForKey:@"SubLocality"];
//                if (SubLocality == nil || [SubLocality isEqualToString:@""]) {
//                    //如果城市为空，那就将省份作为当前地址
//                    city = (city == nil) ? (state) : (city);
//                }
//                else{
//                    city = SubLocality;
//                }
                [pos setObject:city forKey:@"cityName"];
                NSLog(@"%@",addressDict);
                cityFromPos = @{@"cId":@"",@"cName":city,@"province":state};
            }
        }];
    }
}


/*
 坐标系
 */
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

#pragma mark-(BD-09) 百度坐标系转火星坐标系 (GCJ-02) 的转换算法
-(CLLocationCoordinate2D)returnGCJPoi:(CLLocationCoordinate2D)PoiLocation
{
    const double x_pi = 3.14159265358979324 * 3000.0 / 180.0;
    float x = PoiLocation.longitude - 0.0065, y = PoiLocation.latitude - 0.006;
    float z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    float theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    CLLocationCoordinate2D GCJpoi=
    CLLocationCoordinate2DMake( z * sin(theta),z * cos(theta));
    return GCJpoi;
}
//获取坐标错误
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
}

-(void)stopLocation
{
    [_locService stopUserLocationService];
}

-(void)startLocation
{
    [_locService startUserLocationService];
}

@end