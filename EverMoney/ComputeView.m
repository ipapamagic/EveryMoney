//
//  ComputeView.m
//  EverMoney
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ComputeView.h"
#import "EverNoteController.h"
#import "ComputeTableViewCell.h"
@interface ComputeView ()
-(void)onRefresh;
@end
@implementation ComputeView
{
    NSUInteger currentMonth;
    NSUInteger currentYear;
//    NSMutableArray *notesList;
    
    NSMutableArray *computeNoteList;
//    NSMutableDictionary *notesList;
}
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
        if (titleTagLabel.text == nil || [titleTagLabel.text isEqualToString:@""]) {
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *component = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit fromDate:[NSDate date]];
            
            currentMonth = component.month;
            currentYear = component.year;
            [self onRefresh];
        }
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
- (IBAction)onLastMonth:(id)sender {
    currentMonth--;
    if (currentMonth <= 0) {
        currentMonth = 12;
        currentYear--;
    }
    [self onRefresh];
    
}

- (IBAction)onNextMonth:(id)sender {
    currentMonth++;
    if (currentMonth > 12) {
        currentMonth = 1;
        currentYear++;
    }
    [self onRefresh];    
    
    
}
-(void)onRefresh
{
    [titleTagLabel setText:[NSString stringWithFormat:@"%d月",currentMonth]];
    computeNoteList = [NSMutableArray array];

    [self reloadData];
    [EverNoteController searchText:[NSString stringWithFormat:@"Due-Date:%d/%.2d",currentYear,currentMonth] success:^(NSArray *list){
     
        computeNoteList = [list mutableCopy];
        [self reloadData];        
    }];
}
-(void)reloadData
{
    [computeTableView reloadData];
    [totalMoneyLabel setText:@"$0"];
    __block NSInteger total = 0;
    for (EDAMGuid noteID in computeNoteList) {
        [EverNoteController getNoteWithNoteGuid:noteID withCallback:^(EDAMNote *note){
            [EverNoteController getBillFromNote:note withCallback:^(NSString* bill){
                NSInteger billValue = [bill integerValue];
                total += billValue;
                [totalMoneyLabel setText:[NSString stringWithFormat:@"$%d",total]];
            }];
        }];
    }
    
    
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return computeNoteList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ComputeTableViewCell";
    ComputeTableViewCell *cell = (ComputeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ComputeTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    cell.noteID = [computeNoteList objectAtIndex:indexPath.row];

    return cell;
}


@end
