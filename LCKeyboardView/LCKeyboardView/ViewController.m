//
//  ViewController.m
//  LCKeyboardView
//
//  Created by lc on 2017/6/8.
//  Copyright © 2017年 liuchang. All rights reserved.
//

#import "ViewController.h"
#import "LCKeyBoardView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //没有superScrollView
//    [self prepareUI1];
    
    //有superScrollView
    [self prepareUI2];
}

- (void)prepareUI1 {
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    textView.backgroundColor = [UIColor orangeColor];
    LCKeyBoardView *keyboardView = [[LCKeyBoardView alloc] initWithFrame:CGRectMake(20, 300, 200, 150) andInputView:textView];
    [self.view addSubview:keyboardView];
    keyboardView.autoChangeFrame = YES;
}

- (void)prepareUI2 {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    textView.backgroundColor = [UIColor orangeColor];
    LCKeyBoardView *keyboardView = [[LCKeyBoardView alloc] initWithFrame:CGRectMake(20, 300, 200, 150) andInputView:textView];
    [scrollView addSubview:keyboardView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
