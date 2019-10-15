//
//  EverNoteController.m
//  EverMoney
//
//  Created by  on 12/7/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EverNoteController.h"
#import "IPaAlertView.h"
#import "IPaURLRequest.h"
#import "IPaNetworkState.h"
#import <CommonCrypto/CommonDigest.h>
EverNoteController *defaultEverNoteController;
@interface EverNoteController ()

@property (nonatomic,copy) NSString *shardId;
@property (nonatomic,strong) NSMutableArray* tagsList;
@property (nonatomic,strong) NSMutableArray* noteContentRequestList;
@end
@implementation EverNoteController
{
   
}
@synthesize shardId;
@synthesize evernoteCacheData;
@synthesize everMoneyNoteBook;
@synthesize tagsList;
@synthesize noteContentRequestList;
+(void)evernoteAuthenticate:(UIViewController*)viewController withSuccees:(void(^)())succees
{
    EvernoteSession *session = [EvernoteSession sharedSession];
    [IPaNetworkState startNetworking];
    [session authenticateWithViewController:viewController completionHandler:^(NSError *error) {

        if (error || !session.isAuthenticated) {
            [IPaAlertView IPaAlertViewWithTitle:@"Error!" message:@"Could not authenticate"  cancelButtonTitle:@"OK"];
            [IPaNetworkState endNetworking];            
        } else {
            NSLog(@"authenticated! noteStoreUrl:%@ webApiUrlPrefix:%@", session.noteStoreUrl, session.webApiUrlPrefix);
            
            
            //check booknote exists
            
            EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
            [noteStore listNotebooksWithSuccess:^(NSArray *notebooks) {

                EverNoteController *controller = [EverNoteController defaultEverNoteController];

                NSLog(@"NoteBook Num:%d",notebooks.count);
                for (EDAMNotebook *obj in notebooks) {
                   // NSLog(@"notebook: %@", obj);
                    
                    if ([obj.name isEqualToString:EVERMONEY_NOTEBOOK_NAME]) {
                        controller.everMoneyNoteBook = obj;
                        break;
                    }
                    
                }
                if (controller.everMoneyNoteBook == nil) {
                    //建立NoteBook
                    EDAMNotebook *notebook = [[EDAMNotebook alloc] init];
                    notebook.name = EVERMONEY_NOTEBOOK_NAME;
                    [noteStore createNotebook:notebook success:^(EDAMNotebook *notebook){
                        NSLog(@"Notebook create succeed!");
                        succees();
                        controller.everMoneyNoteBook = notebook;
                        [IPaNetworkState endNetworking];
                    }failure:^(NSError* error){
                        [IPaNetworkState endNetworking];
                        NSLog(@"Notebook create fail!");
                    }];
                    
                }
                else {
                    [IPaNetworkState endNetworking];
                    succees();
                }
                
            }
            failure:^(NSError *error) {
                [IPaNetworkState endNetworking];
                NSLog(@"error %@", error);                                            
            }];
            
            
            
            
        } 
    }];
}
+(EverNoteController*)defaultEverNoteController
{
    if (defaultEverNoteController == nil) {
        defaultEverNoteController = [[EverNoteController alloc] init];
        
        defaultEverNoteController.evernoteCacheData = [NSMutableDictionary dictionary];
        defaultEverNoteController.shardId = nil;
        defaultEverNoteController.tagsList = nil;
        defaultEverNoteController.noteContentRequestList = [NSMutableArray array];
    }
    return defaultEverNoteController;
}
+(EDAMNotebook*) defaultNoteBook
{
    return [EverNoteController defaultEverNoteController].everMoneyNoteBook;
}
+(void)updateNote:(EDAMNote*)note WithTitle:(NSString*)title Price:(NSString*)Price DueDate:(NSString*)DueDate Location:(NSString*)Location withTags:(NSString*)tags isCheck:(BOOL)isCheck withCallback:(void (^)(EDAMNote*))callback
{
    note.title = title;
    [self getContentFromNote:note withCallback:^(NSString* content){
        //先取得目前的content
        
        NSRange range = [content rangeOfString:@"Price:"];
        NSInteger start = range.location + range.length;
        NSString *subString = [content substringFromIndex:start];
        range = [subString rangeOfString:@"<br/>"];
        content = [content stringByReplacingCharactersInRange:NSMakeRange(start, range.location) withString:Price];
        
        range = [content rangeOfString:@"Due-Date:"];
        start = range.location + range.length;
        subString = [content substringFromIndex:start];
        range = [subString rangeOfString:@"<br/>"];
        content = [content stringByReplacingCharactersInRange:NSMakeRange(start, range.location) withString:DueDate];
        
        
        range = [content rangeOfString:@"Location:"];
        start = range.location + range.length;
        subString = [content substringFromIndex:start];
        range = [subString rangeOfString:@"<br/>"];
        content = [content stringByReplacingCharactersInRange:NSMakeRange(start, range.location) withString:Location];
        
        
        range = [content rangeOfString:@"Check:"];
        start = range.location + range.length;
        subString = [content substringFromIndex:start];
        range = [subString rangeOfString:@"<br/>"];
        content = [content stringByReplacingCharactersInRange:NSMakeRange(start, range.location) withString:(isCheck)?@"YES":@"NO"];

        
        
        
        
        note.content = content;
        

        
        if (tags != nil && ![tags isEqualToString:@""]) {
            note.tagNames = [tags componentsSeparatedByString:@","];
        }
        //先update
        [[NSNotificationCenter defaultCenter] postNotificationName:EvernoteNoteContentUpdateNotification object:[EverNoteController defaultEverNoteController] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:note,@"Note", nil]];
        
        
        EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
        [noteStore updateNote:note success:^(EDAMNote* newNote){
            NSLog(@"update Complete!!");
            [[EverNoteController defaultEverNoteController].evernoteCacheData setObject:newNote forKey:newNote.guid];
            //在post一次
            [[NSNotificationCenter defaultCenter] postNotificationName:EvernoteNoteContentUpdateNotification object:[EverNoteController defaultEverNoteController] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:newNote,@"Note", nil]];                
            callback(newNote);
        }failure:^(NSError *error){
            NSLog(@"update Fail! %@",error);
            callback(nil);
        }];
        

    }];
    
}
+(void)createNoteWithTitle:(NSString*)title Price:(NSString*)Price DueDate:(NSString*)DueDate Location:(NSString*)Location WithImage:(UIImage*)image withTags:(NSString *)tags withCallback:(void (^)(EDAMNote*))callback
{
    EDAMNote *newNote = [[EDAMNote alloc] init];
    newNote.title = title;
    
    
    if (image != nil) {
        
        if (image.imageOrientation != UIImageOrientationUp) {
            CGFloat radius = 0;
            CGSize newSize = image.size;
            
            switch (image.imageOrientation) {
                case UIImageOrientationRight:
                  //  radius = 90 * M_PI/180;
                    newSize = CGSizeMake(image.size.height, image.size.width);
                    
                    
                    
                    break;
                case UIImageOrientationLeft:
                   // radius = -90 * M_PI/180;
                    newSize = CGSizeMake(image.size.height, image.size.width);
                    break;
                case UIImageOrientationDown:
                    //radius = M_PI;
                    
                    break;                
                default:
                    break;
            }
            UIGraphicsBeginImageContext(CGSizeMake(image.size.height, image.size.width));
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, image.size.width * 0.5, image.size.height * 0.5);
            CGContextRotateCTM (context, radius);
            [image drawAtPoint:CGPointMake(-image.size.width * 0.5, -image.size.height * 0.5)];
            
            image = UIGraphicsGetImageFromCurrentImageContext();
            
            image = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUp];
        }
        
        
        EDAMResource *newResource = [[EDAMResource alloc] init];
        newResource.mime = @"image/jpeg";
        EDAMData *data = [[EDAMData alloc] init];
        
        
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        data.size = imageData.length;
        data.body = imageData;
        newResource.data = data;
        newResource.attributes = [[EDAMResourceAttributes alloc] init];
        newResource.attributes.fileName = @"img";
        
        
        //產生hash
        unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
        
        // Create 16 byte MD5 hash value, store in buffer
        CC_MD5(imageData.bytes, imageData.length, md5Buffer);
        
        // Convert unsigned char buffer to NSString of hex values
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
            [output appendFormat:@"%02x",md5Buffer[i]];
        
        data.bodyHash = [output dataUsingEncoding:NSUTF8StringEncoding];

        
        newNote.content = [NSString stringWithFormat:EVERMONEY_DEFAULT_CONTENT_WITH_IMAGE,Price,DueDate,Location,@"NO",output];
        [newNote setResources:[NSArray arrayWithObject:newResource]];
    }
    else {
        newNote.content = [NSString stringWithFormat:EVERMONEY_DEFAULT_CONTENT_TEXT,Price,DueDate,Location,@"NO"];
        
    }
    
    if (tags != nil && ![tags isEqualToString:@""]) {
        newNote.tagNames = [tags componentsSeparatedByString:@","];
    }

    
    newNote.notebookGuid = [EverNoteController defaultNoteBook].guid;


    
    NSLog(@"newNote content:%@",newNote.content);
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    

    
    [IPaNetworkState startNetworking];
    [noteStore createNote:newNote success:^(EDAMNote* newNote){
        NSLog(@"CreateNote Complete!!");
        [[EverNoteController defaultEverNoteController].evernoteCacheData setObject:newNote forKey:newNote.guid];
        callback(newNote);
        [IPaNetworkState endNetworking];
    }failure:^(NSError *error){
        [IPaNetworkState endNetworking];
        NSLog(@"CreateNote Fail! %@",error);
        callback(nil);
    }];
    
    
    
    
}
+(void)listUsedTagsWithsuccess:(void(^)(NSArray *tags))success
                       failure:(void(^)(NSError *error))failure
{
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    [noteStore listTagsByNotebookWithGuid:[EverNoteController defaultNoteBook].guid success:success failure:failure];
     
}
+(void)listTagsWithsuccess:(void(^)(NSArray *tags))success
                   failure:(void(^)(NSError *error))failure
{
    
    if ([self defaultEverNoteController].tagsList != nil) {
        success([self defaultEverNoteController].tagsList);
        return;
    }
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    [IPaNetworkState startNetworking];
    [noteStore listTagsWithSuccess:^(NSArray *tagList){
        [IPaNetworkState endNetworking];
        [self defaultEverNoteController].tagsList = [tagList mutableCopy];
        success(tagList);
    } failure:^(NSError* error){
        [IPaNetworkState endNetworking];        
        failure(error);
    }];
}

