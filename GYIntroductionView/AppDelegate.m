//
//  AppDelegate.m
//  GYIntroductionView
//
//  Created by qm on 2018/7/2.
//  Copyright © 2018年 qm. All rights reserved.
//

#import "AppDelegate.h"
#import "GYIntroductionView.h"
#import "CustomIntroductionCell.h"


@interface AppDelegate ()<GYIntroductionDelegate, GYIntroductionDataSource, CustomIntroductionCellDelegate>

@property (nonatomic, strong) GYIntroductionView *introductionView;
@property (nonatomic, strong) NSArray *imgNames;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    

    // storyboard should delay 0.1s
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self example2];
    });
    
    
    return YES;
}


- (void)example0
{
    NSArray *imageNames = @[@"img_index_01bg", @"img_index_02bg", @"img_index_03bg"];
    GYIntroductionView *introductionView = [[GYIntroductionView alloc] initWithImgNames:imageNames bgImgNames:nil];
    introductionView.pageControl.frame = CGRectMake(0, 0, 100, 50);
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
        NSLog(@"点击进入");
    }];
    
}

- (void)example1
{
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
}
// GYIntroductionDelegate
- (void)introductionViewDidClickEnterAction:(GYIntroductionView *)introductionView
{
    NSLog(@"代理回调 点击进入");
    
    [_introductionView removeFromSuperview];
    _introductionView = nil;
    
}
- (void)introductionView:(GYIntroductionView *)introductionView didClickPageIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", (int)indexPath.item);
}





- (void)example2
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"intro_video" ofType:@"mp4"];
    NSURL *videoURL = [NSURL fileURLWithPath:filePath];
    NSArray *coverImageNames = @[@"img_index_01txt", @"img_index_02txt", @"img_index_03txt"];
    
    GYIntroductionView *introductionView = [[GYIntroductionView alloc] initWithVideoURL:videoURL volume:1 imgNames:coverImageNames];
    [self.window addSubview:introductionView];
    _introductionView = introductionView;
    
}


#pragma mark- example3
- (void)example3
{
    _imgNames = @[@"img_index_01bg", @"img_index_02bg", @"img_index_03bg"];
    
    GYIntroductionView *introductionView = [[GYIntroductionView alloc] initWithImgCount:_imgNames.count andDataSource:self];
    introductionView.pageControl.frame = CGRectMake(0, 0, 100, 50);
    
    // ⚠️⚠️DO NOT forget to register your cell with intrrolCollectionView⚠️⚠️
    [introductionView.introlCollectionView registerNib:[UINib nibWithNibName:@"CustomIntroductionCell" bundle:nil] forCellWithReuseIdentifier:@"CustomIntroductionCell"];
    
    [self.window addSubview:introductionView];
    _introductionView = introductionView;
    
    
}

// GYIntroductionDataSource
- (__kindof UICollectionViewCell *)introductionView:(GYIntroductionView *)introductionView cellForItemAtIndex:(NSIndexPath *)indexPath
{
    CustomIntroductionCell *cell = [introductionView.introlCollectionView dequeueReusableCellWithReuseIdentifier:@"CustomIntroductionCell" forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.item == _imgNames.count - 1) {
        // the last one
        cell.enter.hidden = NO;
    }else
    {
        cell.enter.hidden = YES;
    }
    
    cell.imgView.image = [UIImage imageNamed:_imgNames[indexPath.item]];
    
    
    return cell;
}


// CustomIntroductionCellDelegate
- (void)didClickSkip
{
    NSLog(@"点击跳过");
}

- (void)didClickEnter
{
    NSLog(@"点击进入");
}























- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
