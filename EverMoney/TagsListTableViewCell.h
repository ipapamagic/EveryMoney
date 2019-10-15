//
//  TagsListTableViewCell.h
//  EverMoney
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EverNoteController.h"
@interface TagsListTableViewCell : UITableViewCell
{
    

    IBOutlet UIImageView *iconImageView;
    IBOutlet UILabel *titleLabel;
    
    IBOutlet UILabel *billLabel;
    
    IBOutlet UILabel *dueDateLabel;
    
    IBOutlet UIButton *checkBtn;
}
@property (nonatomic,strong) EDAMGuid noteGuid;

@property (nonatomic,strong) void (^onCallback)(EDAMGuid);

- (IBAction)onCheck:(UIButton *)sender;

- (IBAction)onSelectCell:(UIButton *)sender;


@end
