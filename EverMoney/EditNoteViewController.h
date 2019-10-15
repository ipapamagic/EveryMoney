//
//  EditNoteViewController.h
//  EverMoney
//
//  Created by  on 12/7/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EDAMNote;
@interface EditNoteViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    IBOutlet UIImageView *imageView;
}
-(void)takePicture;

@property (nonatomic,strong) EDAMNote* currentNote;

- (IBAction)onBack:(UIButton *)sender;
- (IBAction)onSave:(UIButton *)sender;

@end
