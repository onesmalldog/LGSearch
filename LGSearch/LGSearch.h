//
//  LGSearch.h
//  LGAppTool
//
//  Created by 东途 on 2016/11/29.
//  Copyright © 2016年 displayten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGSearch : UIView
#pragma mark Base
+ (instancetype)lg_searchWithViewController:(UIViewController *)vc;

@property (assign,  nonatomic) CGFloat font_size;
@property (assign,  nonatomic) CGFloat viewRatio;
@property (strong,  nonatomic) UIImage *searchImage;
@property (strong,  nonatomic) UIImage *bgImage;
@property ( copy,   nonatomic) NSString *cancelBtnText;
@property ( copy,   nonatomic) void(^inputCallBack)(NSString *input);

#pragma mark Hot Search
@property (assign,  nonatomic) BOOL enableHotSearch; // default is NO
@property ( copy,   nonatomic) NSArray <NSString *>* hotSearchs;
@property (strong,  nonatomic) UIColor *hotBgColor;
@property ( weak,   nonatomic) UIView *contentTitleView;
@property (assign,  nonatomic) CGFloat margin;
@property (assign,  nonatomic) CGFloat labelHeight;
@end
