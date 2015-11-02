//
//  FavoriteWoodsModle.h
//  此modle字段由   DanModle和DataModle字段组合
//
//
#import <Foundation/Foundation.h>
#import "BYBaseModel.h"
@interface FavoriteWoodsModle : BYBaseModel

@property(nonatomic, retain) NSString *woodsType;//商品名称,  "泸州土豪醇 窖藏"
@property(nonatomic, retain) NSString *Guid;//   图片  /ImgUpload/201401231452529706.jpg
@property(nonatomic, retain) NSString *img;//   1
@property(nonatomic, retain) NSString *name;//来自之前的view里的item数据,,  酒仙商店
@property(nonatomic, retain) NSString *market;//来自之前的view里的item数据,,   18926113931
@property(nonatomic, retain) NSString *price;//市场价格,原价  336.00
@property(nonatomic, retain) NSString *woodFrom;//----是否是自营店商品
@property(nonatomic, retain) NSString *mobileProductDetail;//商品描述
@property(nonatomic, retain) NSString *SupplierLoginID;// 供应商id
@property(nonatomic, retain) NSString *AgentId;//-----自营店


//暂时无用
@property(nonatomic, retain) NSString *s; //点名--新胜乐商场
@property(nonatomic, retain) NSString *m; //   --18022005702
@property(nonatomic, retain) NSString *c; //   --019018013
@property(nonatomic, retain) NSString *e; //图片地址  --/ImgUpload/lvjianping.jpg
@property(nonatomic, retain) NSString *z;
@property(nonatomic, retain) NSString *sc;
@property(nonatomic, retain) NSString *om;
@property(nonatomic, retain) NSString *w; //地址  --广东省中山市三乡镇新圩村金湾路87号首层
@property(nonatomic, retain) NSString *num; //  --T粤0045A
@property(nonatomic, retain) NSString *id; //  --18022005702
@property(nonatomic, retain) NSString *jyfw; //  --百货,包装食品
@property(nonatomic, retain) NSString *Rank; //等级  --4
@property(nonatomic, retain) NSString *i; //  --3
@property(nonatomic, retain) NSString *ot; //  --11410.000000

//坐标
@property(nonatomic, retain) NSString *la; //  --22330635
@property(nonatomic, retain) NSString *lt; //  --22330635

@property(nonatomic, retain) NSMutableArray *location; //  --22330635
@end
