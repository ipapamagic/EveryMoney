//
//  TagsSelectView.m
//  EverMoney
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TagsSelectView.h"
#import "IPaAlertView.h"
#import "EverNoteController.h"
@implementation TagsSelectView
@synthesize tagList = _tagList;
@synthesize selectedTagList;
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
    if (self.superview != nil) {
        [tagsTableView reloadData];
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
-(void)setTagList:(NSMutableArray *)tagList
{
    _tagList = tagList;
    
    [tagsTableView reloadData];
    
}
#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tagList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tagTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString *tagName = [self.tagList objectAtIndex:indexPath.row];
    
    if ([selectedTagList indexOfObject:tagName] != NSNotFound)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    [cell.textLabel setText:tagName];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select row:%d",indexPath.row);
    NSString *tagName = [self.tagList objectAtIndex:indexPath.row];
    NSUInteger index = [selectedTagList indexOfObject:tagName];
    if (index == NSNotFound) {
        [selectedTagList addObject:tagName];
    }
    else {
        [selectedTagList removeObjectAtIndex:index];
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadData];
}

- (IBAction)onAddTag:(UIButton *)sender {
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
    //建立新的tag
    if ([self.tagList indexOfObject:textField.text] != NSNotFound) {
        if ([self.selectedTagList indexOfObject:textField.text] == NSNotFound)
        {
            [self.selectedTagList addObject:textField.text];
            [tagsTableView reloadData];
        }
        return;
    }
    [EverNoteController createTag:textField.text success:^(EDAMTag* newTag){
        
    }failure:^(NSError *error){
        
    }];
    [self.tagList addObject:textField.text];
    [self.selectedTagList addObject:textField.text];
    
    [tagsTableView reloadData];
    

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  //  [textField resignFirstResponder];
  
    
    
    return YES;
}
@end
