//
//  SellShopCell.m
//  单耳兔
//
//  Created by yang on 15/7/3.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

#import "SellShopCell.h"

@implementation SellShopCell
@synthesize shopImage;
@synthesize shopNameLabel;
@synthesize shopNumberLabel;
@synthesize realNameLabel;
@synthesize mobileLabel;
@synthesize bgImageView;
@synthesize shopDict;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withCellSize:(CGSize)cellSize
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor colorWithRed:255.0 / 255.0 green:238.0 / 255.0 blue:238.0 / 255.0 alpha:1.0];
        
        CGFloat imageX = 10;;
        CGFloat imageY = 5;
        CGFloat imageW = cellSize.width - 2 * imageX;
        CGFloat imageH = cellSize.height - 2 *imageY;
        
        bgImageView = [[UIImageView alloc] init];
        bgImageView.backgroundColor = [UIColor whiteColor];
        bgImageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
        bgImageView.layer.cornerRadius = 6.0;
        bgImageView.layer.masksToBounds = YES;
        bgImageView.layer.borderWidth = 0;
        bgImageView.layer.borderColor = [UIColor clearColor].CGColor;
        [self addSubview:bgImageView];
        
//        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 80)];
//        [self addSubview:bgView];
//        [bgView setBackgroundColor:[UIColor whiteColor]];
        
        CGFloat shopImageX = 10;
        CGFloat shopImageY = 10;
        CGFloat shopImageW = 60;
        CGFloat shopImageH = shopImageW;
        
        shopImage = [[AsynImageView alloc] initWithFrame:CGRectMake(shopImageX, shopImageY, shopImageW, shopImageH)];
        shopImage.layer.borderWidth = 0;
        shopImage.layer.borderColor = [UIColor clearColor].CGColor;
        shopImage.layer.cornerRadius = 3.0;
        shopImage.layer.masksToBounds = YES;
        [bgImageView addSubview:shopImage];
        
        CGFloat phoneCallIconW = 30;
        CGFloat phoneCallIconH = 30;
        CGFloat distance = 10;  //离边缘的距离
        CGFloat phoneCallIconX = imageW - phoneCallIconW - distance;
        CGFloat phoneCallIconY = 0;
        
        CGRect phoneIconFrame = CGRectMake(phoneCallIconX, phoneCallIconY, phoneCallIconW, phoneCallIconH);
        
        UIImageView *phoneIcon = [[UIImageView alloc] init];
        phoneIcon.image = [UIImage imageNamed:@"shop_sell_PhoneCall"];
        phoneIcon.userInteractionEnabled = YES;
        phoneIcon.frame = phoneIconFrame;
        bgImageView.userInteractionEnabled = YES;
        [bgImageView addSubview:phoneIcon];
        CGPoint shopCenter = phoneIcon.center;
        CGPoint imageCenter = shopImage.center;
        shopCenter.y = imageCenter.y;
        phoneIcon.center = shopCenter;
        
        UITapGestureRecognizer *callPhoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callShop:)];
        callPhoneTap.numberOfTapsRequired = 1;
        callPhoneTap.numberOfTouchesRequired = 1;
        [phoneIcon addGestureRecognizer:callPhoneTap];
        
        UIView *sepLine = [[UIView alloc] initWithFrame:CGRectMake(phoneCallIconX - distance + 1, shopImageY, 1.0, shopImageH)];
        sepLine.backgroundColor = [UIColor colorWithWhite:225.0 / 255.0 alpha:1.0];
        [bgImageView addSubview:sepLine];
        
        CGFloat shopNameLabelX = shopImageX + 5 + shopImageW;
        CGFloat shopNameLabelW = imageW - shopNameLabelX - (phoneCallIconW + 2 * distance);
        CGFloat shopNameLabelH = shopImageH / 2.0;
        CGFloat shopNameLabelY = shopImageY;
        
        CGRect shopNameFrame = CGRectMake(shopNameLabelX, shopNameLabelY - 5, shopNameLabelW, shopNameLabelH);
        
        shopNameLabel = [[UILabel alloc] initWithFrame:shopNameFrame];
        shopNameLabel.textColor = [UIColor colorWithWhite:100.0 / 255.0 alpha:1.0];
        shopNameLabel.backgroundColor = [UIColor clearColor];
        [bgImageView addSubview:shopNameLabel];
        [shopNameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
        
        UILabel *orderTip = [[UILabel alloc] initWithFrame:CGRectMake(shopNameLabelX, shopNameLabelY + shopNameLabelH + 5, 65, shopNameLabelH)];
        orderTip.textColor = [UIColor colorWithWhite:153.0 / 255.0 alpha:1.0];
        orderTip.backgroundColor = [UIColor clearColor];
        [bgImageView addSubview:orderTip];
        [orderTip setText:@"网店数量:"];
        [orderTip setFont:[UIFont systemFontOfSize:14.0]];
        
        shopNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(orderTip.frame.origin.x + orderTip.frame.size.width, shopNameLabelY + shopNameLabelH + 2, 100, shopNameLabelH)];
        shopNumberLabel.backgroundColor = [UIColor clearColor];
        shopNumberLabel.textColor = [UIColor colorWithRed:255.0 / 255.0 green:139.0 / 255.0 blue:61.0 / 255.0 alpha:1.0];
        [bgImageView addSubview:shopNumberLabel];
        [shopNumberLabel setFont:[UIFont systemFontOfSize:25.0]];
        
        UIView *sec_sepLine = [[UIView alloc] initWithFrame:CGRectMake(shopImageX, 2 * shopImageY + shopImageH, imageW - 2 * shopImageX, 1.0)];
        sec_sepLine.backgroundColor = [UIColor colorWithWhite:225.0 / 255.0 alpha:1.0];
        [bgImageView addSubview:sec_sepLine];
        
        CGFloat labelH = imageH - 2 * shopImageY - shopImageH;
        CGFloat labelY = 2 * shopImageY + shopImageH;
        CGFloat labelX = shopImageX;
        
        UILabel *realTip = [[UILabel alloc] initWithFrame:CGRectMake(labelX, labelY, 60, labelH)];
        realTip.backgroundColor = [UIColor clearColor];
        realTip.textColor = [UIColor colorWithWhite:153.0 / 255.0 alpha:1.0];
        [bgImageView addSubview:realTip];
        [realTip setText:@"联系人:"];
        [realTip setFont:TEXTFONT];
        
        realNameLabel = [[UILabel alloc] init];
        realNameLabel.frame = CGRectMake(realTip.frame.origin.x + realTip.frame.size.width, labelY, imageW / 2.0 - (realTip.frame.origin.x + realTip.frame.size.width), labelH);
        realNameLabel.backgroundColor = [UIColor clearColor];
        realNameLabel.textColor = [UIColor colorWithWhite:153.0 / 255.0 alpha:1.0];
        [realNameLabel setFont:TEXTFONT];
        [bgImageView addSubview:realNameLabel];
        
        mobileLabel = [[UILabel alloc] init];
        mobileLabel.frame = CGRectMake(imageW / 2.0, labelY, 150, labelH);
        mobileLabel.backgroundColor = [UIColor clearColor];
        mobileLabel.textAlignment = NSTextAlignmentLeft;
        mobileLabel.textColor = [UIColor colorWithWhite:153.0 / 255.0 alpha:1.0];
        [mobileLabel setFont:TEXTFONT];
        [bgImageView addSubview:mobileLabel];

    }
    return self;
}

- (void)callShop:(UITapGestureRecognizer *)tap
{
    NSString *phoneString = [NSString stringWithFormat:@"%@",[shopDict valueForKey:@"Mobile"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"店铺电话:%@",phoneString] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert addButtonWithTitle:@"拨打"];
    [alert setTag:12];
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *phoneString = [NSString stringWithFormat:@"%@",[shopDict valueForKey:@"Mobile"]];
    if ([alertView tag] == 12 ) {    // it's the Error alert
        NSString *telUrl = [NSString stringWithFormat:@"tel://%@",phoneString];
        if(buttonIndex==1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telUrl]];
        }
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
