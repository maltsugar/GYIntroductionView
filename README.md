# GYIntroductionView
![](https://img.shields.io/badge/platform-iOS-red.svg)&nbsp;![](https://img.shields.io/badge/language-Objective--C-orange.svg)&nbsp;[![CocoaPods](http://img.shields.io/cocoapods/v/GYIntroductionView.svg?style=flat)](http://cocoapods.org/pods/GYIntroductionView)&nbsp;![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)


### [English](https://github.com/maltsugar/GYIntroductionView/blob/master/README_en.md)
App 启动引导页 新特性介绍，App launch guide page Introduction to new features


# App 启动介绍页
网上的轮子搜了搜不好用，灵活度不高，特来写一个支持任意自定义的。我一直认为无论怎么参考市面上APP的效果，也不可能模仿的完。所以写一些工具类的时候最重要的原则就是能灵活自定义，将具体的实现交给开发者，让他们想怎么做都行。像我的另外两个库（[RollingNotice](https://github.com/maltsugar/RollingNotice),[CustomPopoverView](https://github.com/maltsugar/CustomPopoverView)），也是这一原则，以后我做小组件也会尽量以这个原则作为第一标准，这样才算是一个“体贴”的库

## 版本记录
- 1.0.1 修复#1，修复iPhone X，只有前景图时，滑动残影的bug


## 这款启动视图，首先模仿几个特别典型的效果，至于没有的效果，完全交给你自由发挥了😬


素材和视频背景播放的方式来自[ZWIntroductionViewController](https://github.com/squarezw/ZWIntroductionViewController)，感谢作者。

## 用法
- 手动下载，将`GYIntroductionView`拖进项目
- Cocoapods: `pod 'GYIntroductionView'`

#### 普通用法
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
    [enterBtn setTitle:@"立即进入" forState:UIControlStateNormal];
    introductionView.enterButton = enterBtn;
    
    [introductionView setEnterBlock:^{
        NSLog(@"block 点击进入");
    }];
    
    introductionView.delegate = self;
    
```
#### 自定义
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
