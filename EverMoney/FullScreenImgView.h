//
//  FullScreenImgView.h
//  EverMoney
//
//  Created by  on 12/7/18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FullScreenImgView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)onClose:(UIButton *)sender;

@end
