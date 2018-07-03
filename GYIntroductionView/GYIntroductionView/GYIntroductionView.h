//
//  GYIntroductionView.h
//  GYIntroductionView
//
//  Created by qm on 2018/7/2.
//  Copyright © 2018年 qm. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYIntroductionView;
@protocol GYIntroductionDataSource <NSObject>

@required
- (__kindof UICollectionViewCell *)introductionView:(GYIntroductionView *)introductionView cellForItemAtIndex:(NSIndexPath *)indexPath;

@end

@protocol GYIntroductionDelegate <NSObject>

@optional
- (void)introductionViewDidClickEnterAction:(GYIntroductionView *)introductionView;
- (void)introductionView:(GYIntroductionView *)introductionView didClickPageIndexPath:(NSIndexPath *)indexPath;


@end


typedef void(^GYEnterAction)(void);

@interface GYIntroductionView : UIView

@property (nonatomic, strong) UICollectionView *introlCollectionView;
@property (nonatomic, assign) id<GYIntroductionDelegate> delegate;
@property (nonatomic, assign) id<GYIntroductionDataSource> dataSource;
@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, assign) BOOL autoLoopPlayVideo; // default YES
@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic,   copy) GYEnterAction enterBlock;

/**
 Create an instance using only the image. The image defaults to AspectFill. Different devices will fill up, but they will be cropped. If you only use a set of images, pay attention to the space around them. Or according to the current iphone devices, you can use 3 sets of pictures。
 The iPad devices needs to be processed separately.
 
 只用图片创建实例，图片默认AspectFill，不同设备都会填满，但是有的会裁剪一些，如果只用一套图，注意周围空隙。或者根据目前的iphone设备，你可以用3套图。
 iPad需要单独处理。
 320:480            2:3
 640:1136           9:16
 750:1334           9:16
 1242:2208          9:16
 1125:2436          9:19.5
 
 
 ===============================
 iPad               3:4
 */
- (instancetype)initWithImgNames:(NSArray <NSString *>*)imgNames bgImgNames:(NSArray <NSString *>*)bgNames;




/**
 video

 @param videoURL video file URL
 @param volume 0 ~ 1
 @param imgNames front image name
 */
- (instancetype)initWithVideoURL:(NSURL *)videoURL volume:(float)volume imgNames:(NSArray <NSString *>*)imgNames;





// custom collectionView cell，DO NOT forget to register your cell with intrrolCollectionView
// 自定义 collectionView cell， 千万别忘了 使用introlCollectionView注册你的cell
- (instancetype)initWithImgCount:(NSUInteger)count andDataSource:(id <GYIntroductionDataSource>)dataSource;


@end


