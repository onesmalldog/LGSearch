//
//  LGSearch.m
//  LGAppTool
//
//  Created by 东途 on 2016/11/29.
//  Copyright © 2016年 displayten. All rights reserved.
//

#import "LGSearch.h"

@interface LGSearch() <UITextFieldDelegate>
@property (weak, nonatomic) UITextField *textField;
@end
@implementation LGSearch {
    __weak UIViewController *_vc;
    BOOL _hadNav;
    UIBarButtonItem *_rightItem;
    UIView *_titleView;
}
+ (instancetype)lg_searchWithViewController:(UIViewController *)vc {
    return [[self alloc] initWithViewController:vc];
}
- (instancetype)initWithViewController:(UIViewController *)vc {
    if (self = [super init]) {
        if (vc) {
            _vc = vc;
            if (vc.navigationController) {
                _hadNav = true;
            }
            else _hadNav = false;
            
            self.backgroundColor = [UIColor whiteColor];
        }
    }
    return self;
}
- (void)layoutSubviews {
    
    if (!self.cancelBtnText) {
        self.cancelBtnText = @"Cancel";
    }
    if (!self.font_size) {
        self.font_size = 17;
    }
    if (!self.viewRatio) {
        self.viewRatio = 0.8;
    }
    if (_hadNav) {
        _vc.navigationItem.hidesBackButton = YES;
        _rightItem = _vc.navigationItem.rightBarButtonItem;
        _vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:self.cancelBtnText style:UIBarButtonItemStylePlain target:self action:@selector(cancelBtnClick)];
        [_vc.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:self.font_size]} forState:UIControlStateNormal];
        _titleView = _vc.navigationItem.titleView;
        UITextField *textField = [self create_txtfield];
        _vc.navigationItem.titleView = textField;
        self.textField = textField;
    }
    else {
        UITextField *textField = [self create_nav];
        self.textField = textField;
    }
    
    if (self.enableHotSearch) {
        
        [self create_hotSearchView];
    }
}
- (void)setContentTitleView:(UIView *)contentTitleView {
    _contentTitleView = contentTitleView;
    
//    _contentTitleView.frame = CGRectMake(30, 0, self.contentTitleView.frame.size.width, self.contentTitleView.frame.size.height);
    [self addSubview:_contentTitleView];
}
- (void)create_hotSearchView {
    
    
    
    UIScrollView *sc = [[UIScrollView alloc] init];
    
    if (!self.contentTitleView) {
        sc.frame = CGRectMake(0, 64+60, self.frame.size.width, self.frame.size.height-64);
    }
    else {
        sc.frame = CGRectMake(0, CGRectGetMaxY(self.contentTitleView.frame), self.frame.size.width, self.frame.size.height-64);
    }
    [self addSubview:sc];
    if (!self.hotBgColor) {
        self.hotBgColor = [UIColor lightGrayColor];
    }
    if (!self.margin) {
        self.margin = 10;
    }
    if (!self.labelHeight) {
        self.labelHeight = 30;
    }
    if (!self.hotSearchs.count) {
        return;
    }
    
    UILabel *last;
    int column = 0;
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i<self.hotSearchs.count; i++) {
        NSString *name = self.hotSearchs[i];
        UILabel *label = [[UILabel alloc] init];
        label.text = name;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = self.hotBgColor;
        CGFloat width = [self get_WidthWithContent:name height:self.labelHeight font:self.font_size];
        if (i > 0) {
            last = array[i-1];
        }
        if (!last) {
            label.frame = CGRectMake(self.margin, 0, width, self.labelHeight);
        }
        else if ((sc.frame.size.width-(column*(width+2*self.margin))) > 10) {
            label.frame = CGRectMake(CGRectGetMaxX(last.frame)+self.margin, last.frame.origin.y, width, self.labelHeight);
        }
        else {
            label.frame = CGRectMake(self.margin, CGRectGetMaxY(last.frame)+self.margin, width, self.labelHeight);
            column = 0;
        }
        
        [sc addSubview:label];
        [array addObject:label];
        column++;
    }
    last = array.lastObject;
    if ((CGRectGetMaxY(last.frame)+last.frame.size.height) > sc.frame.size.height) {
        sc.contentSize = CGSizeMake(0, CGRectGetMaxY(last.frame)+last.frame.size.height+1);
    }
    else sc.contentSize = CGSizeMake(0, sc.frame.size.height+1);
}
- (CGFloat)get_WidthWithContent:(NSString *)content height:(CGFloat)height font:(CGFloat)font {
    CGRect rect;
    rect = [content boundingRectWithSize:CGSizeMake(999, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return rect.size.width+1;
}
- (void)cancelBtnClick {
    if (_hadNav) {
        if (_rightItem) {
            _vc.navigationItem.rightBarButtonItem = _rightItem;
        }
        else _vc.navigationItem.rightBarButtonItem = nil;
        if (_titleView) {
            _vc.navigationItem.titleView = _titleView;
        }
        else _vc.navigationItem.titleView = nil;
    }
    [self removeFromSuperview];
}
- (UITextField *)create_nav {
    UIView *view = [UIView new];
    view.frame = CGRectMake(0, 0, self.frame.size.width, 64);
    [self addSubview:view];
    UITextField *textField = [self create_txtfield];
    [view addSubview:textField];
    UIButton *ritBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    ritBtn.frame = CGRectMake(CGRectGetMaxX(textField.frame), 20, textField.frame.size.width/self.viewRatio*(1-self.viewRatio), view.frame.size.height-20);
    [ritBtn setTitle:self.cancelBtnText forState:UIControlStateNormal];
    [ritBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [ritBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:ritBtn];
    view.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:0.8];
    return textField;
}
- (UITextField *)create_txtfield {
    
    UITextField *textField = [[UITextField alloc]init];
    textField.borderStyle = UITextBorderStyleNone;
    [textField setBackground:self.bgImage];
    textField.placeholder = @"Search";
    textField.font = [UIFont systemFontOfSize:self.font_size];
    textField.textColor = [UIColor blackColor];
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.secureTextEntry = NO;
    textField.textAlignment = NSTextAlignmentLeft;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.adjustsFontSizeToFitWidth = YES;
    textField.returnKeyType = UIReturnKeySearch;
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
    [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    textField.delegate = self;
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.searchImage.size.width, self.searchImage.size.height)];
    UIImageView *imageV = [[UIImageView alloc]init];
    imageV.image = self.searchImage;
    imageV.frame = leftView.bounds;
    [leftView addSubview:imageV];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.frame = CGRectMake(0, 20, self.frame.size.width*self.viewRatio, 44);
    [textField becomeFirstResponder];
    return textField;
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *result;
    if (string.length == 0) { // delete
        
        NSMutableString *searchStr = [NSMutableString stringWithString:textField.text];
        [searchStr deleteCharactersInRange:NSMakeRange(textField.text.length-1, 1)];
        result = searchStr;
    }
    else { // input
        
        NSString *searchStr = [NSString stringWithFormat:@"%@%@", textField.text, string];
        result = searchStr;
    }
    if (self.inputCallBack) {
        self.inputCallBack(result);
    }
    
    return YES;
}
@end
