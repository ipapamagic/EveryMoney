//
//  IPaViewController.m
//  EverNotePayment
//
//  Created by  on 12/7/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "IPaViewController.h"
#import "IPaAlertView.h"
#import "CatagoryView.h"
#import "EverNoteController.h"
#import "IPaNetworkState.h"
#import "FullScreenImgView.h"

@interface IPaViewController ()
-(void)closeEditView;
@end

@implementation IPaViewController
{
//    UIImagePickerController *imgPicker;
    UIView *currentSubView;
    FullScreenImgView *fullScreenImgView;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (![EvernoteSession sharedSession].isAuthenticated) {
        //登入EverNote
        
     
        // set up Evernote session singleton
        [EvernoteSession setSharedSessionHost:EVERNOTE_HOST 
                                  consumerKey:CONSUMER_KEY 
                               consumerSecret:CONSUMER_SECRET];
        [EverNoteController evernoteAuthenticate:self withSuccees:^(){
            [loadingView removeFromSuperview];
           
        }];
    
    }
    else {
        [loadingView removeFromSuperview];
           
    }
}
- (void)viewDidUnload
{
    contentView = nil;
    newRecordBtn = nil;
    catagoryBtn = nil;
    computeBtn = nil;
    locationBtn = nil;
    settingBtn = nil;
    computeView = nil;
    settingView = nil;
    locationView = nil;
    loadingView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)onNewPayment:(UIButton *)sender {
    [catagoryBtn setSelected:NO];
    [computeBtn setSelected:NO];
    [locationBtn setSelected:NO];
    [settingBtn setSelected:NO];
    [currentSubView removeFromSuperview];
    currentSubView = nil;
    
        
    //建立新的note
    [sender setEnabled:NO];
    
    if (newNoteEditView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"NewNoteEditView" owner:self options:nil];
    }

    
    if (newNoteEditView.superview != nil) {
        return;
    }
    
    newNoteEditView.transform = CGAffineTransformMakeTranslation(newNoteEditView.frame.size.width, 0);
    [contentView addSubview:newNoteEditView];
    
    [UIView animateWithDuration:0.3 animations:^(){
        newNoteEditView.transform = CGAffineTransformIdentity;
        
    }];
    
    
    /*if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [IPaAlertView IPaAlertViewWithTitle:@"Warning!" message:@"Device Not Support Camera!" cancelButtonTitle:@"確定"];
        return;
    }
    if (imgPicker == nil) {
        imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.delegate = self;
    }
    
    [self presentViewController:imgPicker animated:YES completion:nil];*/
}

- (IBAction)onGotoSettingView:(UIButton *)sender {
    [self closeEditView];
    if ([currentSubView isKindOfClass:[SettingView class]]) {
        return;
    }
    [catagoryBtn setSelected:NO];
    [computeBtn setSelected:NO];
    [locationBtn setSelected:NO];
    [settingBtn setSelected:YES];    
    
    
    
    [currentSubView removeFromSuperview];
    
    if (settingView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"SettingView" owner:self options:nil];
        
        
        
    }
    
    currentSubView = settingView;
    [contentView addSubview:currentSubView];
    
}

- (IBAction)onGotoLocationView:(UIButton *)sender {
    [self closeEditView];
    if ([currentSubView isKindOfClass:[LocationView class]]) {
        return;
    }
    [catagoryBtn setSelected:NO];
    [computeBtn setSelected:NO];
    [locationBtn setSelected:YES];
    [settingBtn setSelected:NO];    
    
    
    
    [currentSubView removeFromSuperview];
    
    if (locationView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"LocationView" owner:self options:nil];
        
        
        
    }
    
    currentSubView = locationView;
    [contentView addSubview:currentSubView];
    
}

- (IBAction)onGotoComputeView:(UIButton *)sender {
    [self closeEditView];
    if ([currentSubView isKindOfClass:[ComputeView class]]) {
        return;
    }
    [catagoryBtn setSelected:NO];
    [computeBtn setSelected:YES];
    [locationBtn setSelected:NO];
    [settingBtn setSelected:NO];    
    
    
    
    [currentSubView removeFromSuperview];
    
    if (computeView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ComputeView" owner:self options:nil];
        
       
        
    }
    
    currentSubView = computeView;
    [contentView addSubview:currentSubView];
    
}

- (IBAction)onGotoCatagoryView:(UIButton *)sender {

    [self closeEditView];
    if ([currentSubView isKindOfClass:[CatagoryView class]]) {
        return;
    }
    [catagoryBtn setSelected:YES];
    [computeBtn setSelected:NO];
    [locationBtn setSelected:NO];
    [settingBtn setSelected:NO];    

    
    
    [currentSubView removeFromSuperview];
    
    if (catagoryView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"CatagoryView" owner:self options:nil];
        
        [catagoryView reloadListTable];
    }

    currentSubView = catagoryView;
    [contentView addSubview:currentSubView];
    
}

