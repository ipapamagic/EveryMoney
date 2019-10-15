//
//  EverNoteController.h
//  EverMoney
//
//  Created by  on 12/7/14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EvernoteSDK.h"
#define EVERMONEY_NOTEBOOK_NAME @"EverMoney"

#define EVERMONEY_DEFAULT_CONTENT_TEXT @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\"><en-note>Price:%@<br/>Due-Date:%@<br/>Location:%@<br/>Check:%@<br/></en-note>"
#define EVERMONEY_DEFAULT_CONTENT_WITH_IMAGE @"<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml.dtd\"><en-note>Price:%@<br/>Due-Date:%@<br/>Location:%@<br/>Check:%@<br/><en-media type=\"image/jpeg\" hash=\"%@\"/></en-note>"
#define GOOGLE_API_KEY @"AIzaSyCCwZNEd4s7bNSKXT9LN8U0sW5QPaMfggA"
#define GOOGLE_PLACE_API @"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=500&name=%@&sensor=true&key=%@"
#define GOOGLE_DETAIL_LOCATION_API @"https://maps.googleapis.com/maps/api/place/details/json?reference=%@&sensor=true&key=%@"
#define SELECTEDADDRESS_LABEL @"選擇位置："
#define GOOGLE_MAP_ADDRESS_API @"http://maps.googleapis.com/maps/api/geocode/json?address=%@&latlng=%f,%f&sensor=true"


//實際上的時候要改成  #define EVERNOTE_HOST @"www.evernote.com"
#define EVERNOTE_HOST @"sandbox.evernote.com"
//host  shardID guid
#define EVERNOTE_THUMBNAIL_LINK @"https://%@/shard/%@/thm/note/%@"
// Fill in the consumer key and secret with the values that you received from Evernote
// To get an API key, visit http://dev.evernote.com/documentation/cloud/
#define CONSUMER_KEY @"ipapa-4978"
#define CONSUMER_SECRET @"2522321ada402eac"

#define EvernoteNoteContentUpdateNotification @"EvernoteNoteContentUpdateNotification"
#define EvernoteNoteThumbnailUpdateNotification @"EvernoteNoteThumbnailUpdateNotification"
@interface EverNoteController : NSObject
{
    
}
@property (nonatomic,strong) NSMutableDictionary *evernoteCacheData;
@property (nonatomic,strong) EDAMNotebook* everMoneyNoteBook;
+(EDAMNotebook*) defaultNoteBook;
+(EverNoteController*) defaultEverNoteController;
+(void)evernoteAuthenticate:(UIViewController*)viewController withSuccees:(void(^)())succees;

+(void)createNoteWithTitle:(NSString*)title Price:(NSString*)Price DueDate:(NSString*)DueDate Location:(NSString*)Location WithImage:(UIImage*)image withTags:(NSString *)tags withCallback:(void (^)(EDAMNote*))callback;
+(void)updateNote:(EDAMNote*)note WithTitle:(NSString*)title Price:(NSString*)Price DueDate:(NSString*)DueDate Location:(NSString*)Location withTags:(NSString*)tags isCheck:(BOOL)isCheck withCallback:(void (^)(EDAMNote*))callback;
+(void)listUsedTagsWithsuccess:(void(^)(NSArray *tags))success
                       failure:(void(^)(NSError *error))failure;
+(void)listTagsWithsuccess:(void(^)(NSArray *tags))success
                    failure:(void(^)(NSError *error))failure;
+ (void)createTag:(NSString*)tag
          success:(void(^)(EDAMTag *tag))success
          failure:(void(^)(NSError *error))failure;
+(void)searchText:(NSString*)text success:(void (^)(NSArray* list))success;
+(void)getNoteWithNoteGuid:(EDAMGuid)noteGuid withCallback:(void (^)(EDAMNote*))callback;

+(void)getNoteThumbNailWithGuid:(EDAMGuid)noteGuid withCallback:(void (^)(UIImage*))callback;
+(void)getBillFromNote:(EDAMNote*)note withCallback:(void (^)(NSString*))callback;
+(void)getDueDateFromNote:(EDAMNote*)note withCallback:(void (^)(NSString*))callback;
+(void)getContentFromNote:(EDAMNote*)note withCallback:(void (^)(NSString*))callback;
+(void)findNotes:(void (^)(NSArray*))callback;
+(NSString*)readBillStringFromContent:(NSString*)content;
+(NSString*)readDueDateStringFromContent:(NSString*)content;
+(NSString*)readLocationStringFromContent:(NSString*)content;
+(BOOL)readCheckStringFromContent:(NSString*)content;
+(void)getTagNamesFromNoteGuid:(EDAMGuid)noteGuid withCallback:(void (^)(NSArray*))callback;
+(void)getNoteResourceImageWithNote:(EDAMNote*)note withCallback:(void (^)(NSData*))callback;
+(void)getCheckStateFromNote:(EDAMNote*)note withCallback:(void (^)(BOOL))callback;
+(void)checkNoteWithNoteGuid:(EDAMGuid)noteID;
+(void)addTimeRemiderForNote:(EDAMNote*)note;
@end
