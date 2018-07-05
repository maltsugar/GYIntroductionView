//
//  GYIntroductionView.m
//  GYIntroductionView
//
//  Created by qm on 2018/7/2.
//  Copyright © 2018年 qm. All rights reserved.
//

#import "GYIntroductionView.h"
#import <AVFoundation/AVFoundation.h>

#define GYINTROL_SCREENSIZE \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)


@interface GYIntroductionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation GYIntroductionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgView = [[UIImageView alloc]init];
        _imgView.frame = self.bounds;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imgView];
        self.contentView.clipsToBounds = YES;
    }
    return self;
}
@end



@interface GYIntroductionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    float _lastContentOffsetX;
}
@property (nonatomic, assign) NSUInteger imgCount;
@property (nonatomic,   copy) NSArray *imageNames;
@property (nonatomic,   copy) NSArray *bgImageNames;


@property (nonatomic, strong) UIImageView *bgImgViewTop;
@property (nonatomic, strong) UIImageView *bgImgViewBottom;


// video
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, assign) float volume;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@end



static NSString *GYIntroductionViewCellIdentifier = @"GYIntroductionViewCellIdentifier";

@implementation GYIntroductionView

- (instancetype)initWithImgNames:(NSArray <NSString *>*)imgNames bgImgNames:(NSArray <NSString *>*)bgNames
{
    self = [super init];
    if (self) {
        self.imgCount = imgNames.count;
        self.imageNames = imgNames;
        self.bgImageNames = bgNames;
        [self setupIntroductionViews];
    
    }
    return self;
}

- (instancetype)initWithVideoURL:(NSURL *)videoURL volume:(float)volume imgNames:(NSArray <NSString *>*)imgNames
{
    self = [super init];
    if (self) {
        self.imgCount = imgNames.count;
        self.imageNames = imgNames;
        self.videoURL = videoURL;
        self.volume = volume;
        self.autoLoopPlayVideo = YES;
        [self setupIntroductionViews];
        
    }
    return self;
}

- (instancetype)initWithImgCount:(NSUInteger)count andDataSource:(id <GYIntroductionDataSource>)dataSource
{
    self = [super init];
    if (self) {
        self.imgCount = count;
        self.dataSource = dataSource;
        [self setupIntroductionViews];
    }
    return self;
}


#pragma mark- private
- (void)setupIntroductionViews
{
    CGRect fullFrame = CGRectMake(0, 0, GYINTROL_SCREENSIZE.width, GYINTROL_SCREENSIZE.height);
    self.backgroundColor = [UIColor whiteColor];
    self.frame = fullFrame;
    
    
    // video
    if (self.videoURL) {
        [self setupVideo];
    }
    
    if (self.bgImageNames.count) {
        [self addSubview:self.bgImgViewBottom];
        [self addSubview:self.bgImgViewTop];
        
        self.bgImgViewTop.frame = fullFrame;
        self.bgImgViewBottom.frame = fullFrame;
        
        [self resetBackgroudImageViewWithIndex:0 isScrollLeft:YES];
    }
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = GYINTROL_SCREENSIZE;
    flowLayout.minimumLineSpacing = 0.f;
    flowLayout.minimumInteritemSpacing = 0.f;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _introlCollectionView = [[UICollectionView alloc] initWithFrame:fullFrame collectionViewLayout:flowLayout];
    _introlCollectionView.delegate = self;
    _introlCollectionView.dataSource = self;
    _introlCollectionView.pagingEnabled = YES;
    _introlCollectionView.backgroundColor = [UIColor clearColor];
    _introlCollectionView.bounces = NO;
    _introlCollectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_introlCollectionView];
    
    if (!self.dataSource) {
        [_introlCollectionView registerClass:[GYIntroductionCell class] forCellWithReuseIdentifier:GYIntroductionViewCellIdentifier];
    }
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.numberOfPages = self.imgCount;
    
    if (CGRectEqualToRect(self.pageControl.frame, CGRectZero)) {
        _pageControl.bounds = CGRectMake(0, 0, 200, 30);
        _pageControl.center = CGPointMake(self.center.x, CGRectGetMaxY(fullFrame) - 50);
    }
    [_pageControl addTarget:self action:@selector(handlePageControlAction:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_pageControl];
    
}


