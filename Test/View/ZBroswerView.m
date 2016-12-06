//
//  ZBroswerView.m
//  Test
//
//  Created by huanxin xiong on 2016/11/30.
//  Copyright © 2016年 xiaolu zhao. All rights reserved.
//
#define Screen_BOUNDS   [UIScreen mainScreen].bounds
#define Screen_W        [UIScreen mainScreen].bounds.size.width
#define Screen_H        [UIScreen mainScreen].bounds.size.height
#define SpaceWidth      10 // 图片距离左右间距

#import "ZBroswerView.h"
#import "ZImageView.h"

@interface ZBroswerView ()<ZImageViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *numberLabel;

@end

@implementation ZBroswerView

- (instancetype)initWithImageArray:(NSArray *)imageArray currentIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.imageArray = imageArray;
        self.index = index;
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews
{
    int index = 0;
    for (UIImage *image in self.imageArray) {
        ZImageView *imageView = [[ZImageView alloc] init];
        imageView.delegate = self;
        imageView.image = image;
        imageView.tag = index;
        [self.scrollView addSubview:imageView];
        index ++;
    }
}

#pragma mark - Getter
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:Screen_BOUNDS];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake((Screen_W + 2*SpaceWidth) * self.imageArray.count, Screen_H);
        _scrollView.contentOffset = CGPointMake(Screen_W * self.index, 0);
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        [self numberLabel];
    }
    return _scrollView;
}

- (UILabel *)numberLabel
{
    if (_numberLabel == nil) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, Screen_W, 40)];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.index+1, self.imageArray.count];
        [self addSubview:_numberLabel];
    }
    return _numberLabel;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / Screen_W;
    self.index = index;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass(obj.class) isEqualToString:@"ZImageView"]) {
            ZImageView *imageView = (ZImageView *)obj;
            [imageView resetView];
        }
    }];
    self.numberLabel.text = [NSString stringWithFormat:@"%ld/%ld", self.index+1, self.imageArray.count];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 主要为了设置每个图片的间距，并且使图片铺满整个屏幕，实际上就是scrollview每一页的宽度是屏幕宽度+2*Space居中，图片左边从每一页的Space开始，达到间距且居中效果
    _scrollView.bounds = CGRectMake(0, 0, Screen_W + 2 * SpaceWidth, Screen_H);
    _scrollView.center = self.center;
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(SpaceWidth + (Screen_W+20) * idx, 0, Screen_W, Screen_H);
    }];
}

- (void)showInCell:(UICollectionViewCell *)cell
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = CGRectMake(0, 0, Screen_W, Screen_H);
    self.center = cell.center;
    self.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:.3 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.center = window.center;
        [window addSubview:self];
    }];
}

#pragma mark - ZImageViewDelegate
- (void)stImageViewSingleClick:(ZImageView *)imageView
{
    [self dismiss];
}

- (void)dismiss
{
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1.5, 1.5);
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end















