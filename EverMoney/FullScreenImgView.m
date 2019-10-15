//
//  FullScreenImgView.m
//  EverMoney
//
//  Created by  on 12/7/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FullScreenImgView.h"

@implementation FullScreenImgView
@synthesize imageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)onClose:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^(){
        self.transform = CGAffineTransformMakeTranslation(self.frame.size.width, 0);
    }completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}
@end
