//
//  CatagoryView.m
//  EverMoney
//
//  Created by  on 12/7/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CatagoryView.h"
#import "EverNoteController.h"
#import "TagsListTableViewCell.h"
#import "IPaNetworkState.h"
@implementation CatagoryView

@synthesize noteList = _noteList;
@synthesize tagList = _tagList;

@synthesize delegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if (self.superview != nil) {
        
        
        
        [self reloadListTable];


    }

}

-(void)onAddNewNoteID:(EDAMGuid)noteID
{
    //增加新的Note
}
-(void)onUpdateNoteID:(EDAMGuid)noteID
{
    //更新note
}
-(void)setNoteList:(NSMutableDictionary *)noteList
{
    _noteList = noteList;
    [ListTableView reloadData];
}
-(void)reloadListTable
{
    self.tagList = [NSMutableArray array];
    self.noteList = [NSMutableDictionary dictionary];
   
    [EverNoteController findNotes:^(NSArray* noteList){
       
        if (noteList == nil)
            return;

        for (EDAMGuid noteGuid in noteList)
        {
            [EverNoteController getTagNamesFromNoteGuid:noteGuid withCallback:^(NSArray* tagNames){
                for (NSString *tagName in tagNames) {
                    if ([self.tagList indexOfObject:tagName] == NSNotFound) {
                        [self.tagList addObject:tagName];
                    }
                    NSMutableArray *noteListData = [self.noteList objectForKey:tagName];
                    if (noteListData == nil) {
                        noteListData = [NSMutableArray array];
                    }
                    
                    if ([noteListData indexOfObject:noteGuid] == NSNotFound) {
                        [noteListData addObject:noteGuid];
                    }
                    [self.noteList setObject:noteListData forKey:tagName];
                }
                [ListTableView reloadData];
            }];
        }
    }];
    
    
    

}
#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,320,25)];
    headerView.backgroundColor = [UIColor colorWithRed:0 green:113.0f/255 blue:141.0f/255 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, -2, 320, 25)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor whiteColor]];
    [label setText:[self.tagList objectAtIndex:section]];
    [headerView addSubview:label];
    return headerView;
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tagList.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{   
    NSString *tag = [self.tagList objectAtIndex:section];
    NSArray *notes = [self.noteList objectForKey:tag];
    
    return [notes count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"catagoryTableViewCell";
    TagsListTableViewCell *cell = (TagsListTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TagsListTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    
    NSString *tag = [self.tagList objectAtIndex:indexPath.section];
    NSArray *notes = [self.noteList objectForKey:tag];
    
    cell.noteGuid = [notes objectAtIndex:indexPath.row];
    cell.onCallback = ^(EDAMGuid noteID){
        [delegate editNoteWithGuid:noteID];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   // [tableView reloadData];
    NSString *tag = [self.tagList objectAtIndex:indexPath.section];
    NSArray *notes = [self.noteList objectForKey:tag];
    
    EDAMGuid noteGuid = [notes objectAtIndex:indexPath.row];
    

    [delegate editNoteWithGuid:noteGuid];
}



- (IBAction)onAddTag:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"New Tag Name\n\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
    CGRect frame = [alertView frame];
    UITextField *tagField = [[UITextField alloc] initWithFrame:CGRectMake(15, 60,frame.size.width-60, 30)];
    [alertView addSubview:tagField];
    tagField.borderStyle=UITextBorderStyleRoundedRect;
    tagField.tag = -1;
    tagField.delegate = self;

}

#pragma mark - UIAlertViewDelegate
- (void)didPresentAlertView:(UIAlertView *)alertView
{
    
    
    [UIView animateWithDuration:0.3 animations:^(){
        CGRect frame = [alertView frame];
        //frame.origin.y -= 50;
        [alertView setFrame:frame];
        
    }completion:^(BOOL finished){
        UITextField *tagField = (UITextField*)[alertView viewWithTag:-1];
        [tagField becomeFirstResponder];
    }];
    
    
}
#pragma mark - UITextFieldDelegate


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text == nil || [textField.text isEqualToString:@""]) {
        
        return;
    }
    
    [EverNoteController createTag:textField.text success:^(EDAMTag* newTag){
        
    }failure:^(NSError *error){
        
    }];
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //  [textField resignFirstResponder];
    
    
    
    return YES;
}

@end
