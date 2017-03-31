//
//  TwitterEngine.h
//  test
//
//  Created by Dennis Burdin on 30.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STTwitter.h>

typedef void (^accountCompletionBlock_t)(NSString* __nullable username, NSString* __nullable userID);

@interface TwitterEngine : NSObject <STTwitterAPIOSProtocol>

@property (nonatomic, strong) NSString* __nullable userID;
@property (nonatomic, strong) NSString* __nullable userName;
@property (nonatomic, strong) NSArray* __nullable tweets;

+ (nonnull TwitterEngine *)sharedInstance;
- (void)getTimelineAction:(nullable void (^)(NSArray* __nullable tweets))callback;
- (void)login:(nullable accountCompletionBlock_t)completion;

@end