+ (void)createTag:(NSString *)tag
          success:(void(^)(EDAMTag *tag))success
          failure:(void(^)(NSError *error))failure
{
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    EDAMTag *newTag = [[EDAMTag alloc] init];
    newTag.name = tag;
    
    [noteStore createTag:newTag success:success failure:failure];
}

+(void)searchText:(NSString*)text success:(void (^)(NSArray* list))success 
{
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    
    

    EDAMNoteFilter *filter = [[EDAMNoteFilter alloc] init];
    [filter setNotebookGuid:[EverNoteController defaultNoteBook].guid];
    filter.words = text;
    [IPaNetworkState startNetworking];    
    [noteStore findNoteCountsWithFilter:filter withTrash:NO success:^(EDAMNoteCollectionCounts* counts){
        
        NSNumber *noteCount = [counts.notebookCounts objectForKey:[EverNoteController defaultNoteBook].guid];        
        [noteStore findNotesWithFilter:filter offset:0 maxNotes:[noteCount integerValue] success:^(EDAMNoteList* list){
            
            [IPaNetworkState endNetworking];
            NSMutableArray *noteIDList = [NSMutableArray arrayWithCapacity:list.notes.count];
            for (EDAMNote *note in list.notes) {
                EDAMNote *cacheNote = [[self defaultEverNoteController].evernoteCacheData objectForKey:note.guid];
                if (cacheNote == nil) {
                    [[self defaultEverNoteController].evernoteCacheData setObject:note forKey:note.guid];
                }
                [noteIDList addObject:note.guid];
            }
            
            success(noteIDList);
            
        }failure:^(NSError* error){
            [IPaNetworkState endNetworking];
            NSLog(@"Error!! %@",error );            
        }];
    }failure:^(NSError* error){
        [IPaNetworkState endNetworking];
        NSLog(@"Error!! %@",error );
    }];
}
+(void)getNoteWithNoteGuid:(EDAMGuid)noteGuid withCallback:(void (^)(EDAMNote*))callback
{
    EDAMNote *note = [[EverNoteController defaultEverNoteController].evernoteCacheData objectForKey:noteGuid];
    if (note == nil) {
        [IPaNetworkState startNetworking];
        [[EvernoteNoteStore noteStore] getNoteWithGuid:noteGuid withContent:NO withResourcesData:NO withResourcesRecognition:NO withResourcesAlternateData:NO success:^(EDAMNote*note){
            
            [[EverNoteController defaultEverNoteController].evernoteCacheData setObject:note forKey:noteGuid];
            
            callback(note);
            [IPaNetworkState endNetworking];
        }failure:^(NSError* error)
        {
            [IPaNetworkState endNetworking];            
            NSLog(@"get note error!! %@",error);
        }];
    }
    else {
        callback(note);
    }
}

