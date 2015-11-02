//
//  CityListViewController.h
//  CityList
//
//  Created by Chen Yaoqiang on 14-3-6.
//
//

#import <UIKit/UIKit.h>
#import "TopNaviViewController.h"
@class CityController;
@protocol CityControllerDelegate<NSObject>
-(void)CityController:(CityController *)controller
        didSelectCity:(NSDictionary *)cityDic;
-(NSDictionary *)getGpsCity;
@end

@interface CityController : TopNaviViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSMutableDictionary *cities;

@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, strong) NSMutableArray *arrayCitys;   //城市数据
@property (nonatomic, strong) NSMutableArray *arrayHotCity;
@property (nonatomic, strong) NSDictionary *city;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong) id<CityControllerDelegate> delegate;

@end
