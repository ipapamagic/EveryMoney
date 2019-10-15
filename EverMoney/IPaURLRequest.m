//
//  IPaURLRequest.m
//  IPaURLRequest
//
//  Created by 陳 尤中 on 11/10/27.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "IPaURLRequest.h"
#import "IPaToolManager.h"
@implementation IPaURLRequest
//@synthesize responseData;
//@synthesize userData;
/*+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                    target:(id)target
                  callback:(SEL)callback
                  userData:(id)userData
{    
    return [IPaURLRequest IPaURLRequestWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval target:target callback:callback receiveCallback:nil userData:userData];
}*/
+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                  callback:(void (^)(NSURLResponse *,NSData *))callback
{    
    return [IPaURLRequest IPaURLRequestWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval callback:callback failCallback:nil receiveCallback:nil receiveData:nil];
}
 
/*
+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                    target:(id)target
                  callback:(SEL)callback
{
        
    return [IPaURLRequest IPaURLRequestWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval target:target callback:callback userData:nil];
    
}*/
/*
+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                    target:(id)target
                  callback:(SEL)callback
           receiveCallback:(SEL)receiveCallback
                  userData:(id)userData
{
    return [IPaURLRequest IPaURLRequestWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval target:target callback:callback receiveCallback:receiveCallback receiveData:nil userData:userData];
    
}*/
+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                  callback:(void (^)(NSURLResponse*, NSData *))callback
              failCallback:(void (^)())failCallback
{
    return [IPaURLRequest IPaURLRequestWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval callback:callback 
                               failCallback:failCallback receiveCallback:nil receiveData:nil];
    
}
+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                  callback:(void (^)(NSURLResponse*, NSData *))callback 
              failCallback:(void (^)())failCallback
           receiveCallback:(void (^)(NSURLResponse *,NSData*,NSData *))receiveCallback
{
    return [IPaURLRequest IPaURLRequestWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval callback:callback failCallback:failCallback receiveCallback:receiveCallback receiveData:nil];
    
}
/*+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                    target:(id)target
                  callback:(SEL)callback
           receiveCallback:(SEL)receiveCallback
               receiveData:(NSMutableData*)receiveData
                  userData:(id)userData
{
    IPaURLRequest *newRequest = [[IPaURLRequest alloc] initWithURL:URL
                                                       cachePolicy:cachePolicy 
                                                   timeoutInterval:timeoutInterval 
                                                            target:target 
                                                          callback:callback
                                                   receiveCallback:receiveCallback
                                                       reveiveData:receiveData];
    newRequest.userData = userData;
    
    [newRequest StartConnect];
    
    
    return newRequest;
}*/
+ (id)IPaURLRequestWithURL:(NSString*)URL 
               cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
           timeoutInterval:(NSTimeInterval)timeoutInterval
                  callback:(void (^)(NSURLResponse*, NSData*))callback 
              failCallback:(void (^)())failCallback
           receiveCallback:(void (^)(NSURLResponse *,NSData*,NSData *))receiveCallback 
               receiveData:(NSMutableData *)receiveData
{
    IPaURLRequest *newRequest = [[IPaURLRequest alloc] initWithURL:URL
                                                       cachePolicy:cachePolicy 
                                                   timeoutInterval:timeoutInterval 
                                                          callback:callback
                                                      failCallback:failCallback
                                                   receiveCallback:receiveCallback
                                                       reveiveData:receiveData];
    
    [newRequest StartConnect];
    
    
    return newRequest;
}

+ (id)IPaURLRequestWithURLRequest:(NSURLRequest*)request
                         callback:(void (^)(NSURLResponse *,NSData*))callback
                     failCallback:(void (^)())failCallback
                  receiveCallback:(void (^)(NSURLResponse *,NSData*,NSData*))receiveCallback
                      reveiveData:(NSMutableData*)receiveData
{
    IPaURLRequest *newRequest = [[IPaURLRequest alloc] initWithURLRequest:request                                                              
                                                                 callback:callback
                                                             failCallback:failCallback
                                                          receiveCallback:receiveCallback
                                                              reveiveData:receiveData];
    
    [newRequest StartConnect];
    
    
    return newRequest;
}

