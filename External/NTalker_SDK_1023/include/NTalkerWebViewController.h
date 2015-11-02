//
//  NTalkerWebViewController.h
//
//  Created by NTalker on 15/9/3.
//  Copyright (c) 2015年 NTalker. All rights reserved.

#import <MessageUI/MessageUI.h>

#import "NTalkerModalWebViewController.h"

@interface NTalkerWebViewController : UIViewController

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithURL:(NSURL*)URL;

@property (nonatomic, readwrite) NTalkerWebViewControllerAvailableActions availableActions;

@end
