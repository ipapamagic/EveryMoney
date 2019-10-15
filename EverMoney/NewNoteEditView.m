//
//  NewNoteEditView.m
//  EverMoney
//
//  Created by  on 12/7/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NewNoteEditView.h"
#import "EverNoteController.h"
#import "IPaAlertView.h"
#import "IPaURLRequest.h"
#import "TagsSelectView.h"



@interface NewNoteEditView ()
-(void)onShowKeyBoard:(NSNotification*)noti;
-(void)onHideKeyBoard:(NSNotification*)noti;

@end
@implementation NewNoteEditView
{
    UIImagePickerController *imgPicker;

}
@synthesize isEditing = _isEditing;
@synthesize image = _image;
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
    listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];    
    [mapView setShowsUserLocation:YES];
}
-(void)didMoveToSuperview
{
    if (self.superview == nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    else {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onShowKeyBoard:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHideKeyBoard:) name:UIKeyboardDidHideNotification object:nil];        
        
        if (dateField.text == nil || [dateField.text isEqualToString:@""]) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
            [dateField setText:[formatter stringFromDate:[NSDate date]]];
        }

        
    }
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    [imageView setImage:image];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    if (isEditing) {
        [saveBtn setTitle:@"Done" forState:UIControlStateNormal];
      //  [cancelBtn setHidden:YES];
    }
    else {
        [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
      //  [cancelBtn setHidden:NO];
    }
    
}
-(BOOL)endEditing:(BOOL)force
{
    BOOL ret = [super endEditing:force];
    if (datePicker.superview != nil) {
        [UIView animateWithDuration:0.3 animations:^(){
            datePicker.transform = CGAffineTransformMakeTranslation(0, datePicker.frame.size.height);
        }completion:^(BOOL finished){
            [datePicker removeFromSuperview]; 
        }];

    }
    return ret;
}
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


- (IBAction)onSelectDate:(UIButton *)sender {
    [self endEditing:YES];
    datePicker.date = [NSDate date];    
    if (dateField.text != nil && ![dateField.text isEqualToString:@""]) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        datePicker.date = [formatter dateFromString:dateField.text];
    }

    datePicker.center = CGPointMake(160, 352);
  //  datePicker.transform = CGAffineTransformMakeTranslation(0, datePicker.frame.size.height);
   // [self addSubview:datePicker];

   // [UIView animateWithDuration:0.3 animations:^(){
   //     datePicker.transform = CGAffineTransformIdentity; 
   // }];
    [delegate onShowDatePicker:datePicker];
    self.isEditing = YES;
}

