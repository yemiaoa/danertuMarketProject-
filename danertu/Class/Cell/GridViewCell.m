//
//  GridViewCell.m
//  AQGridViewDemo
//
//  Created by 夏 华 on 12-6-26.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "GridViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation GridViewCell

@synthesize imageView,captionLabel, addLabel,woodsLabel,infoStr,juliLabel,priceLabel,shopTelLable,shopAddressLable;



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //标题
        self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(102, 4, 190, 18)];
        captionLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        captionLabel.numberOfLines = 1;
        [self.contentView addSubview:captionLabel];
        //距离
        self.juliLabel = [[UILabel alloc] initWithFrame:CGRectMake(102, 22, 210, 12)];
        juliLabel.font = TEXTFONTSMALL;
        juliLabel.textAlignment = NSTextAlignmentRight;
        juliLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:juliLabel];
        //主营
        self.addLabel = [[UILabel alloc] initWithFrame:CGRectMake(102, 34, 200, 14)];
        addLabel.font = TEXTFONT;
        [self.contentView addSubview:addLabel];
        //特价商品
        self.woodsLabel = [[UILabel alloc] initWithFrame:CGRectMake(102, 64, 120, 20)];
        woodsLabel.font = [UIFont systemFontOfSize:16];
        woodsLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:woodsLabel];
        
        //特价价格
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(222, 64, 90, 20)];
        priceLabel.textColor = [UIColor redColor];
        priceLabel.font = [UIFont systemFontOfSize:16];
        priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:priceLabel];
        
        //店铺图片
        self.imageView = [[AsynImageView alloc] initWithFrame:CGRectMake(4, 4, 84, 84)];
        self.imageView.placeholderImage = [UIImage imageNamed:@"noData1"];
        
        //底边
        UILabel *borderBottom = [[UILabel alloc]initWithFrame:CGRectMake(0, 91.4, MAINSCREEN_WIDTH, 0.6)];
        borderBottom.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [self.contentView addSubview:borderBottom];
        
        [self.contentView addSubview:imageView];
        
        //暂时增加
        self.shopAddressLable = [[UILabel alloc] initWithFrame:CGRectMake(102, 50+10, 200, 14 + 15)];
        shopAddressLable.font = TEXTFONT;
        shopAddressLable.numberOfLines = 0;
        shopAddressLable.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:shopAddressLable];
        
        self.shopTelLable = [[UILabel alloc] initWithFrame:CGRectMake(102, 50, 200, 14)];
        shopTelLable.font = TEXTFONT;
        [self.contentView addSubview:shopTelLable];
    }
    return self;
}

@end
