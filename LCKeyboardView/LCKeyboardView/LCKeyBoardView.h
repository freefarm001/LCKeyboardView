//
//  LCKeyBoardView.h
//  KeyBoardView
//
//  Created by lc on 2017/5/5.
//  Copyright © 2017年 liuchang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *不被键盘遮挡的控件*
 
 弹出键盘时：
 如果设置了superScrollView，会自动调整superScrollView的偏移量。
 没有设置superScrollView，则寻找上层可能存在的scollview。如果存在，则调整找到的scollview的偏移量，如果不存在，则根据autoChangeFrame的值判断是否要调整自身的frame。
 */

@interface LCKeyBoardView : UIView

- (instancetype)initWithFrame:(CGRect)frame __attribute__((unavailable));
- (instancetype)init __attribute__((unavailable));

/**
 实例方法
 
 @param frame frame
 @param inputView 用于输入的view（UITextView或者UITextField）
 @return <#return value description#>
 */
- (instancetype)initWithFrame:(CGRect)frame andInputView:(UIView *)inputView;

/** 键盘消失时是否自动隐藏view（默认是NO） */
@property (assign, nonatomic) BOOL autoHidden;

/** 没有指定和找到父scrollview时，是否需要自动调整自身的frame（适用于单独弹出的输入框。其他情况不推荐，因为会影响到其他控件的布局。默认是NO） */
@property (assign, nonatomic) BOOL autoChangeFrame;

/** 指定的父控件（键盘弹出时调整父控件的偏移量） */
@property (weak  , nonatomic) UIScrollView *superScrollView;

@end

@interface UIView (LCKBSuperScrollView)

/** 寻找上层的存在的scrollview */
- (UIScrollView *)findSuperScrollView;

@end
