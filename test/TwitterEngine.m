//
//  TwitterEngine.m
//  test
//
//  Created by Dennis Burdin on 30.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import "TwitterEngine.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import <STTwitterAPI.h>
#import <STTwitterOAuth.h>
#import <STHTTPRequest.h>

typedef void (^accountChooserBlock_t)(ACAccount *account, NSString *errorMessage); // don't bother with NSError for that

@interface TwitterEngine()
{
    NSUInteger _currentID;
}

@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic, strong) accountChooserBlock_t accountChooserBlock;
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *iOSAccounts;

@end

@implementation TwitterEngine

+ (TwitterEngine *)sharedInstance {
    static TwitterEngine * shared = nil;
    static dispatch_once_t predicate = 0;
    if (shared == nil) {
        dispatch_once(&predicate, ^{
            shared = [TwitterEngine new];
        });
    }
    return shared;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.accountStore = [ACAccountStore new];
        _currentID = 1;
    }
    
    return self;
}

- (void)login:(accountCompletionBlock_t)completion {
    
    __weak typeof(self) weakSelf = self;
    self.accountChooserBlock = ^(ACAccount *account, NSString *errorMessage) {
        if(account) {
            [weakSelf loginWithiOSAccount:account completion:^(NSString *username, NSString *userID) {
                weakSelf.userID = userID;
                weakSelf.userName = username;
                completion(username, userID);
            }];
        } else {
            completion(nil, nil);
        }
    };

    [weakSelf chooseAccount];
}

- (void)loginWithiOSAccount:(ACAccount *)account completion:(accountCompletionBlock_t)handler {
    
    self.twitter = nil;
    self.twitter = [STTwitterAPI twitterAPIOSWithAccount:account delegate:self];
    
    [_twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        // store it ?
        handler(username, userID);
    } errorBlock:^(NSError *error) {
        // TODO: handle error
    }];
}

- (void)chooseAccount {
    
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    ACAccountStoreRequestAccessCompletionHandler accountStoreRequestCompletionHandler = ^(BOOL granted, NSError *error) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            if(granted == NO) {
                _accountChooserBlock(nil, @"Acccess not granted.");
                return;
            }
            
            self.iOSAccounts = [_accountStore accountsWithAccountType:accountType];
            ACAccount *account = [_iOSAccounts lastObject]; // TODO: implement choice from many accounts
            _accountChooserBlock(account, nil);
        }];
    };
    
#if TARGET_OS_IPHONE &&  (__IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0)
    if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_6_0) {
        [self.accountStore requestAccessToAccountsWithType:accountType
                                     withCompletionHandler:accountStoreRequestCompletionHandler];
    } else {
        [self.accountStore requestAccessToAccountsWithType:accountType
                                                   options:NULL
                                                completion:accountStoreRequestCompletionHandler];
    }
#else
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:accountStoreRequestCompletionHandler];
#endif
}

- (void)getTimelineAction:(nullable void (^)(NSArray* __nullable tweets))callback {
    __weak typeof(self) weakSelf = self;
    [_twitter getHomeTimelineSinceID:[@(_currentID) description]
                               count:20
                        successBlock:^(NSArray *statuses) {
                            weakSelf.tweets = statuses;
                            _currentID += 20;
                            callback(statuses);
                        } errorBlock:^(NSError *error) {
                            // TODO: handle error
                            NSLog(@"%@", error.description);
                            callback(nil);
                        }];
}

#pragma mark STTwitterAPIOSProtocol

- (void)twitterAPI:(STTwitterAPI *)twitterAPI accountWasInvalidated:(ACAccount *)invalidatedAccount {
    if(twitterAPI != _twitter) return;
    NSLog(@"-- account was invalidated: %@ | %@", invalidatedAccount, invalidatedAccount.username);
}

@end