- (IBAction)onSelectAddress:(UIButton *)sender {
    self.isEditing = YES;
    if (mapField.text != nil && ![mapField.text isEqualToString:@""]) {
        [mapViewAddressLabel setText:[NSString stringWithFormat:@"%@%@",SELECTEDADDRESS_LABEL,mapField.text]];
        
        
                
        CLLocation *userLoc = [[CLLocation alloc] initWithLatitude:mapView.userLocation.coordinate.latitude longitude:mapView.userLocation.coordinate.longitude];
        NSString *address = [mapField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        [IPaURLRequest IPaURLRequestWithURL:[NSString stringWithFormat:GOOGLE_MAP_ADDRESS_API,address,userLoc.coordinate.latitude,userLoc.coordinate.longitude] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20 callback:^(NSURLResponse* response,NSData* responseData){
            NSError* error;
            NSDictionary* json = [NSJSONSerialization 
                                  JSONObjectWithData:responseData //1
                                  options:kNilOptions 
                                  error:&error];
            NSArray *result = [json objectForKey:@"results"];
            json = [result objectAtIndex:0];
            NSDictionary *location = [[json objectForKey:@"geometry"] objectForKey:@"location"];                            
            MapData *data = [[MapData alloc] init];
            [data setCoordinate:CLLocationCoordinate2DMake([[location objectForKey:@"lat"] doubleValue], [[location objectForKey:@"lng"] doubleValue])];
            
            data.title = mapField.text;
            data.subtitle = mapField.text;
            
            NSMutableArray *mapDataList = [NSMutableArray array];
            [mapDataList addObject:data];
            
            
            if ([mapView.annotations count] > 0) {
                [mapView removeAnnotations:mapView.annotations];
            }
            [mapView addAnnotations:mapDataList];
            if ([mapView.annotations count] > 0) {
                [mapView setSelectedAnnotations:[NSArray arrayWithObject:[mapView.annotations objectAtIndex:0]]];
            }
            
            
        }];
        
        
        
    }
    [delegate onShowMapView:MapContentView];
    [mapView setShowsUserLocation:NO];    
    [mapView setShowsUserLocation:YES];
    
    MKCoordinateRegion region;
    region.center = mapView.userLocation.coordinate;  
    
    MKCoordinateSpan span; 
    span.latitudeDelta  = 0.01; // Change these values to change the zoom
    span.longitudeDelta = 0.01; 
    region.span = span;
    
    [mapView setRegion:region animated:NO];
/*    [mapView setShowsUserLocation:NO];    
    [mapView setShowsUserLocation:YES];
    //目前位置
    CLLocation *userLoc = [[CLLocation alloc] initWithLatitude:mapView.userLocation.coordinate.latitude longitude:mapView.userLocation.coordinate.longitude];
    

    [IPaURLRequest IPaURLRequestWithURL:[NSString stringWithFormat:GOOGLE_PLACE_API,userLoc.coordinate.latitude,userLoc.coordinate.longitude,mapSearchTextField.text,GOOGLE_API_KEY] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20 callback:^(NSURLResponse* response,NSData* responseData){
        
    }];
*/    
}

- (IBAction)onEditTag:(UIButton *)sender {
    
    
    if (tagsSelectView.superview != nil) {
        return;
    }
    else {
        
        
        NSMutableArray *strArray = [NSMutableArray array];
        if (tagsField.text != nil && ![tagsField.text isEqualToString:@""]) {
            
            NSArray *selectedTags = [tagsField.text componentsSeparatedByString:@","];
            for (NSString *tagsName in selectedTags) {
                if ([strArray indexOfObject:tagsName] == NSNotFound) {
                    [strArray addObject:tagsName];
                }
            }
            tagsSelectView.selectedTagList = [selectedTags mutableCopy];
        }
        else {
            tagsSelectView.selectedTagList = [NSMutableArray array];
        }
        tagsSelectView.tagList = strArray;
        
        
        
        [delegate onShowTagsSelectView:tagsSelectView];
    }
    
    
    
    [EverNoteController listTagsWithsuccess:^(NSArray *array){
        NSLog(@"succeed %@",array);
        
        NSMutableArray *strArray = [tagsSelectView.tagList mutableCopy];
        for (EDAMTag* tagData in array) {
            if ([strArray indexOfObject:tagData.name] == NSNotFound) {
                [strArray addObject:tagData.name];
            }
        }
        tagsSelectView.tagList = strArray;
        
        
       
        
    }failure:^(NSError *error){
        NSLog(@"fail %@",error);
    }];
    
    
    
}
-(void)onCloseTip
{
    
    [UIView animateWithDuration:0.3 animations:^(){
        [tipView setAlpha:0]; 
    }completion:^(BOOL finished){
        [tipView removeFromSuperview];
    }];

}
- (IBAction)onSwitchAlarm:(UIButton *)sender {
    [tipView setAlpha:0];
    [sender setSelected:!sender.isSelected];

    [tipTextLabel setText:(sender.isSelected)?@"Alarm:On":@"Alarm:Off"];
    

    
    
    [self addSubview:tipView];
    [UIView animateWithDuration:0.3 animations:^(){
        [tipView setAlpha:1]; 
    }completion:^(BOOL finished){
        
        [self performSelector:@selector(onCloseTip) withObject:nil afterDelay:0.5];
        
    }];

    
    
}

- (IBAction)onSave:(UIButton *)sender {
    if ([titleField isFirstResponder] || [moneyField isFirstResponder]) {
        [self endEditing:YES];
        
        return;
    }
    else if (datePicker.superview != nil){
        self.isEditing = NO;
        
        [UIView animateWithDuration:0.3 animations:^(){
            datePicker.transform = CGAffineTransformMakeTranslation(0, datePicker.frame.size.height);
        }completion:^(BOOL finished){
            [datePicker removeFromSuperview]; 
        }];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        [dateField setText:[formatter stringFromDate:datePicker.date]];
        
        
        return;
    }
  
    
    [self editSave];
    
    
    
    
}
-(void)editSave
{
    [EverNoteController createNoteWithTitle:(titleField.text == nil || [titleField.text isEqualToString:@""])?@"Title":titleField.text Price:(moneyField.text == nil || [moneyField.text isEqualToString:@""])?@"0":moneyField.text DueDate:(dateField.text == nil || [dateField.text isEqualToString:@""])?@"":dateField.text Location:(mapField.text == nil || [mapField.text isEqualToString:@""])?@"":mapField.text WithImage:self.image withTags:tagsField.text withCallback:^(EDAMNote* note){
        if (note) {
            [delegate onCloseNewEditViewWithNewNoteID:note.guid];
            
            //新增Local Notification
            
            
            
            
            
        }
        else {
            [delegate onCloseNewEditViewWithNewNoteID:nil];    
        }
    }];
    
    
    
    
    
}

- (IBAction)onMapDone:(UIButton *)sender {
    if ([mapSearchTextField isFirstResponder]) {
        [mapSearchTextField resignFirstResponder];

    }
    //儲存地址資料
    if (mapViewAddressLabel.text != nil && ![mapViewAddressLabel.text isEqualToString:@""]) {
        NSString *selectString = [mapViewAddressLabel.text substringFromIndex:[SELECTEDADDRESS_LABEL length]];
        
        [mapField setText:selectString];

    }
    else {
        [mapField setText:@""];
    }
    
    
    
    
    self.isEditing = NO;
    
    
    [UIView animateWithDuration:0.3 animations:^(){
        MapContentView.transform = CGAffineTransformMakeTranslation(MapContentView.frame.size.width, 0);
    }completion:^(BOOL finished){
        [MapContentView removeFromSuperview];
    }];

}

- (IBAction)onChoosePic:(UIButton *)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [IPaAlertView IPaAlertViewWithTitle:@"Warning!" message:@"Device Not Support Camera!" cancelButtonTitle:@"確定"];
        return;
    }
    if (imgPicker == nil) {
        imgPicker = [[UIImagePickerController alloc] init];
        
        imgPicker.delegate = self;
    }
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [delegate onNewNoteShowImagePicker:imgPicker];
}
- (IBAction)onTakePicture:(UIButton *)sender {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [IPaAlertView IPaAlertViewWithTitle:@"Warning!" message:@"Device Not Support Camera!" cancelButtonTitle:@"確定"];
        return;
    }
    if (imgPicker == nil) {
        imgPicker = [[UIImagePickerController alloc] init];

        imgPicker.delegate = self;
    }
    imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;     
    [delegate onNewNoteShowImagePicker:imgPicker];
    
}

