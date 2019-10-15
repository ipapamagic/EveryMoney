//
//  CatagoryView.h
//  EverMoney
//
//  Created by  on 12/7/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EverNoteController.h"
@protocol CatagoryViewDelegate;
@interface CatagoryView : UIView <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>
{
    
    IBOutlet UITableView *ListTableView;
}
-(void)reloadListTable;
-(void)onAddNewNoteID:(EDAMGuid)noteID;
-(void)onUpdateNoteID:(EDAMGuid)noteID;
@property (nonatomic,weak) IBOutlet id<CatagoryViewDelegate> delegate;
@property (nonatomic,strong) NSMutableDictionary *noteList;
@property (nonatomic,strong) NSMutableArray *tagList;
- (IBAction)onAddTag:(id)sender;



@end
@protocol CatagoryViewDelegate <NSObject> 
-(void) editNoteWithGuid:(EDAMGuid)noteGuid;
@end