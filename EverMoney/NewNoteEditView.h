//
//  NewNoteEditView.h
//  EverMoney
//
//  Created by  on 12/7/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MapData.h"
#import "EverNoteController.h"

@protocol NewNoteEditViewDelegate;
@class TagsSelectView;

@interface NewNoteEditView : UIView <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,MKMapViewDelegate>
{
    
    IBOutlet UIImageView *imageView;
    IBOutletCollection(UITableViewCell) NSArray *tableCells;
    
    IBOutlet UITableView *listTableView;
    
    __weak IBOutlet UITextField *titleField;
    
    __weak IBOutlet UITextField *moneyField;
    
   
    __weak IBOutlet UITextField *dateField;
    
   // __weak IBOutlet UILabel *mapLabel;
    
    __weak IBOutlet UITextField *mapField;

    __weak IBOutlet UITextField *tagsField;
    
    __weak IBOutlet UIButton *alarmBtn;
    IBOutlet id <NewNoteEditViewDelegate> delegate;
    

    IBOutlet UIButton *saveBtn;
    
    IBOutlet UIView *tipView;
    __weak IBOutlet UILabel *tipTextLabel;
    IBOutlet UIDatePicker *datePicker;
    
    IBOutlet UIView *MapContentView;
    
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UITextField *mapSearchTextField;
    __weak IBOutlet UILabel *mapViewAddressLabel;
    IBOutlet TagsSelectView *tagsSelectView;
    
    
    
    
}
@property (nonatomic,assign) BOOL isEditing;
@property (nonatomic,strong) UIImage *image;
- (IBAction)onSelectDate:(UIButton *)sender;
- (IBAction)onSelectAddress:(UIButton *)sender;
- (IBAction)onEditTag:(UIButton *)sender;
- (IBAction)onSwitchAlarm:(UIButton *)sender;
- (IBAction)onSave:(UIButton *)sender;
- (IBAction)onTakePicture:(UIButton *)sender;
- (IBAction)onCloseTagsView:(UIButton *)sender;
-(void)editSave;
- (IBAction)onMapDone:(UIButton *)sender;
- (IBAction)onChoosePic:(UIButton *)sender;


@end

@protocol NewNoteEditViewDelegate <NSObject>
-(void)onCloseNewEditViewWithNewNoteID:(EDAMGuid)noteID;
-(void)onCloseEditViewWithUpdateNoteID:(EDAMGuid)noteID;
-(void)onNewNoteShowImagePicker:(UIImagePickerController*)imgPicker;
-(void)onShowDatePicker:(UIDatePicker*)datePicker;
-(void)onShowMapView:(UIView*)mapView;
-(void)onShowTagsSelectView:(UIView*)View;
-(void)onShowPicture:(UIImage*)image;
@end
