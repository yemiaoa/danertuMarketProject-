//
//  HeWineActivityCell.m
//  单耳兔
//
//  Created by iMac on 15/6/10.
//  Copyright (c) 2015年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import "HeWineActivityCell.h"

@implementation HeWineActivityCell
@synthesize name,telephone,address,wineNums,timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 95)];
        [self addSubview:bgView];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        
        name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MAINSCREEN_WIDTH-100, 20)];
        [self addSubview:name];
        [name setFont:[UIFont systemFontOfSize:16]];
        
        telephone = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 150, 20)];
        [self addSubview:telephone];
        [telephone setFont:TEXTFONTSMALL];
        telephone.textColor = [UIColor grayColor];
        
        UILabel *tip = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-33, 17, 20, 20)];
        [self addSubview:tip];
        [tip setFont:TEXTFONT];
        tip.text = @"瓶";
        
        wineNums = [[UILabel alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-135, 10, 100, 30)];
        [self addSubview:wineNums];
        [wineNums setFont:[UIFont systemFontOfSize:24]];
        wineNums.textColor = TOPNAVIBGCOLOR;
        wineNums.textAlignment = NSTextAlignmentRight;
        
        //虚线
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        [shapeLayer setBounds:self.bounds];
        [shapeLayer setPosition:self.center];
        [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
        // 设置虚线颜色为black
        [shapeLayer setStrokeColor:[[UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0f] CGColor]];
        // 3.0f设置虚线的宽度
        [shapeLayer setLineJoin:kCALineJoinRound];
        // 3=线的宽度 1=每条线的间距
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:2],nil]];
        // Setup the path
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 0, 50);       //100 ,67 初始点 x,y
        CGPathAddLineToPoint(path, NULL, MAINSCREEN_WIDTH,50);     //67终点x,y
        [shapeLayer setPath:path];
        CGPathRelease(path);
        [[self layer] addSublayer:shapeLayer];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 55, MAINSCREEN_WIDTH-20, 20)];
        [self addSubview:timeLabel];
        [timeLabel setFont:TEXTFONTSMALL];
        timeLabel.textColor = [UIColor grayColor];
        
        address = [[UILabel alloc] initWithFrame:CGRectMake(10, 75, MAINSCREEN_WIDTH-20, 20)];
        [self addSubview:address];
        [address setFont:TEXTFONTSMALL];
        address.textColor = [UIColor grayColor];
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
