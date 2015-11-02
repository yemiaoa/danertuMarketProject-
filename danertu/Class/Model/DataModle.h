//
//  DataModle.h
//  Tuan
//
//  Created by 夏 华 on 12-7-5.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BYBaseModel.h"
@interface DataModle : BYBaseModel
/*
@property(nonatomic, retain) NSString *webSite;
@property(nonatomic, retain) NSString *city;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *url;
@property(nonatomic, retain) NSString *img;
@property(nonatomic, retain) NSString *startTime;
@property(nonatomic, retain) NSString *endTime;
@property(nonatomic, retain) NSString *value;
@property(nonatomic, retain) NSString *price;
@property(nonatomic, retain) NSString *bought;
@property(nonatomic, retain) NSString *desc;
@property(nonatomic, retain) NSString *tips;
*/
@property(nonatomic, retain) NSString *s;//点名--新胜乐商场
@property(nonatomic, retain) NSString *m;//   --18022005702
@property(nonatomic, retain) NSString *c;//   --019018013
@property(nonatomic, retain) NSString *e;//图片地址  --/ImgUpload/lvjianping.jpg
@property(nonatomic, retain) NSString *z;
@property(nonatomic, retain) NSString *sc;
@property(nonatomic, retain) NSString *om;
@property(nonatomic, retain) NSString *w;//地址  --广东省中山市三乡镇新圩村金湾路87号首层
@property(nonatomic, retain) NSString *num;//  --T粤0045A
@property(nonatomic, retain) NSString *id;//  --18022005702
@property(nonatomic, retain) NSString *jyfw;//  --百货,包装食品
@property(nonatomic, retain) NSString *Rank;//等级  --4
@property(nonatomic, retain) NSString *i;//  --3
@property(nonatomic, retain) NSString *ot;//  --11410.000000

//坐标
@property(nonatomic, retain) NSString *la;//  --22330635
@property(nonatomic, retain) NSString *lt;//  --22330635

@property(nonatomic, retain) NSString *distance;//  --距离
@property(nonatomic, retain) NSString *juli;// --距离

@property(nonatomic, retain) NSMutableArray *location;//  --22330635
@property(nonatomic, retain) NSString *leveltype;//-----决定店铺使用模板类型------

@property(nonatomic, retain) NSString *shopshowproduct;
@end
