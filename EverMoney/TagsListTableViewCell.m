//
//  TagsListTableViewCell.m
//  EverMoney
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TagsListTableViewCell.h"
@interface TagsListTableViewCell ()
-(void)onNoteUpdate:(NSNotification*)noti;
-(void)onNoteThumbnailUpdate:(NSNotification*)noti;
@end
@implementation TagsListTableViewCell
@synthesize onCallback;
@synthesize noteGuid = _noteGuid;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNoteUpdate:) name:EvernoteNoteContentUpdateNotification object:[EverNoteController defaultEverNoteController]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNoteThumbnailUpdate:) name:EvernoteNoteThumbnailUpdateNotification object:[EverNoteController defaultEverNoteController]];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)onNoteThumbnailUpdate:(NSNotification*)noti
{
    EDAMGuid noteGuid = [noti.userInfo objectForKey:@"NoteGuid"];
    if (![noteGuid isEqualToString:self.noteGuid]) {
        return;
    }
    
    UIImage *image = [noti.userInfo objectForKey:@"Image"];
    [iconImageView setImage:image];
    
}
-(void)onNoteUpdate:(NSNotification*)noti
{
    EDAMNote *note = [noti.userInfo objectForKey:@"Note"];
    if (![note.guid isEqualToString:self.noteGuid]) {
        return;
    }
    else {
        NSString *bill = [EverNoteController readBillStringFromContent:note.content];
        NSString *dueDate = [EverNoteController readDueDateStringFromContent:note.content];        
        [billLabel setText:[NSString stringWithFormat:@"$%@",bill]];
        [dueDateLabel setText:dueDate];
        BOOL isCheck = [EverNoteController readCheckStringFromContent:note.content];
        if (isCheck) {
            [checkBtn setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateNormal];
        }
        else {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
            NSDate *date = [formatter dateFromString:dueDate];
            NSDate *today = [NSDate date];
            NSComparisonResult result = [today compare:date];
            if (result == NSOrderedAscending || result == NSOrderedSame)
            {
                [checkBtn setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];                
            }
            else {
                
                

                //過期了
                [checkBtn setImage:[UIImage imageNamed:@"check_over.png"] forState:UIControlStateNormal];

            }
            
        }
    }
    
}
-(void)setNoteGuid:(EDAMGuid)noteGuid
{
    _noteGuid = noteGuid;
    [titleLabel setText:@""];
    [billLabel setText:@"$0"];
    [dueDateLabel setText:@""];    
    [EverNoteController getNoteWithNoteGuid:noteGuid withCallback:^(EDAMNote* note){
        if (![noteGuid isEqualToString:self.noteGuid]) {
            return;
        }
        if (note == nil) {
            NSLog(@" get note error!");
            [titleLabel setText:noteGuid];


            return;
        }
        else {
            [titleLabel setText:note.title];
            
            [EverNoteController getBillFromNote:note withCallback:^(NSString* bill){
                if (![note.guid isEqualToString:self.noteGuid]) {
                    return;
                }
                [billLabel setText:[NSString stringWithFormat:@"$%@",bill]];
                
            }];
            
            [EverNoteController getDueDateFromNote:note withCallback:^(NSString* dueDate){
                if (![note.guid isEqualToString:self.noteGuid]) {
                    return;
                }
                [dueDateLabel setText:dueDate];
                
                //讀取check狀態
                [EverNoteController getCheckStateFromNote:note withCallback:^(BOOL isCheck){
                    if (![note.guid isEqualToString:self.noteGuid]) {
                        return;
                    }
                    if (isCheck) {
                        [checkBtn setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateNormal];
                    }
                    
                    
                    
                    
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
                    NSDate *date = [formatter dateFromString:dueDate];
                    NSDate *today = [NSDate date];
                    NSComparisonResult result = [today compare:date];
                    if (result == NSOrderedAscending || result == NSOrderedSame)                        
                    {
                        [checkBtn setImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];                        
                    }
                    else {

                        //過期了
                        [checkBtn setImage:[UIImage imageNamed:@"check_over.png"] forState:UIControlStateNormal];
                    }

                }];
                
                
                
                
            }];
            
            
            
            
            
        }
        
        if ([note.resources count] > 0) {
            [EverNoteController getNoteThumbNailWithGuid:noteGuid withCallback:^(UIImage* image){
                if (![noteGuid isEqualToString:self.noteGuid]) {
                    return;
                }
                NSLog(@"get image!!");
                [iconImageView setImage:image];
            }];

        }
        
    }];
    
    
}
/*
-(void)setNote:(EDAMNote *)note
{
    _note = note;
    [titleLabel setText:note.title];
    if ([note.resources count] > 0)
    {
        EDAMResource *resource = [note.resources objectAtIndex:0];
        if ([resource.mime isEqualToString:@"image/jpeg"])
        {
            UIImage *image = [UIImage imageWithData:resource.data.body];
            [iconImageView setImage:image];
            
        }
    }
    NSRange range = [note.content rangeOfString:@"Price:"];
    NSString *subString = [note.content substringFromIndex:range.location + range.length];
    range = [subString rangeOfString:@"Due-Date:"];
    NSString *price = [subString substringToIndex:range.location];
    subString = [subString substringFromIndex:range.location + range.length];
    range = [subString rangeOfString:@"Location:"];
    NSString *dueDate = [subString substringToIndex:range.location];
    subString = [subString substringFromIndex:range.location + range.length];
    range = [subString rangeOfString:@"<br/>"];    
   // NSString *location = [subString substringToIndex:range.location];
    //5是 <br/>的長度
    price = [price substringToIndex:(price.length - 5)];
    dueDate = [dueDate substringToIndex:(dueDate.length - 5)];
    
    [billLabel setText:[NSString stringWithFormat:@"$%@",price]];
    [dueDateLabel setText:dueDate];
    
    
    
    
}*/
- (IBAction)onCheck:(UIButton *)sender {
    //修改content check 狀態
    
    [EverNoteController checkNoteWithNoteGuid:self.noteGuid];
    
}

- (IBAction)onSelectCell:(UIButton *)sender {
    
    onCallback(self.noteGuid);
}
@end
