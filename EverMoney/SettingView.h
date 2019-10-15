//
//  SettingView.h
//  EverMoney
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingView : UIView
{
    IBOutletCollection(UITableViewCell) NSArray *tableCells;
}
- (IBAction)onSwitchCameraRoll:(UIButton *)sender;

@end