+(void)getNoteThumbNailWithGuid:(EDAMGuid)noteGuid withCallback:(void (^)(UIImage*))callback
{
    

    void (^RequestThumbnail)() = ^(){
        NSString *urlString = [NSString stringWithFormat:EVERNOTE_THUMBNAIL_LINK,EVERNOTE_HOST,[EverNoteController defaultEverNoteController].shardId,noteGuid];
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.cachePolicy = NSURLRequestReloadRevalidatingCacheData;
        
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-type"];
        [request setValue:EVERNOTE_HOST forHTTPHeaderField:@"Host"];
        [request setHTTPMethod:@"POST"];
        NSString *httpBody = [[NSString alloc] initWithFormat:@"auth=%@",[EvernoteSession sharedSession].authenticationToken];
        [request setHTTPBody:[httpBody dataUsingEncoding:NSUTF8StringEncoding]];
        
        [IPaURLRequest IPaURLRequestWithURLRequest:request callback:^(NSURLResponse *response,NSData* responseData){
            //NSLog(@"%@",responseData);
            UIImage *image = [UIImage imageWithData:responseData];
            callback(image);
            [[NSNotificationCenter defaultCenter] postNotificationName:EvernoteNoteThumbnailUpdateNotification object:[EverNoteController defaultEverNoteController] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:image,@"Image",noteGuid,@"NoteGuid", nil]];
            
            
            
        }failCallback:nil receiveCallback:nil reveiveData:nil];
        
    };
    
    if ([EverNoteController defaultEverNoteController].shardId == nil) {
        [IPaNetworkState startNetworking];
        EvernoteUserStore *userStore = [EvernoteUserStore userStore];
        [userStore getUserWithSuccess:^(EDAMUser *user){
            [IPaNetworkState endNetworking];
            [EverNoteController defaultEverNoteController].shardId = user.shardId;
            RequestThumbnail();
            
        }failure:^(NSError* error){
            [IPaNetworkState endNetworking]; 
        }];
    }
    else {
        RequestThumbnail();
    }
    
}
+(void)getCheckStateFromNote:(EDAMNote*)note withCallback:(void (^)(BOOL))callback
{
    [self getContentFromNote:note withCallback:^(NSString* content){
        if (content == nil) {
            callback(NO);
            return;
        }
        callback([self readCheckStringFromContent:content]);
        
    }];

}
+(void)getBillFromNote:(EDAMNote*)note withCallback:(void (^)(NSString*))callback
{
    [self getContentFromNote:note withCallback:^(NSString* content){
        if (content == nil) {
            callback(nil);
            return;
        }
        callback([self readBillStringFromContent:content]);

    }];

}
+(void)getDueDateFromNote:(EDAMNote*)note withCallback:(void (^)(NSString*))callback
{
    
    [self getContentFromNote:note withCallback:^(NSString* content){
        if (content == nil) {
            callback(nil);
            return;
        }
        callback([self readDueDateStringFromContent:note.content]);

    }];


}


