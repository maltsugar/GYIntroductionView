//
//  CustomIntroductionCell.h
//  GYIntroductionView
//
//  Created by qm on 2018/7/3.
//  Copyright © 2018年 qm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomIntroductionCellDelegate <NSObject>

@optional
- (void)didClickSkip;

- (void)didClickEnter;

@end



@interface CustomIntroductionCell : UICollectionViewCell



@property (nonatomic, assign) id<CustomIntroductionCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *skip;
@property (weak, nonatomic) IBOutlet UIButton *enter;

@end
