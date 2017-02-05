//
//  TwitterEngine.h
//  test
//
//  Created by Dennis Burdin on 30.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <STTwitter.h>

@interface TwitterEngine : NSObject <STTwitterAPIOSProtocol>

+ (TwitterEngine *)sharedInstance;
- (void)login;
- (void)getTimelineAction;

@end