+(void)getContentFromNote:(EDAMNote*)note withCallback:(void (^)(NSString*))callback
{
    if (note.content == nil) {
        if ([[self defaultEverNoteController].noteContentRequestList indexOfObject:note.guid] != NSNotFound ) {
            return;
        }
        [[self defaultEverNoteController].noteContentRequestList addObject:note.guid];
        
        [IPaNetworkState startNetworking];
        EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
        [noteStore getNoteContentWithGuid:note.guid success:^(NSString* content){
            note.content = content;
            [[NSNotificationCenter defaultCenter] postNotificationName:EvernoteNoteContentUpdateNotification object:[EverNoteController defaultEverNoteController] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:note,@"Note", nil]];
            if (callback != nil)
                callback(content);
            [IPaNetworkState endNetworking];
            [[self defaultEverNoteController].noteContentRequestList removeObject:note.guid];
            
        }failure:^(NSError *error){
            NSLog(@"Error! %@",error);
            [IPaNetworkState endNetworking];
            [[self defaultEverNoteController].noteContentRequestList removeObject:note.guid];            
        }];
       

    }
    else {
        if (callback != nil) {
            callback(note.content);
        }

    }
}
+(BOOL)readCheckStringFromContent:(NSString*)content
{
    NSRange range = [content rangeOfString:@"Check:"];
    if (range.location == NSNotFound) {
        return NO;
    }
    
    
    NSString *substring = [content substringFromIndex:range.location + range.length];
    range = [substring rangeOfString:@"<br/>"];
    substring = [substring substringToIndex:range.location];
    if ([substring isEqualToString:@"YES"]) {
        return YES;
    }
    return NO;
}
+(NSString*)readBillStringFromContent:(NSString*)content
{
    NSRange range = [content rangeOfString:@"Price:"];
    NSString *substring = [content substringFromIndex:range.location + range.length];
    range = [substring rangeOfString:@"Due-Date:"];
    substring = [substring substringToIndex:range.location-5];
    if ([substring isEqualToString:@""]) {
        return @"0";
    }
    return substring;
}
+(NSString*)readDueDateStringFromContent:(NSString*)content
{
    NSRange range = [content rangeOfString:@"Due-Date:"];
    NSString *substring = [content substringFromIndex:range.location + range.length];
    range = [substring rangeOfString:@"Location:"];
    return [substring substringToIndex:range.location-5];
    

}
+(NSString*)readLocationStringFromContent:(NSString*)content
{
    NSRange range = [content rangeOfString:@"Location:"];
    NSString *substring = [content substringFromIndex:range.location + range.length];
    range = [substring rangeOfString:@"<br/>"];
    return [substring substringToIndex:range.location];
    
}
+(void)findNotes:(void (^)(NSArray*))callback
{
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    EDAMNoteFilter *filter = [[EDAMNoteFilter alloc] init];
    filter.order = NoteSortOrder_TITLE;
    filter.notebookGuid = [EverNoteController defaultNoteBook].guid; 
    
    [IPaNetworkState startNetworking];
    [noteStore findNoteCountsWithFilter:filter withTrash:NO success:^(EDAMNoteCollectionCounts *counts){
        NSNumber *noteCount = [counts.notebookCounts objectForKey:[EverNoteController defaultNoteBook].guid];
        [noteStore findNotesWithFilter:filter offset:0 maxNotes:[noteCount integerValue] success:^(EDAMNoteList* list){
            
            
            [IPaNetworkState endNetworking];
            NSMutableArray *guidList = [NSMutableArray arrayWithCapacity:[list.notes count]];
            for (EDAMNote *note in list.notes) {
                [[EverNoteController defaultEverNoteController].evernoteCacheData setObject:note forKey:note.guid];
                [guidList addObject:note.guid];
            }
            callback(guidList);
        }failure:^(NSError *error){
            [IPaNetworkState endNetworking];
            NSLog(@"Error! %@",error);
            callback(nil);
        }];
    }failure:^(NSError *error){
        [IPaNetworkState endNetworking];
        NSLog(@"Error! %@",error);
    }];
}
+(void)getTagNamesFromNoteGuid:(EDAMGuid)noteGuid withCallback:(void (^)(NSArray*))callback;
{
    [self getNoteWithNoteGuid:noteGuid withCallback:^(EDAMNote* note){
        //取得tag 名稱
        if (note.tagNames != nil) {
            callback(note.tagNames);
            return;
        }
        EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
        [IPaNetworkState startNetworking];
        [noteStore getNoteTagNamesWithGuid:note.guid success:^(NSArray *names){
            
            note.tagNames = names;
            
            callback(names);
            
            [IPaNetworkState endNetworking];
        }failure:^(NSError* error){
            [IPaNetworkState endNetworking];
            NSLog(@"Error!  %@", error);
        }];
        
    }];
    
    
    
   

}
+(void)getNoteResourceImageWithNote:(EDAMNote*)note withCallback:(void (^)(NSData*))callback
{
    if ([note.resources count] <= 0) {
        callback(nil);
        return;
    }
    EDAMResource *resource = [note.resources objectAtIndex:0];
    if (resource.data.body != nil) {
      
        callback(resource.data.body);
        return;
    }
    
    
    EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
    [IPaNetworkState startNetworking];
    
    
    
    [noteStore getResourceWithGuid:resource.guid withData:YES withRecognition:NO withAttributes:YES withAlternateDate:NO success:^(EDAMResource *newResource){

        note.resources = [NSArray arrayWithObject:newResource];
        callback(newResource.data.body);
        
        [IPaNetworkState endNetworking];
    }failure:^(NSError *error){
        [IPaNetworkState endNetworking];        
        NSLog(@"Error! %@",error);
    }];
}


