//
//  ViewController.m
//  WSTextViewExample
//
//  Created by 马文帅 on 2017/7/7.
//  Copyright © 2017年 mawenshuai. All rights reserved.
//

#import "ViewController.h"
#import "WSTextView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet WSTextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewH;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //设置最大行数
    self.textView.maxNumberOfLines = 4;
    //设置提示内容
    self.textView.placeHolder = @"请输入内容";
    self.textView.placeHolderColor = [UIColor lightGrayColor];
    
    //高度改变的回调
    __weak typeof(self) wself = self;
    self.textView.ws_textHeightChangeHandle = ^(NSString *text, CGFloat height){
        NSLog(@"%f %@", height, text);
        
        //20是textView上下边距的和
        wself.bottomViewH.constant = height + 20.f;
        [UIView animateWithDuration:0.25 animations:^{
            [wself.view layoutIfNeeded];
        }];
        
    };
}

- (void)keyboardChange:(NSNotification *)note {
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    self.bottomViewBottom.constant = endFrame.origin.y != screenH ? endFrame.size.height:0;
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
