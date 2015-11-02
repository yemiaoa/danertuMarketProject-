//
//  UnderLineLabel.m
//  单耳兔
//
//  Created by yang on 15/7/6.
//  Copyright (c) 2015年 珠海单耳兔电子商务有限公司. All rights reserved.
//

//--带删除线的Label
#import "UnderLineLabel.h"

@implementation UnderLineLabel


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGSize fontSize =[self.text sizeWithFont:self.font
                                    forWidth:self.frame.size.width
                               lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGContextSetStrokeColorWithColor(ctx, self.textColor.CGColor);  // set as the text's color
    CGContextSetLineWidth(ctx, 0.6f);
    
    CGPoint leftPoint = CGPointMake(0,
                                    self.frame.size.height/2);
    CGPoint rightPoint = CGPointMake(fontSize.width,
                                     self.frame.size.height/2);
    CGContextMoveToPoint(ctx, leftPoint.x, leftPoint.y);
    CGContextAddLineToPoint(ctx, rightPoint.x, rightPoint.y);
    CGContextStrokePath(ctx);
}


@end
