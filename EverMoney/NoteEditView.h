//
//  NoteEditView.h
//  EverMoney
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewNoteEditView.h"
#import "EverNoteController.h"
@interface NoteEditView : NewNoteEditView
{
    
    IBOutlet UIButton *cancelBtn;
}
- (IBAction)onCancel:(UIButton *)sender;
@property (nonatomic,strong) EDAMNote *note;

- (IBAction)onShowPic:(UIButton *)sender;

@end
