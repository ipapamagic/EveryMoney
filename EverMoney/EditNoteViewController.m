//
//  EditNoteViewController.m
//  EverMoney
//
//  Created by  on 12/7/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EditNoteViewController.h"
#import "IPaAlertView.h"
#import "EverNoteController.h"
@interface EditNoteViewController ()

@end

@implementation EditNoteViewController
{
    UIImagePickerController *imgPicker;
}
@synthesize currentNote;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    imageView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([currentNote.resources count] == 0) {
        //沒有圖片
        return;
    }
    EDAMResource *resources = [currentNote.resources objectAtIndex:0];
    UIImage *image = [UIImage imageWithData: resources.data.body];

    [imageView setImage:image];
    
    

}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(void)takePicture
{
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [IPaAlertView IPaAlertViewWithTitle:@"Warning!" message:@"Device Not Support Camera!" cancelButtonTitle:@"確定"];
        return;
    }
    if (imgPicker == nil) {
        imgPicker = [[UIImagePickerController alloc] init];
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imgPicker.delegate = self;
    }
    
    [self presentViewController:imgPicker animated:YES completion:nil];
    
}

- (IBAction)onBack:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onSave:(UIButton *)sender {
    
    if (self.currentNote.guid == nil) {
        //create
        EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
        [noteStore createNote:self.currentNote success:^(EDAMNote* newNote){
            NSLog(@"Done!!");
        }failure:^(NSError *error){
            NSLog(@"shit! %@",error);
        }];
        NSLog(@"ttttt:%@",self.currentNote.guid);
    }
    NSLog(@"????");
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{/*
    if (self.currentNote == nil) {
        self.currentNote = [[EDAMNote alloc] init];
    }
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imgPicker dismissViewControllerAnimated:YES completion:^(){
        
        self.image = image;
        
    }];*/
    NSLog(@"Picture Take!");
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (self.currentNote == nil) {
       
    }
    [imgPicker dismissViewControllerAnimated:NO completion:nil];
    
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

@end



