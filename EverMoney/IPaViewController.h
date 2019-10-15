//
//  IPaViewController.h
//  EverNotePayment
//
//  Created by  on 12/7/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteEditView.h"
#import "CatagoryView.h"
#import "ComputeView.h"
#import "SettingView.h"
#import "LocationView.h"
@interface IPaViewController : UIViewController <NewNoteEditViewDelegate,CatagoryViewDelegate>
{
    IBOutlet UIButton *newRecordBtn;
    IBOutlet UIView *contentView;
    IBOutlet NewNoteEditView *newNoteEditView;
    IBOutlet NoteEditView *noteEditView;    
    IBOutlet CatagoryView *catagoryView;
    
    IBOutlet ComputeView *computeView;
    
    IBOutlet SettingView *settingView;
    IBOutlet LocationView *locationView;
    
    IBOutlet UIButton *catagoryBtn;
    
    IBOutlet UIButton *computeBtn;
    
    IBOutlet UIButton *locationBtn;
    
    IBOutlet UIButton *settingBtn;
    
    IBOutlet UIImageView *loadingView;
    
}
- (IBAction)onGotoSettingView:(UIButton *)sender;
- (IBAction)onGotoLocationView:(UIButton *)sender;

- (IBAction)onGotoComputeView:(UIButton *)sender;

- (IBAction)onGotoCatagoryView:(UIButton *)sender;
- (IBAction)onNewPayment:(UIButton *)sender;
-(IBAction)onCloseNewEdit:(id)sender;
@end
