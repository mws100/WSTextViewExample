# WSTextViewExample
OC实现的高度自适应的Textview

### 背景
以前项目中发表评论的功能一直用的是固定高度的UITextView，用户通过上下滚动来查看输入的内容，体验并不好。最近在优化使用体验，自己封装了个自适应高度的TextView组件。先看下效果：

[gif效果图有点大，这里不能显示，可到简书查看，😀](http://www.jianshu.com/p/b8d65ea1afb1)

### 设计思路
+ 继承自UITextView
+ 外界可以设置最多显示的行数
+ 自身高度发生改变时，以block的形式通知外界

### 功能实现
```
//  WSTextView.h
#import <UIKit/UIKit.h>

@interface WSTextView : UITextView

/** 高度改变回调 */
@property (nonatomic, copy) void(^ws_textHeightChangeHandle)(NSString *text, CGFloat height);

/** 最大行数，超出最大行数时 以滚动的形式展示内容 */
@property (nonatomic, assign) NSUInteger maxNumberOfLines;

@end
```

```
//  WSTextView.m
#import "WSTextView.h"

@interface WSTextView ()
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat currentHeight;
@end

@implementation WSTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    self.layer.borderWidth = 1.f / [UIScreen mainScreen].scale;
    self.layer.cornerRadius = 5.f;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
}

- (void)textDidChange {
    CGFloat height = ceil([self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.font} context:nil].size.height);
    height = height + self.textContainerInset.top + self.textContainerInset.bottom;
    
    if (_currentHeight != height) {
        _currentHeight = height;
        self.scrollEnabled = height > _maxHeight && _maxHeight > 0;
        if (self.ws_textHeightChangeHandle && !self.scrollEnabled) {
            self.ws_textHeightChangeHandle(self.text, height);
        }
    }
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines {
    _maxNumberOfLines = maxNumberOfLines;
    _maxHeight = ceilf(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

```

代码也很简单能看懂，核心代码就是高度的计算，计算的时候不能忘了加上textView的上下inset。

2017.11.15：update-已添加placeHolder的功能
