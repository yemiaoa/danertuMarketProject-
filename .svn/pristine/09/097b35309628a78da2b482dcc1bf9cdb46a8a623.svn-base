//  NTalkerModalWebViewController.h
//  CustomerServerSDK2
//
//  Created by NTalker on 15/9/3.
//  Copyright (c) 2015年 NTalker. All rights reserved.


#import <UIKit/UIKit.h>

enum {
    SVWebViewControllerAvailableActionsNone             = 0,
    SVWebViewControllerAvailableActionsOpenInSafari     = 1 << 0,
    SVWebViewControllerAvailableActionsMailLink         = 1 << 1,
    SVWebViewControllerAvailableActionsCopyLink         = 1 << 2
};

typedef NSUInteger NTalkerWebViewControllerAvailableActions;


@class NTalkerWebViewController;

@interface NTalkerModalWebViewController : UINavigationController

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL *)URL;

@property (nonatomic, strong) UIColor *barsTintColor;
@property (nonatomic, readwrite) NTalkerWebViewControllerAvailableActions availableActions;

@end
