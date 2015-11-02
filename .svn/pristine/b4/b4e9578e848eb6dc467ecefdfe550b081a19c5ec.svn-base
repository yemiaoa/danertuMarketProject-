//
//  SellOrderCell.m
//  单耳兔
//
//  Created by yang on 15/7/3.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "SellOrderCell.h"

@implementation SellOrderCell
@synthesize woodImage;
@synthesize orderNumberLabel;
@synthesize consigneeLabel;
@synthesize priceLabel;
@synthesize timeLabel;
@synthesize orderStateLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 100)];
        [self addSubview:bgView];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        
        woodImage = [[AsynImageView alloc] initWithFrame:CGRectMake(10, 15, 70, 70)];
        [self addSubview:woodImage];
        
        UILabel *orderTip = [[UILabel alloc] initWithFrame:CGRectMake(88, 10, 50, 20)];
        [self addSubview:orderTip];
        [orderTip setText:@"订单号:"];
        [orderTip setFont:TEXTFONT];
        [orderTip setTextAlignment:NSTextAlignmentLeft];
        
        orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(138, 10, 150, 20)];
        [self addSubview:orderNumberLabel];
        [orderNumberLabel setFont:TEXTFONT];
        [orderNumberLabel setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *consigneeTip = [[UILabel alloc] initWithFrame:CGRectMake(88, 30, 50, 20)];
        [self addSubview:consigneeTip];
        [consigneeTip setText:@"收货人:"];
        [consigneeTip setFont:TEXTFONT];
        [consigneeTip setTextAlignment:NSTextAlignmentLeft];
        
        consigneeLabel = [[UILabel alloc] initWithFrame:CGRectMake(138, 30, 150, 20)];
        [self addSubview:consigneeLabel];
        [consigneeLabel setFont:TEXTFONT];
        [consigneeLabel setTextAlignment:NSTextAlignmentLeft];
        
        UILabel *priceTip = [[UILabel alloc] initWithFrame:CGRectMake(88, 50, 50, 20)];
        [self addSubview:priceTip];
        [priceTip setText:@"金    额:"];
        [priceTip setFont:TEXTFONT];
        [priceTip setTextAlignment:NSTextAlignmentLeft];
        
        priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(138, 50, 150, 20)];
        [self addSubview:priceLabel];
        [priceLabel setTextColor:[UIColor redColor]];
        [priceLabel setFont:TEXTFONT];
        [priceLabel setTextAlignment:NSTextAlignmentLeft];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(88, 70, 150, 20)];
        [self addSubview:timeLabel];
        [timeLabel setFont:TEXTFONT];
        [timeLabel setTextAlignment:NSTextAlignmentLeft];
        
        orderStateLabel = [[UILabel alloc] initWithFrame:CGRectMake(260, 70, 50, 20)];
        [self addSubview:orderStateLabel];
        [orderStateLabel setTextColor:[UIColor redColor]];
        [orderStateLabel setFont:TEXTFONT];
        [orderStateLabel setTextAlignment:NSTextAlignmentLeft];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
