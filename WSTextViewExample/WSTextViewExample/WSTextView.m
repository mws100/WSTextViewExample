//
//  WSTextView.m
//  WSTextViewExample
//
//  Created by 马文帅 on 2017/7/7.
//  Copyright © 2017年 mawenshuai. All rights reserved.
//

#import "WSTextView.h"

@interface WSTextView ()
@property (nonatomic, assign) CGFloat maxHeight;
@property (nonatomic, assign) CGFloat currentHeight;
@property (nonatomic, strong) UILabel *placeHolderLabel;
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
    
    [self addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    UIFont *newFont = change[NSKeyValueChangeNewKey];
    self.placeHolderLabel.font = newFont;
    self.placeHolderLabel.frame = CGRectMake(self.textContainerInset.left + 7, self.textContainerInset.top, self.bounds.size.width, self.font.lineHeight);
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
    
    self.placeHolderLabel.hidden = (self.text.length > 0);
}

- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines {
    _maxNumberOfLines = maxNumberOfLines;
    _maxHeight = ceilf(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self removeObserver:self forKeyPath:@"font"];
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    _placeHolder = [_placeHolder copy];
    self.placeHolderLabel.text = placeHolder;
    [self addSubview:self.placeHolderLabel];
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    _placeHolderColor = placeHolderColor;
    _placeHolderLabel.textColor = placeHolderColor;
}

- (UILabel *)placeHolderLabel {
    if (!_placeHolderLabel) {
        _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.textContainerInset.left + 7, self.textContainerInset.top, self.bounds.size.width, self.font.lineHeight)];
        _placeHolderLabel.font = self.font;
    }
    return _placeHolderLabel;
}

@end

