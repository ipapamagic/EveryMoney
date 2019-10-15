//
//  ComputeTableViewCell.h
//  EverMoney
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EverNoteController.h"
@interface ComputeTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong,nonatomic) EDAMGuid noteID;
@end