- (void)setEnterButton:(UIButton *)enterButton
{
    _enterButton = enterButton;
    if (enterButton) {
        [enterButton addTarget:self action:@selector(hanldeEnterAction) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)hanldeEnterAction
{
    if ([self.delegate respondsToSelector:@selector(introductionViewDidClickEnterAction:)]) {
        [self.delegate introductionViewDidClickEnterAction:self];
    }
    
    if (self.enterBlock) {
        self.enterBlock();
    }
}


#pragma mark - video
- (void)setupVideo
{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.videoURL];
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    self.player.volume = self.volume;
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.playerLayer.frame = self.layer.bounds;
    [self.layer addSublayer:self.playerLayer];
    
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayDidEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.player.currentItem];
}

- (void)moviePlayDidEnd:(NSNotification*)notification{
    if (self.autoLoopPlayVideo) {
        // loop movie
        AVPlayerItem *item = [notification object];
        if (@available(iOS 11.0, *)){
            [item seekToTime:kCMTimeZero completionHandler:nil];
        }else
        {
            [item seekToTime:kCMTimeZero];
        }
        [self.player play];
    }
}

#pragma mark- helper
- (void)resetBackgroudImageViewWithIndex:(NSUInteger)index isScrollLeft:(BOOL)isleft
{
    if (index < self.bgImageNames.count) {
        self.bgImgViewTop.image = [UIImage imageNamed:self.bgImageNames[index]];
        self.bgImgViewTop.alpha = 1;
    }
    
    if (isleft) {
        if (index + 1 < self.bgImageNames.count) {
            self.bgImgViewBottom.image = [UIImage imageNamed:self.bgImageNames[index + 1]];
            self.bgImgViewBottom.alpha = 1;
        }
    }else
    {
        if (index - 1 < self.bgImageNames.count) {
            self.bgImgViewBottom.image = [UIImage imageNamed:self.bgImageNames[index - 1]];
            self.bgImgViewBottom.alpha = 1;
        }
    }
    
}


- (void)handlePageControlAction:(UIPageControl *)sender
{
    float width = GYINTROL_SCREENSIZE.width;
    [self.introlCollectionView setContentOffset:CGPointMake(sender.currentPage * width, 0) animated:YES];
}

#pragma mark- <UICollectionViewDelegate, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource) {
        UICollectionViewCell *cell = [self.dataSource introductionView:self cellForItemAtIndex:indexPath];
        return cell;
    }else
    {
        GYIntroductionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:GYIntroductionViewCellIdentifier forIndexPath:indexPath];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        NSString *imgName = self.imageNames[indexPath.item];
        cell.imgView.image = [UIImage imageNamed:imgName];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(introductionView:didClickPageIndexPath:)]) {
        [self.delegate introductionView:self didClickPageIndexPath:indexPath];
    }
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_enterButton) {
        if (indexPath.item == self.imgCount - 1) {
            // the last one
            [cell.contentView addSubview:_enterButton];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _lastContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float width = GYINTROL_SCREENSIZE.width;
    float origin = scrollView.contentOffset.x / width;
    NSInteger currentIdx = (NSInteger)floorf(origin);
    
    if (_lastContentOffsetX < scrollView.contentOffset.x) {
//        NSLog(@"向左滑动");
        [self resetBackgroudImageViewWithIndex:currentIdx isScrollLeft:YES];
        if (_bgImgViewTop) {
            _bgImgViewTop.alpha = 1 - ((origin - currentIdx)/0.5);
        }
        
    }else
    {
//        NSLog(@"向右滑动");
        currentIdx = (NSInteger)ceilf(origin);
        [self resetBackgroudImageViewWithIndex:currentIdx isScrollLeft:NO];
        if (_bgImgViewTop) {
            _bgImgViewTop.alpha = 1 - ((currentIdx - origin)/0.5);
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float width = GYINTROL_SCREENSIZE.width;
    NSInteger currentIdx = (NSInteger)floorf(scrollView.contentOffset.x / width);
    self.pageControl.currentPage = currentIdx;
}

#pragma mark- lazy
- (UIImageView *)bgImgViewTop
{
    if (nil == _bgImgViewTop) {
        _bgImgViewTop = [[UIImageView alloc]init];
        _bgImgViewTop.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImgViewTop;
}

- (UIImageView *)bgImgViewBottom
{
    if (nil == _bgImgViewBottom) {
        _bgImgViewBottom = [[UIImageView alloc]init];
        _bgImgViewBottom.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _bgImgViewBottom;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player pause];
    self.player = nil;
}

@end