/*
- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval
           target:(id)target
         callback:(SEL)callback
{
    return [self initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval target:target callback:callback receiveCallback:nil reveiveData:nil];
    
}*/
- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval
         callback:(void (^)(NSURLResponse*, NSData *))callback
{
    return [self initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval callback:callback failCallback:nil receiveCallback:nil reveiveData:nil];
    
}
/*- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval
           target:(id)target
         callback:(SEL)callback
  receiveCallback:(SEL)receiveCallback
{
    return [self initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval target:target callback:callback receiveCallback:receiveCallback reveiveData:nil];
    
    
}*/
- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval
         callback:(void (^)(NSURLResponse*, NSData *))callback
     failCallback:(void (^)())failCallback
{
    return [self initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval callback:callback failCallback:failCallback receiveCallback:nil reveiveData:nil];
    
}
- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval
         callback:(void (^)(NSURLResponse*, NSData *))callback 
     failCallback:(void (^)())failCallback
  receiveCallback:(void (^)(NSURLResponse *,NSData*,NSData *))receiveCallback
{
    return [self initWithURL:URL cachePolicy:cachePolicy timeoutInterval:timeoutInterval callback:callback failCallback:failCallback receiveCallback:receiveCallback reveiveData:nil];
}
/*- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval
           target:(id)target
         callback:(SEL)callback
  receiveCallback:(SEL)receiveCallback
      reveiveData:(NSMutableData*)receiveData
{
    self = [super init];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: URL] cachePolicy: cachePolicy timeoutInterval:timeoutInterval];
    theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];

    responseData = (receiveData != nil)?receiveData:[NSMutableData data];
    
    
    Callback = [NSInvocation invocationWithMethodSignature:[[target class] instanceMethodSignatureForSelector:callback]];
    //[NSMethodSignature signatureWithObjCTypes:"v^v^c@i"]];
    
    [Callback setTarget:target];
    [Callback setSelector:callback];
    if (receiveCallback != nil) {
        recCallback = [NSInvocation invocationWithMethodSignature:[[target class] instanceMethodSignatureForSelector:callback]];
        //[NSMethodSignature signatureWithObjCTypes:"v^v^c@i"]];
        
        [recCallback setTarget:target];
        [recCallback setSelector:receiveCallback];

    }
    return self;
}*/
- (id)initWithURL:(NSString*)URL 
      cachePolicy:(NSURLRequestCachePolicy)cachePolicy 
  timeoutInterval:(NSTimeInterval)timeoutInterval
         callback:(void (^)(NSURLResponse*, NSData *))callback 
     failCallback:(void (^)())failCallback
  receiveCallback:(void (^)(NSURLResponse *,NSData*,NSData *))receiveCallback 
      reveiveData:(NSMutableData *)receiveData
{
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString: URL] cachePolicy: cachePolicy timeoutInterval:timeoutInterval];
    return [self initWithURLRequest:theRequest callback:callback failCallback:failCallback receiveCallback:receiveCallback reveiveData:receiveData];
}


- (id)initWithURLRequest:(NSURLRequest*)request
                callback:(void (^)(NSURLResponse *,NSData*))callback
            failCallback:(void (^)())failCallback
         receiveCallback:(void (^)(NSURLResponse *,NSData *,NSData*))receiveCallback
             reveiveData:(NSMutableData*)receiveData

{
    self = [super init];
    theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
    
    responseData = (receiveData != nil)?receiveData:[NSMutableData data];
    
    //    responseHeader = nil;
    Callback = [callback copy];
    FailCallback = [failCallback copy];
    RecCallback = [receiveCallback copy];
    
    return self;
}
-(void)dealloc {
    [self CancelConnect];
    responseData = nil;
    //    NSDictionary *responseHeader;
    response = nil;
    theConnection = nil;
    //    NSInvocation *Callback;
    //    NSInvocation *recCallback;
    //    id userData;
    Callback = nil;
    FailCallback = nil;
    RecCallback = nil;


}
-(void) StartConnect {
    [theConnection start];
    [IPaToolManager RetainTool:self];
}

-(void) CancelConnect {
    [theConnection cancel];
    [responseData setLength:0];
    [IPaToolManager ReleaseTool:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)_response
{
//    responseHeader = ((NSHTTPURLResponse*)response).allHeaderFields;
    response = _response;
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData: data];
    
    if (RecCallback != nil) {

        /*IPaURLRequest __unsafe_unretained *selfConnect = self;
        [recCallback setArgument:&selfConnect atIndex:2];
        [recCallback setArgument:&data atIndex:3];
        [recCallback invoke];
        */
        RecCallback(response,responseData,data);
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if (FailCallback != nil) {
        /*BOOL result = NO;
        IPaURLRequest __unsafe_unretained *selfConnect = self;
        [Callback setArgument:&selfConnect atIndex:2];
        [Callback setArgument:&result atIndex:3];
        [Callback invoke];*/
        FailCallback();
        
    }
    
    [IPaToolManager ReleaseTool:self];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (Callback != nil) {
        /*BOOL result = YES;
        IPaURLRequest __unsafe_unretained *selfConnect = self;
        [Callback setArgument:&selfConnect atIndex:2];
        [Callback setArgument:&result atIndex:3];
        [Callback invoke];*/
        Callback(response,responseData);
        
    }
    
    [IPaToolManager ReleaseTool:self];
}


@end
