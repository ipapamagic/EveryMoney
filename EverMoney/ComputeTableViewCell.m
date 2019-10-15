//
//  ComputeTableViewCell.m
//  EverMoney
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ComputeTableViewCell.h"
@interface ComputeTableViewCell()
-(void)onUpdateNote:(NSNotification*)noti;
@end
@implementation ComputeTableViewCell
@synthesize titleLabel;
@synthesize moneyLabel;
@synthesize noteID = _noteID;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateNote:) name:EvernoteNoteContentUpdateNotification object:[EverNoteController defaultEverNoteController]];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)setNoteID:(EDAMGuid)noteID
{
    _noteID = noteID;
    [titleLabel setText:@""];
    [moneyLabel setText:@"$0"];
    [EverNoteController getNoteWithNoteGuid:noteID withCallback:^(EDAMNote *note){
        if (![note.guid isEqualToString:self.noteID]) {
            return;
        }
        [titleLabel setText:note.title];
        [EverNoteController getBillFromNote:note withCallback:^(NSString *bill){
            if (![noteID isEqualToString:self.noteID]) {
                return;
            }
            [moneyLabel setText:[NSString stringWithFormat:@"$%@", bill]];
            
        }];
        
    }];
    
    
}
-(void)onUpdateNote:(NSNotification*)noti
{
    EDAMNote *note = [noti.userInfo objectForKey:@"Note"];
    if (![note.guid isEqualToString:self.noteID]) {
        return;
    }
    
    
    NSString *bill = [EverNoteController readBillStringFromContent:note.content];
    [moneyLabel setText:[NSString stringWithFormat:@"$%@", bill]];   
}
@end
