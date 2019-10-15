//
//  NoteEditView.m
//  EverMoney
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NoteEditView.h"
@interface NoteEditView ()
-(void)onUpdateNote:(NSNotification*)noti;
@end
@implementation NoteEditView
@synthesize note = _note;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUpdateNote:) name:EvernoteNoteContentUpdateNotification object:[EverNoteController defaultEverNoteController]    ];
        
        EDAMGuid noteGuid = [self.note.guid copy];
        [titleField setText:self.note.title];
        
        [EverNoteController getNoteResourceImageWithNote:self.note withCallback:^(NSData* data){
            if (data != nil) {
                UIImage *image = [UIImage imageWithData:data];
                [imageView setImage:image];
            }
            
        }];
        
        
        [moneyField setText:0];
        [dateField setText:@""];
        
        [mapField setText:@""];
        

        if (self.note.content == nil) {
            
            [EverNoteController getContentFromNote:self.note withCallback:^(NSString* content){
                if (![noteGuid isEqualToString:self.note.guid]) {
                    return;
                }    
                [moneyField setText:[EverNoteController readBillStringFromContent:content]];
                [dateField setText:[EverNoteController readDueDateStringFromContent:content]];
                [mapField setText:[EverNoteController readLocationStringFromContent:content]];
                
            }];
        }
        else {
            [moneyField setText:[EverNoteController readBillStringFromContent:self.note.content]];
            [dateField setText:[EverNoteController readDueDateStringFromContent:self.note.content]];
            [mapField setText:[EverNoteController readLocationStringFromContent:self.note.content]];
            
        }
               
        [EverNoteController getTagNamesFromNoteGuid:self.note.guid withCallback:^(NSArray *tagNames){
            if (![noteGuid isEqualToString:self.note.guid])
            {
                return;
            }
            NSMutableString *tagString = [@"" mutableCopy];
            
            for (NSString* tagName in tagNames) {
                if ([tagString isEqualToString:@""]) {
                    [tagString appendString:tagName];
                }
                else {
                    [tagString appendFormat:@",%@",tagName];
                }

            }
            [tagsField setText:tagString];
        }];
        
    }
    else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
-(void)onUpdateNote:(NSNotification*)noti
{
    EDAMNote *note = [noti.userInfo objectForKey:@"Note"];
    if ([note.guid isEqualToString:self.note.guid]) {
        self.note = note;
        [moneyField setText:[EverNoteController readBillStringFromContent:self.note.content]];
        [dateField setText:[EverNoteController readDueDateStringFromContent:self.note.content]];
        [mapField setText:[EverNoteController readLocationStringFromContent:self.note.content]];
        
    }
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)onCancel:(UIButton *)sender {
    [delegate onCloseEditViewWithUpdateNoteID:nil];
}


-(void)editSave
{
    [delegate onCloseEditViewWithUpdateNoteID:self.note.guid];
    [EverNoteController updateNote:self.note WithTitle:(titleField.text == nil || [titleField.text isEqualToString:@""])?@"Title":titleField.text Price:(moneyField.text == nil || [moneyField.text isEqualToString:@""])?@"0":moneyField.text DueDate:(dateField.text == nil || [dateField.text isEqualToString:@""])?@"":dateField.text Location:(mapField.text == nil || [mapField.text isEqualToString:@""])?@"":mapField.text  withTags:tagsField.text isCheck:NO withCallback:^(EDAMNote* note){
    }];

    //   [EverNoteController createNoteWithTitle:(titleField.text == nil || [titleField.text isEqualToString:@""])?@"Title":titleField.text Price:(moneyField.text == nil || [moneyField.text isEqualToString:@""])?@"0":moneyField.text DueDate:(dateField.text == nil || [dateField.text isEqualToString:@""])?@"":dateField.text Location:(mapLabel.text == nil || [mapLabel.text isEqualToString:@""])?@"":mapLabel.text WithImage:self.image withTags:tagsField.text];
    
    
 //   [delegate onCloseNewEditView];
}
- (IBAction)onShowPic:(UIButton *)sender {
    [EverNoteController getNoteResourceImageWithNote:self.note withCallback:^(NSData* data){
        UIImage *image = [UIImage imageWithData:data];
        
        [delegate onShowPicture:image];
        
        
        
    }];
    
}
-(void)setIsEditing:(BOOL)isEditing
{
    [super setIsEditing:isEditing];
    [cancelBtn setHidden:isEditing];
    
    
}
@end