- (IBAction)onCloseTagsView:(UIButton *)sender {
    NSMutableString *tagString = [@"" mutableCopy];
    for (NSString *tag in tagsSelectView.selectedTagList) {
        if ([tagString isEqualToString:@""]) {
            [tagString appendString:tag];
        }
        else {
            [tagString appendFormat:@",%@",tag];
        }
    }

    [tagsField setText:tagString];
    
    [UIView animateWithDuration:0.3 animations:^(){
        tagsSelectView.transform = CGAffineTransformMakeTranslation(tagsSelectView.frame.size.width, 0);
    }completion:^(BOOL finished){
        [tagsSelectView removeFromSuperview];
    }];
     
    
}

-(void)onShowKeyBoard:(NSNotification*)noti
{
    NSDictionary* userInfo = [noti userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    
    // Animate up or down
    UIViewAnimationOptions animOptions;
    switch (animationCurve) {
        case UIViewAnimationCurveEaseInOut:
            animOptions = UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            animOptions = UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            animOptions = UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            animOptions = UIViewAnimationOptionCurveLinear;
            break;
    }
    
    [UIView animateWithDuration:animationDuration delay:0 options:animOptions 
                     animations:^{
                         listTableView.transform = CGAffineTransformMakeTranslation(0, -158);
                     }completion:^(BOOL finished){
                         
                     }];
}

-(void)onHideKeyBoard:(NSNotification*)noti
{

    NSDictionary* userInfo = [noti userInfo];
    
    // Get animation info from userInfo
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    
    
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    
    // Animate up or down
    UIViewAnimationOptions animOptions;
    switch (animationCurve) {
        case UIViewAnimationCurveEaseInOut:
            animOptions = UIViewAnimationOptionCurveEaseInOut;
            break;
        case UIViewAnimationCurveEaseIn:
            animOptions = UIViewAnimationOptionCurveEaseIn;
            break;
        case UIViewAnimationCurveEaseOut:
            animOptions = UIViewAnimationOptionCurveEaseOut;
            break;
        case UIViewAnimationCurveLinear:
            animOptions = UIViewAnimationOptionCurveLinear;
            break;
    }
    
    [UIView animateWithDuration:animationDuration delay:0 options:animOptions 
                     animations:^{
                         listTableView.transform = CGAffineTransformIdentity;
                     }completion:^(BOOL finished){
                         
                     }];

}
#pragma mark - UITextFieldDelgate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == mapSearchTextField) {
        return;
    }
    self.isEditing = YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == mapSearchTextField) {
        if (textField.text == nil || [textField.text isEqualToString:@""]) {
            return;
        }
        //作搜尋
        
        CLLocation *userLoc = [[CLLocation alloc] initWithLatitude:mapView.userLocation.coordinate.latitude longitude:mapView.userLocation.coordinate.longitude];
        
        NSString *urlString = [NSString stringWithFormat:GOOGLE_PLACE_API,userLoc.coordinate.latitude,userLoc.coordinate.longitude,mapSearchTextField.text,GOOGLE_API_KEY];
        [IPaURLRequest IPaURLRequestWithURL:urlString cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20 callback:^(NSURLResponse* response,NSData* responseData){
            NSError* error;
            NSDictionary* json = [NSJSONSerialization 
                                  JSONObjectWithData:responseData //1
                                  options:kNilOptions 
                                  error:&error];
            NSArray *mapList = [json objectForKey:@"results"];
            NSMutableArray *mapDataList = [NSMutableArray arrayWithCapacity:mapList.count];
            
            
            for (NSDictionary* resultData in mapList) {
                NSDictionary *location = [[resultData objectForKey:@"geometry"] objectForKey:@"location"];
                MapData *data = [[MapData alloc] init];
                [data setCoordinate:CLLocationCoordinate2DMake([[location objectForKey:@"lat"] doubleValue], [[location objectForKey:@"lng"] doubleValue])];
                data.title = [resultData objectForKey:@"name"];
                NSString *reference = [resultData objectForKey:@"reference"];
                
                [IPaURLRequest IPaURLRequestWithURL:[NSString stringWithFormat:GOOGLE_DETAIL_LOCATION_API,reference ,GOOGLE_API_KEY] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20 callback:^(NSURLResponse* res ,NSData* resData){
                    NSError* err;
                    NSDictionary *njson = [NSJSONSerialization 
                                           JSONObjectWithData:resData //1
                                           options:kNilOptions 
                                           error:&err];
                    njson = [njson objectForKey:@"result"];
                    if (njson != nil) {
                        data.subtitle = [njson objectForKey:@"formatted_address"];
                        if ([mapView.selectedAnnotations count] == 0) {

                            [mapView setSelectedAnnotations:[NSArray arrayWithObject:data]];
                        }
                        
                    }
                    
                }];
                
                
                
                
                [mapDataList addObject:data];
            }
            if ([mapView.annotations count] > 0) {
                [mapView removeAnnotations:mapView.annotations];
            }
            [mapView addAnnotations:mapDataList];
            
        }];

        
        
        return;
    }
    self.isEditing = NO;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string { 
    
    if (textField != moneyField) {
        return YES;
    }
    
    return [string isEqualToString:@""] || 
    ([string stringByTrimmingCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].length > 0);
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // UIImage *newImg = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
    
    [imgPicker dismissViewControllerAnimated:YES completion:^(){
        
        //建立新的note
       // [[NSBundle mainBundle] loadNibNamed:@"NewNoteEditView" owner:self options:nil];
        
        
    self.image = image;
        
        
    //    newNoteEditView.transform = CGAffineTransformMakeTranslation(newNoteEditView.frame.size.width, 0);
//        [contentView addSubview:newNoteEditView];
//        
//        [UIView animateWithDuration:0.3 animations:^(){
//            newNoteEditView.transform = CGAffineTransformIdentity;
//            
//        }];
        
    }];
    NSLog(@"Picture Take!");
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [imgPicker dismissViewControllerAnimated:YES completion:^(){
        imgPicker = nil;
    }];
    
    
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}
#pragma mark - MKMapViewDelegate


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MapData *data = (MapData*)view.annotation;

    [mapViewAddressLabel setText:[NSString stringWithFormat:@"%@%@",SELECTEDADDRESS_LABEL,data.subtitle]];
    
   
}
- (MKAnnotationView *)mapView:(MKMapView *)_mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    static NSString *identifier = @"MapDataObject";   
    if ([annotation isKindOfClass:[MapData class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            
            annotationView.animatesDrop = YES;
            
            
        } else {
            annotationView.animatesDrop = NO;
            annotationView.animatesDrop = YES;
            annotationView.annotation = annotation;
            
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
       
        
        return annotationView;
    }
    
    return nil;    
}

-(void) mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
}

- (void)mapView:(MKMapView *)_mapView didAddAnnotationViews:(NSArray *)views
{
    //    for (MKAnnotationView *av in views) {
    //        if ([av.annotation isKindOfClass:[DigitalMapObject class]]) {
    //           // DigitalMapObject *pushpin = (DigitalMapObject *)av.annotation;
    //            [mapView selectAnnotation:av.annotation animated:YES];
    //            break;  //or return;
    //        }
    //    }
}
@end
