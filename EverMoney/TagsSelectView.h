//
//  TagsSelectView.h
//  EverMoney
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagsSelectView : UIView <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>
{
    
    IBOutlet UITableView *tagsTableView;
}
@property (nonatomic,strong) NSMutableArray *tagList;
@property (nonatomic,strong) NSMutableArray *selectedTagList;

- (IBAction)onAddTag:(UIButton *)sender;

@end
