//
//  IPaURLRequest.h
//  IPaURLRequest
//
//  Created by 陳 尤中 on 11/10/27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
// callback format is    - (void) xxxxxx : (IPaURLRequest*)sender:sender isSucceed:(BOOL)isSucceed;

#import <Foundation/Foundation.h>

@interface IPaURLRequest : NSObject {
    
    NSMutableData *responseData;
//    NSDictionary *responseHeader;
    NSURLResponse *response;
    NSURLConnection *theConnection;
//    NSInvocation *Callback;
//    NSInvocation *recCallback;
//    id userData;
    void (^Callback)(NSURLResponse*,NSData*);
    void (^FailCallback)();
    void (^RecCallback)(NSURLResponse*,NSData*,NSData*);    
    
}
/*
- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval
           target:(id)target
         callback:(SEL)callback;
- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval
           target:(id)target
         callback:(SEL)callback
  receiveCallback:(SEL)receiveCallback;


//若希望將資料存到指定的NSMutableData,可直接將物件丟入reveiveData
- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval
           target:(id)target
         callback:(SEL)callback
  receiveCallback:(SEL)receiveCallback
      reveiveData:(NSMutableData*)receiveData;

+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                    target:(id)target
                  callback:(SEL)callback;
+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                    target:(id)target
                  callback:(SEL)callback
                  userData:(id)userData;
+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                    target:(id)target
                  callback:(SEL)callback
           receiveCallback:(SEL)receiveCallback
                  userData:(id)userData;


+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                    target:(id)target
                  callback:(SEL)callback
           receiveCallback:(SEL)receiveCallback
               receiveData:(NSMutableData*)receiveData
                  userData:(id)userData;
 */
- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval   
         callback:(void (^)(NSURLResponse *,NSData*))callback;

- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval   
         callback:(void (^)(NSURLResponse *,NSData*))callback
     failCallback:(void (^)())failCallback;

- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval
         callback:(void (^)(NSURLResponse *,NSData*))callback
     failCallback:(void (^)())failCallback
  receiveCallback:(void (^)(NSURLResponse *,NSData*,NSData*))receiveCallback;


//若希望將資料存到指定的NSMutableData,可直接將物件丟入reveiveData
- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval
         callback:(void (^)(NSURLResponse *,NSData*))callback
     failCallback:(void (^)())failCallback
  receiveCallback:(void (^)(NSURLResponse*,NSData*,NSData*))receiveCallback
      reveiveData:(NSMutableData*)receiveData;

- (id)initWithURLRequest:(NSURLRequest*)request
                callback:(void (^)(NSURLResponse *,NSData*))callback
            failCallback:(void (^)())failCallback
         receiveCallback:(void (^)(NSURLResponse *,NSData *,NSData*))receiveCallback
             reveiveData:(NSMutableData*)receiveData;



+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                  callback:(void (^)(NSURLResponse *,NSData*))callback;

+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                  callback:(void (^)(NSURLResponse *,NSData*))callback
              failCallback:(void (^)())failCallback;

+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                  callback:(void (^)(NSURLResponse *,NSData* ))callback
              failCallback:(void (^)())failCallback
           receiveCallback:(void (^)(NSURLResponse *,NSData*,NSData* ))receiveCallback;


+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                  callback:(void (^)(NSURLResponse *,NSData* ))callback
              failCallback:(void (^)())failCallback
           receiveCallback:(void (^)(NSURLResponse *,NSData*,NSData* ))receiveCallback
               receiveData:(NSMutableData*)receiveData;

+ (id)IPaURLRequestWithURLRequest:(NSURLRequest*)request
                         callback:(void (^)(NSURLResponse *,NSData*))callback
                     failCallback:(void (^)())failCallback
                  receiveCallback:(void (^)(NSURLResponse *,NSData*,NSData*))receiveCallback
                      reveiveData:(NSMutableData*)receiveData;




-(void) StartConnect;
-(void) CancelConnect;
//@property (nonatomic,strong) NSMutableData *responseData;
//@property (nonatomic,strong) id userData;
@end