-(IBAction)onCloseNewEdit:(id)sender {


    
    [UIView animateWithDuration:0.3 animations:^(){
        newNoteEditView.transform = CGAffineTransformMakeTranslation(newNoteEditView.frame.size.width, 0);
    }completion:^(BOOL finished){
        [newNoteEditView removeFromSuperview];

        
       
    }];
    
}

-(void)closeEditView
{
    if (newNoteEditView.superview) {
        [self onCloseNewEditViewWithNewNoteID:nil];
    }
    if (noteEditView.superview) {
        [self onCloseEditViewWithUpdateNoteID:nil];
    }
}
#pragma NewNoteEditViewDelegate
-(void)onCloseNewEditViewWithNewNoteID:(EDAMGuid)noteID
{
    [UIView animateWithDuration:0.3 animations:^(){
        newNoteEditView.transform = CGAffineTransformMakeTranslation(newNoteEditView.frame.size.width, 0);
    }completion:^(BOOL finished){
        [newNoteEditView removeFromSuperview];
        if (noteID != nil) {
            newNoteEditView = nil;
        }

        [newRecordBtn setEnabled:YES];
    }];
    if (noteID) {
        [catagoryView onAddNewNoteID:noteID];    
    }
}
-(void)onCloseEditViewWithUpdateNoteID:(EDAMGuid)noteID
{
    noteEditView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.3 animations:^(){
        noteEditView.transform = CGAffineTransformMakeTranslation(noteEditView.frame.size.width, 0);
    }completion:^(BOOL finished){
        [noteEditView removeFromSuperview];
        if (noteID != nil) {
           noteEditView = nil;
        }

        
    }];    

}
-(void)onNewNoteShowImagePicker:(UIImagePickerController*)imgPicker
{
    [self presentViewController:imgPicker animated:YES completion:nil];
}
-(void)onShowDatePicker:(UIDatePicker*)datePicker
{
    [self.view addSubview:datePicker];
    datePicker.transform = CGAffineTransformMakeTranslation(0, datePicker.frame.size.height);
    [UIView animateWithDuration:0.3 animations:^(void){
        datePicker.transform = CGAffineTransformIdentity;
    }];
}
-(void)onShowTagsSelectView:(UIView*)View
{
    [self.view addSubview:View];
    View.transform = CGAffineTransformMakeTranslation(View.frame.size.width,0);
    [UIView animateWithDuration:0.3 animations:^(){
        View.transform = CGAffineTransformIdentity;
        
        
    }];
    
}
-(void)onShowMapView:(UIView*)mapView
{
    [self.view addSubview:mapView];
    mapView.transform = CGAffineTransformMakeTranslation(mapView.frame.size.width,0);
    [UIView animateWithDuration:0.3 animations:^(){
        mapView.transform = CGAffineTransformIdentity;
        
        
    }];
    
    
}
-(void)onShowPicture:(UIImage*)image
{
    if (fullScreenImgView.superview != nil) {
        return;
    }
    if (fullScreenImgView == nil) {
        fullScreenImgView = [[[NSBundle mainBundle] loadNibNamed:@"FullScreenImgView" owner:nil options:nil] objectAtIndex:0];
    }
    [fullScreenImgView.imageView setImage:image];
    fullScreenImgView.transform = CGAffineTransformMakeTranslation(self.view.frame.size.width, 0);
    
    
    CGSize imgSize = image.size;
    
    if (imgSize.width > imgSize.height) {
        if (imgSize.width > fullScreenImgView.frame.size.width) {
            imgSize.width = fullScreenImgView.frame.size.width;
            imgSize.height = imgSize.width * image.size.height / image.size.width;
        }
    }
    else {
        if (imgSize.height > fullScreenImgView.frame.size.height - 44) {
            imgSize.height = fullScreenImgView.frame.size.height - 44;
            imgSize.width = imgSize.height * image.size.width / image.size.height;
        }
    }
    [fullScreenImgView.imageView setFrame:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    
    fullScreenImgView.imageView.center = CGPointMake(160,252);
    
    
    
    
    [self.view addSubview:fullScreenImgView];
    [UIView animateWithDuration:0.3 animations:^(){
        fullScreenImgView.transform = CGAffineTransformIdentity;
    }];
    
}
#pragma mark - CatagoryViewDelegate
-(void) editNoteWithGuid:(EDAMGuid)noteGuid
{
    if (noteEditView == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"NoteEditView" owner:self options:nil];
    }
    [EverNoteController getNoteWithNoteGuid:noteGuid withCallback:^(EDAMNote* note){
        noteEditView.note = note;
        noteEditView.transform = CGAffineTransformMakeTranslation(noteEditView.frame.size.width, 0);
        [contentView addSubview:noteEditView];
        [UIView animateWithDuration:0.3 animations:^(){
            noteEditView.transform = CGAffineTransformIdentity;
        }];

    }];
    
}

@end
