//
//  LCKeyBoardView.m
//  KeyBoardView
//
//  Created by lc on 2017/5/5.
//  Copyright © 2017年 liuchang. All rights reserved.
//

#import "LCKeyBoardView.h"

@interface LCKeyBoardView ()

//用于输入的view（UITextView或者UITextField）
@property (strong, nonatomic) UIView *inputView;

/** 自己找到的父scollView */
@property (weak  , nonatomic) UIScrollView *seekedScrollView;

@end

@implementation LCKeyBoardView

static CGRect startFrame; //当前view的起始frame

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame andInputView:(UIView *)inputView {
    
    if (self = [super initWithFrame:frame]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
        
        if (inputView) {
            _inputView = inputView;
            [self addSubview:inputView];
        }
    }
    return self;
}

#pragma mark - notification

- (void)keyboardWillShow:(NSNotification *)notification {
    if (_inputView == nil || !_inputView.isFirstResponder) {
        return;
    }
    
    NSDictionary *userDict = notification.userInfo;
    double duration = [userDict[UIKeyboardAnimationDurationUserInfoKey] doubleValue]; //动画时间
    NSValue *endFrameValue = [userDict objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat endFrameHeight = endFrameValue.CGRectValue.size.height; //键盘的高度
    
    //调整给定的父scrollview的偏移量
    if (_superScrollView) {
        [self viewShowInScrollView:_superScrollView withKeyboardHeight:endFrameHeight andDuration:duration];
        return;
    }
    
    //调整自己寻找到的父scollView的偏移量
    if (self.seekedScrollView) {
        [self viewShowInScrollView:self.seekedScrollView withKeyboardHeight:endFrameHeight andDuration:duration];
        return;
    }
    
    //调整自身的frame
    if (_autoChangeFrame) {
        
        startFrame = self.frame;
        CGRect frame = self.frame;
        frame.origin.y = [UIScreen mainScreen].bounds.size.height - frame.size.height - endFrameHeight;
        self.hidden = NO;
        
        if (startFrame.origin.y <= frame.origin.y) {
            return;
        }
        
        __weak __typeof(self)wself = self;
        [UIView animateWithDuration:duration animations:^{
            __strong LCKeyBoardView *sself = wself;
            sself.frame = frame;
        }];
    }
}

// 在scrollview中时，设置scrollview的偏移量
- (void)viewShowInScrollView:(UIScrollView *)scrollView withKeyboardHeight:(CGFloat)keyboardHeight andDuration:(double)duration  {
    CGRect rect = [self convertRect:self.bounds toView:[UIApplication sharedApplication].keyWindow];
    CGFloat offsetY = CGRectGetMaxY(rect) - ([UIScreen mainScreen].bounds.size.height - keyboardHeight);
    
    if (offsetY <= 0) {
        return;
    }
    
    [UIView animateWithDuration:duration animations:^{
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, scrollView.contentOffset.y + offsetY)];
    }];
}

- (void)keyboardWillHidden:(NSNotification *)notification {
    if (_inputView == nil || !_inputView.isFirstResponder) {
        return;
    }
    
    NSDictionary *userDict = notification.userInfo;
    double duration = [userDict[UIKeyboardAnimationDurationUserInfoKey] doubleValue]; //动画时间
    
    //存在父scrollview
    if (_superScrollView || self.seekedScrollView) {
        return;
    }
    
    //调整自身的frame
    if (_autoChangeFrame) {
        
        if (startFrame.origin.y <= self.frame.origin.y) {
            return;
        }
        
        __weak __typeof(self)wself = self;
        [UIView animateWithDuration:duration animations:^{
            __strong LCKeyBoardView *sself = wself;
            sself.frame = startFrame;
        } completion:^(BOOL finished) {
            __strong LCKeyBoardView *sself = wself;
            sself.hidden = sself.autoHidden;
        }];
    }
}

#pragma mark - setter && getter

- (UIScrollView *)seekedScrollView {
    
    if (!_seekedScrollView) {
        _seekedScrollView = [self findSuperScrollView];
    }
    
    if (![_seekedScrollView isKindOfClass:[UIScrollView class]]) {
        return nil;
    }
    
    return _seekedScrollView;
}

- (void)setSuperScrollView:(UIScrollView *)superScrollView {
    
    if (![superScrollView isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    _superScrollView = superScrollView;
}

#pragma mark - dealloc

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation UIView (LCKBSuperScrollView)

- (UIScrollView *)findSuperScrollView {
    if (!self.superview) {
        return nil;
    }
    
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *)self.superview;
    } else {
        return [self.superview findSuperScrollView];
    }
}

@end
