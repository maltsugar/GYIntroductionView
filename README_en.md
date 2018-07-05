# GYIntroductionView
![](https://img.shields.io/badge/platform-iOS-red.svg)&nbsp;![](https://img.shields.io/badge/language-Objective--C-orange.svg)&nbsp;[![CocoaPods](http://img.shields.io/cocoapods/v/GYIntroductionView.svg?style=flat)](http://cocoapods.org/pods/GYIntroductionView)&nbsp;![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)


### [中文](https://github.com/maltsugar/GYIntroductionView/blob/master/README.md)
App 启动引导页 新特性介绍，App launch guide page Introduction to new features


# App Launching the introduction page
Online wheel search is not easy to use, and the flexibility is not high. Specially write a support for any customization. I always think that no matter how to refer to the effect of the APP on the market, it is impossible to imitate it. So the most important principle when writing some tool classes is that you can flexibly customize and give specific implementations to developers, so that they can do whatever they want. Like my other two libraries ([RollingNotice](https://github.com/maltsugar/RollingNotice), [CustomPopoverView](https://github.com/maltsugar/CustomPopoverView)), this principle is also the case. Doing small components will try to use this principle as the first standard, so that it is a "considered" library.


## This startup view first emulates a few typical typical effects. As for the effect, there is no effect, and you are completely free to play.


The way the material and video backgrounds are played is from [ZWIntroductionViewController] (https://github.com/squarezw/ZWIntroductionViewController), thanks to the author.


## usage
- manual，drag `GYIntroductionView ` in your project
- Cocoapods: `pod 'GYIntroductionView'`

#### for normal use
```
	NSArray *coverImageNames = @[@"img_index_01txt", @"img_index_02txt", @"img_index_03txt"];
    NSArray *backgroundImageNames = @[@"img_index_01bg", @"img_index_02bg", @"img_index_03bg"];
    
    GYIntroductionView *introductionView = [[GYIntroductionView alloc] initWithImgNames:coverImageNames bgImgNames:backgroundImageNames];
    [self.window addSubview:introductionView];
    _introductionView = introductionView;
    
    // enterButton and it's action
    // 进入按钮和进入按钮的回调
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.bounds = CGRectMake(0, 0, 200, 60);
    enterBtn.center = CGPointMake(self.window.center.x, CGRectGetMaxY(self.window.frame) - 160);
    enterBtn.backgroundColor = [UIColor redColor];
    [enterBtn setTitle:@"enter" forState:UIControlStateNormal];
    introductionView.enterButton = enterBtn;
    
    [introductionView setEnterBlock:^{
        NSLog(@"block enter action");
    }];
    
    introductionView.delegate = self;
    
```
#### custom cell
```
	_imgNames = @[@"img_index_01bg", @"img_index_02bg", @"img_index_03bg"];
    
    GYIntroductionView *introductionView = [[GYIntroductionView alloc] initWithImgCount:_imgNames.count andDataSource:self];
    introductionView.pageControl.frame = CGRectMake(0, 0, 100, 50);
    
    // ⚠️⚠️DO NOT forget to register your cell with intrrolCollectionView⚠️⚠️
    [introductionView.introlCollectionView registerNib:[UINib nibWithNibName:@"CustomIntroductionCell" bundle:nil] forCellWithReuseIdentifier:@"CustomIntroductionCell"];
    
    [self.window addSubview:introductionView];
    _introductionView = introductionView;
```



# demo
![](http://wx4.sinaimg.cn/mw690/72aba7efgy1fswqrtyvb5g208x0ga1gd.gif)

![](https://github.com/maltsugar/GYIntroductionView/blob/master/Untitled0.gif)