+(void)checkNoteWithNoteGuid:(EDAMGuid)noteID
{
    [self getNoteWithNoteGuid:noteID withCallback:^(EDAMNote* note){
        [self getContentFromNote:note withCallback:^(NSString* content){
            BOOL isCheck = [self readCheckStringFromContent:content];
            

            
            NSRange range = [content rangeOfString:@"Check:"];
            NSInteger start = range.location + range.length;
            NSString *subString = [content substringFromIndex:start];
            range = [subString rangeOfString:@"<br/>"];
            content = [content stringByReplacingCharactersInRange:NSMakeRange(start, range.location) withString:(isCheck)?@"NO":@"YES"];
            
            /*
            //將今天設成due date
            if (isCheck) {
                range = [content rangeOfString:@"Due-Date::"];
                start = range.location + range.length;
                subString = [content substringFromIndex:start];
                range = [subString rangeOfString:@"<br/>"];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"yyyy/MM/dd"];
                
                content = [content stringByReplacingCharactersInRange:NSMakeRange(start, range.location) withString:[formatter stringFromDate:[NSDate date]]];
            }
*/            
            
            
            //先update
            note.content = content;
            [[NSNotificationCenter defaultCenter] postNotificationName:EvernoteNoteContentUpdateNotification object:[EverNoteController defaultEverNoteController] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:note,@"Note", nil]];
            
            
            EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
            [noteStore updateNote:note success:^(EDAMNote* newNote){
                NSLog(@"update Complete!!");
                [[EverNoteController defaultEverNoteController].evernoteCacheData setObject:newNote forKey:newNote.guid];
                //在post一次
               // [[NSNotificationCenter defaultCenter] postNotificationName:EvernoteNoteContentUpdateNotification object:[EverNoteController defaultEverNoteController] userInfo:[NSDictionary dictionaryWithObjectsAndKeys:newNote,@"Note", nil]];                
            }failure:^(NSError *error){
                NSLog(@"update Fail! %@",error);
            }];

        
        
        }];
        
    }];
}
+(void)addTimeRemiderForNote:(EDAMNote*)note
{
    
    NSString *dueDate = [EverNoteController readDueDateStringFromContent:note.content];
    
    if ([dueDate isEqualToString:@""]) {
        return;
    }
    /*
    NSDictionary *userInfo = @{ @"ID" : note.guid };
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    NSDateFormatter
    
    
    
    
    localNotif.fireDate = Date;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
	// Notification details
    localNotif.alertBody = AlertBody;
	// Set the action button
    localNotif.alertAction = AlertAction;
    
    localNotif.soundName = SoundName;
    localNotif.applicationIconBadgeNumber = 1;
    
	// Specify custom data for the notification
    localNotif.userInfo = userInfo;
    UILocalNotification *call = [self createLocalNotification:userInfo AlertBody:wording AlertAction:@"Accept" atDate:callDate SoundName:[NSString stringWithFormat:@"%d.aif",ring]];
    call.repeatInterval = 0;
    [[UIApplication sharedApplication] scheduleLocalNotification:call];
*/
}
@end
