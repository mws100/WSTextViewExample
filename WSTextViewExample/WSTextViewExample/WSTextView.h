//
//  WSTextView.h
//  WSTextViewExample
//
//  Created by 马文帅 on 2017/7/7.
//  Copyright © 2017年 mawenshuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSTextView : UITextView

/** 高度改变 */
@property (nonatomic, copy) void(^ws_textHeightChangeHandle)(NSString *text, CGFloat height);
/** 最大行数，超出最大行数时 以滚动的形式展示内容 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;
/** placeHolder的颜色 */
@property (nonatomic, strong) UIColor *placeHolderColor;
/** placeHolder */
@property (nonatomic, copy) NSString *placeHolder;

@end

