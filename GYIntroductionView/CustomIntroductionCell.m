//
//  CustomIntroductionCell.m
//  GYIntroductionView
//
//  Created by qm on 2018/7/3.
//  Copyright © 2018年 qm. All rights reserved.
//

#import "CustomIntroductionCell.h"

@implementation CustomIntroductionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (IBAction)handleEnter {
    if ([self.delegate respondsToSelector:@selector(didClickEnter)]) {
        [self.delegate didClickEnter];
    }
    
}


- (IBAction)handleSkip {
    if ([self.delegate respondsToSelector:@selector(didClickSkip)]) {
        [self.delegate didClickSkip];
    }
}



@end
