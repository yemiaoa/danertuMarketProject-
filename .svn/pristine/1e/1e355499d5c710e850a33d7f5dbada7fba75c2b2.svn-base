//
//  GoodsMessageView.m
//  CustomerServerSDK2
//
//  Created by NTalker on 15/6/7.
//  Copyright (c) 2015年 NTalker. All rights reserved.
//

#import "NTalkerGoodsMessageView.h"
#import "NTalkerGoodsModel.h"
#import "UIImageView+WebCache.h"

@interface NTalkerGoodsMessageView (){
    
  UIView *goodsMessageView ;
 //商品信息展示内容
  UIImageView *goodsIcon;//商品图片
  UILabel *goodsNameLab;//商品名称
  UILabel *currencySignLab;//货币符号
  UILabel *goodsPriceLab;//商品价格
//接收传来的商品jeson数据
  NSString *goodsMessage;

}
@end

@implementation NTalkerGoodsMessageView
- (instancetype)init{
    if (!self) {
        self=[super init];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame andBigMa:(NTalkerGoodsModel *)dictModal
{
    self = [super initWithFrame:frame];
    if (self) {
    //View尺寸
    [self setFrame:CGRectMake(6, 69+3, kFWFullScreenWidth-12, kFWFullScreenHeight*0.16)];
        
    UIColor*goodsViewBackgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
        
    [self setBackgroundColor:goodsViewBackgroundColor];//SDK商品展示背景（可自定义）
    goodsMessageView =self;
     
//    bigMa *dictModal = [bigMa dictionaryWithJsonString:nil];//【注意】集成时候此处的nil应该传json 数据
        
    //商品图片
    goodsIcon = [[UIImageView alloc]initWithFrame:CGRectMake(6, 6, kFWFullScreenHeight*0.16-12, kFWFullScreenHeight*0.16-12)];
    goodsIcon.backgroundColor =[UIColor lightGrayColor];
    //加载图片
//        [goodsIcon sd_setImageWithURL:[NSURL URLWithString:dictModal.goods_showurl]];
        [goodsIcon sd_setImageWithURL:[NSURL URLWithString:dictModal.goods_image]];
        

//    goodsIcon.contentMode=UIViewContentModeScaleToFill;
//    [goodsIcon setImage:goodsImage];
        
    [self addSubview:goodsIcon];
    
    //商品名称
    CGFloat goodsIconMaxX = CGRectGetMaxX(goodsIcon.frame);
    goodsNameLab = [[UILabel alloc]initWithFrame:CGRectMake(goodsIconMaxX+6, 6, self.frame.size.width-goodsIconMaxX-12,goodsIcon.frame.size.height/2)];
    goodsNameLab.backgroundColor = [UIColor clearColor];
    [goodsNameLab setFont:[UIFont systemFontOfSize:13.0]];
    [goodsNameLab setText:dictModal.goods_name];//衣服名称＊＊＊＊＊
    goodsNameLab.lineBreakMode =NSLineBreakByTruncatingTail;//省略结尾，以省略号代替
    goodsNameLab.numberOfLines = 2;
    [self addSubview:goodsNameLab];
        
    //货币符号currency
    CGFloat goodsNameLabMaxY = CGRectGetMaxY(goodsNameLab.frame);
    currencySignLab = [[UILabel alloc]initWithFrame:CGRectMake(goodsIconMaxX+6, goodsNameLabMaxY+6, goodsIcon.frame.size.height/2-6,goodsIcon.frame.size.height/2-6)];
    currencySignLab.backgroundColor = [UIColor clearColor];
    [currencySignLab setText:@"¥:"];
    [currencySignLab setTextColor:[UIColor redColor]];
    [currencySignLab setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:currencySignLab];
        
    //商品价格
    CGFloat currencySignLabMaxX = CGRectGetMaxX(currencySignLab.frame);
    goodsPriceLab = [[UILabel alloc]initWithFrame:CGRectMake(currencySignLabMaxX, goodsNameLabMaxY+6,goodsNameLab.frame.size.width-currencySignLab.frame.size.width ,currencySignLab.frame.size.height)];
    goodsPriceLab.backgroundColor =[UIColor clearColor];
    [goodsPriceLab setText:dictModal.goods_price];//价格＊＊＊
    [goodsPriceLab setTextColor:[UIColor redColor]];
    [goodsPriceLab setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:goodsPriceLab];
        
    }
    
    return self;
}

@end
