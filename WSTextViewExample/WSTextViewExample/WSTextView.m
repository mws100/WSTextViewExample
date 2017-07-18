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
