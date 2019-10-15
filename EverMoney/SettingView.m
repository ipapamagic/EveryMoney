//
//  SettingView.m
//  EverMoney
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib
{
    [super awakeFromNib];
    tableCells = [tableCells sortedArrayUsingComparator:^NSComparisonResult(UIView* label1, UIView* label2) {
        if (label1.tag < label2.tag) return NSOrderedAscending;
        else if (label1.tag > label2.tag) return NSOrderedDescending;
        else return NSOrderedSame;
    }];
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableCells.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableCells objectAtIndex:indexPath.row];
}



- (IBAction)onSwitchCameraRoll:(UIButton *)sender {
    [sender setSelected:!sender.isSelected];
}
@end
