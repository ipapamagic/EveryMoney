//
//  ComputeView.h
//  EverMoney
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ComputeViewDelegate;
@interface ComputeView : UIView <UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate>
{
    
    IBOutlet UITableView *computeTableView;
    IBOutlet UILabel *titleTagLabel;
    IBOutlet UILabel *totalMoneyLabel;
}
- (IBAction)onLastMonth:(UIButton *)sender;
- (IBAction)onNextMonth:(UIButton *)sender;
-(void)reloadData;


@end


@protocol ComputeViewDelegate <NSObject>


@end