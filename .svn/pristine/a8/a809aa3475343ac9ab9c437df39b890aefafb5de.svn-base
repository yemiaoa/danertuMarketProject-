//
//  SellGoodCell.m
//  单耳兔
//
//  Created by yang on 15/7/3.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "SellGoodCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation SellGoodCell

@synthesize goodImage,goodNameLabel,oldPriceLabel,currentPriceLabel,totalCountLabel,leftCountLabel,editImageView,editLabel,onLineImageView,onLineLabel,deleteImageView,deleteLabel,goodEditBlock,onOrOffLineBlock,deleteBlock;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 130)];
        [self addSubview:bgView];
        bgView.backgroundColor = [UIColor whiteColor];
        
        goodImage = [[AsynImageView alloc] initWithFrame:CGRectMake(15, 15, 70, 70)];
        goodImage.placeholderImage = [UIImage imageNamed:@"noData2"];
        goodImage.layer.masksToBounds = YES;
        goodImage.layer.borderWidth = 0;
        goodImage.layer.borderColor = [UIColor clearColor].CGColor;
        goodImage.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:goodImage];
        
        goodNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 200, 20)];
        [self addSubview:goodNameLabel];
        [goodNameLabel setFont:TEXTFONT];
        [goodNameLabel setTextColor:[UIColor grayColor]];
        
        oldPriceLabel = [[UnderLineLabel alloc] initWithFrame:CGRectMake(100, 30, 150, 20)];
        [self addSubview:oldPriceLabel];
        [oldPriceLabel setFont:TEXTFONTSMALL];
        [oldPriceLabel setTextColor:[UIColor grayColor]];
        
        currentPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 45, 150, 20)];
        [self addSubview:currentPriceLabel];
        [currentPriceLabel setFont:TEXTFONT];
        [currentPriceLabel setTextColor:[UIColor redColor]];
        
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
        [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:1],nil]];
        // Setup the path
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, 100, 67);       //100 ,67 初始点 x,y
        CGPathAddLineToPoint(path, NULL, 310,67);     //67终点x,y
        [shapeLayer setPath:path];
        CGPathRelease(path);
        [[self layer] addSublayer:shapeLayer];
        /*
        UILabel *totalCountTip = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 50, 20)];
        [self addSubview:totalCountTip];
        [totalCountTip setText:@"总销量:"];
        [totalCountTip setFont:TEXTFONTSMALL];
        [totalCountTip setTextColor:[UIColor grayColor]];
        
        totalCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 70, 150, 20)];
        [self addSubview:totalCountLabel];
        [totalCountLabel setFont:TEXTFONTSMALL];
        [totalCountLabel setTextColor:[UIColor grayColor]];
        */
        UILabel *leftCountTip = [[UILabel alloc] initWithFrame:CGRectMake(100, 70, 50, 20)];
        [self addSubview:leftCountTip]; //(210, 70, 50, 20)
        [leftCountTip setText:@"库存:"];
        [leftCountTip setFont:TEXTFONTSMALL];
        [leftCountTip setTextColor:[UIColor grayColor]];
        [leftCountTip setTextAlignment:NSTextAlignmentLeft];
        
        leftCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 70, 150, 20)];
        [self addSubview:leftCountLabel]; //(240, 70, 150, 20)
        [leftCountLabel setFont:TEXTFONTSMALL];
        [leftCountLabel setTextColor:[UIColor grayColor]];
        [leftCountLabel setTextAlignment:NSTextAlignmentLeft];
        
        UIView *offLine = [[UIView alloc] initWithFrame:CGRectMake(10, 90, MAINSCREEN_WIDTH-20, 0.3)];
        [self addSubview:offLine];
        offLine.backgroundColor = [UIColor blackColor];
        
        editImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 35, 103, 12, 12)];
        [self addSubview:editImageView];
        
        editLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 99, 50, 20)];
        [self addSubview:editLabel];
        [editLabel setFont:TEXTFONTSMALL];
        [editLabel setTextColor:[UIColor grayColor]];
        
        onLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 35+106, 103, 12, 12)];
        [self addSubview:onLineImageView];
        
        onLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(55+106, 99, 50, 20)];
        [self addSubview:onLineLabel];
        [onLineLabel setFont:TEXTFONTSMALL];
        [onLineLabel setTextColor:[UIColor grayColor]];
        
        deleteImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 35+212, 103, 12, 12)];
        [self addSubview:deleteImageView];
        
        deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(55+212, 99, 50, 20)];
        [self addSubview:deleteLabel];
        [deleteLabel setFont:TEXTFONTSMALL];
        [deleteLabel setTextColor:[UIColor grayColor]];
        
        for (int i = 1; i<3; i++) {
            UIView *lineB = [[UIView alloc] initWithFrame:CGRectMake(107*i, 103, 0.8, 15)];
            [self addSubview:lineB];
            [lineB setBackgroundColor:[UIColor grayColor]];
        }
    
        _editeRect   = CGRectMake(0, 90, 106, 40);
        _onOrOffRect = CGRectMake(107, 90, 106, 40);
        _deleteRect  = CGRectMake(214, 90, 106, 40);
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(_editeRect, point)) {
        if (self.goodEditBlock)
            self.goodEditBlock();
    } else if (CGRectContainsPoint(_onOrOffRect, point)){
        if (self.onOrOffLineBlock)
            self.onOrOffLineBlock();
    }else if (CGRectContainsPoint(_deleteRect, point)){
        if (self.deleteBlock)
            self.deleteBlock();
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
