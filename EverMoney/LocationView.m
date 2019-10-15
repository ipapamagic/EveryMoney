//
//  LocationView.m
//  EverMoney
//
//  Created by  on 12/7/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LocationView.h"
#import "IPaURLRequest.h"
#import "EverNoteController.h"
#import "MapData.h"
@implementation LocationView

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
        [mapView setShowsUserLocation:YES];
        
        
        EvernoteNoteStore *noteStore = [EvernoteNoteStore noteStore];
        EDAMNoteFilter *filter = [[EDAMNoteFilter alloc] init];
        filter.order = NoteSortOrder_TITLE;
         
        [filter setNotebookGuid:[EverNoteController defaultNoteBook].guid];
        // EDAMNotesMetadataResultSpec *spec = [[EDAMNotesMetadataResultSpec alloc] initWithIncludeTitle:YES includeContentLength:YES includeCreated:YES includeUpdated:YES includeUpdateSequenceNum:YES includeNotebookGuid:YES includeTagGuids:YES includeAttributes:YES includeLargestResourceMime:YES includeLargestResourceSize:YES];
        
        [noteStore findNoteCountsWithFilter:filter withTrash:NO success:^(EDAMNoteCollectionCounts *counts){
            [noteStore findNotesWithFilter:filter offset:0 maxNotes:counts.notebookCounts.allValues.count success:^(EDAMNoteList* list){
                for (EDAMNote *note in list.notes) {
                   // NSLog(@"noteGUID:%@",note.title);
                    [noteStore getNoteWithGuid:note.guid withContent:YES withResourcesData:NO withResourcesRecognition:NO withResourcesAlternateData:NO success:^(EDAMNote* fullNote){
                       // NSLog(@"noteGUID:%@",fullNote.tagGuids);
                        NSLog(@"FUll:%@",fullNote.content);
                        NSRange range = [fullNote.content rangeOfString:@"Location:"];
                        NSString *substring = [fullNote.content substringFromIndex:range.location + range.length];
                        range = [substring rangeOfString:@"<br/>"];
                        substring = [substring substringToIndex:range.location];
                        //NSInteger address = [substring integerValue];
                        
                        CLLocation *userLoc = [[CLLocation alloc] initWithLatitude:mapView.userLocation.coordinate.latitude longitude:mapView.userLocation.coordinate.longitude];
                        NSString *address = [substring stringByReplacingOccurrencesOfString:@" " withString:@"+"];
                        
                        [IPaURLRequest IPaURLRequestWithURL:[NSString stringWithFormat:GOOGLE_MAP_ADDRESS_API,address,userLoc.coordinate.latitude,userLoc.coordinate.longitude] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20 callback:^(NSURLResponse* response,NSData* responseData){
                            NSError* error;
                            NSDictionary* json = [NSJSONSerialization 
                                                  JSONObjectWithData:responseData //1
                                                  options:kNilOptions 
                                                  error:&error];
                            NSDictionary *location = [[json objectForKey:@"geometry"] objectForKey:@"location"];                            
                            MapData *data = [[MapData alloc] init];
                            [data setCoordinate:CLLocationCoordinate2DMake([[location objectForKey:@"lat"] doubleValue], [[location objectForKey:@"lng"] doubleValue])];
                            
                            data.title = substring;
                            

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
                        

                        
                        
                    }failure:^(NSError* err)
                     {
                         NSLog(@"Error!!!:%@",err);
                     }];
                }
                
            }failure:^(NSError *error){
                NSLog(@"Error!!!:%@",error);
            }];
        }failure:^(NSError *error){
            NSLog(@"Error!!!:%@",error);               
        }];

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

@end
