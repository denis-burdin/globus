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
typedef void (^accountCompletionBlock_t)(NSString *username, NSString *userID);

@interface TwitterEngine()
{
    accountCompletionBlock_t _accountCompletionBlock;
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
    }
    
    return self;
}

- (void)login:(void (^)())completion {
    
    __weak typeof(self) weakSelf = self;
    self.accountChooserBlock = ^(ACAccount *account, NSString *errorMessage) {
        if(account) {
            [weakSelf loginWithiOSAccount:account completion:^{
                completion();
            }];
        }
    };
    [self chooseAccount];
}

- (void)loginWithiOSAccount:(ACAccount *)account completion:accountCompletionBlock_t {
    
    self.twitter = nil;
    self.twitter = [STTwitterAPI twitterAPIOSWithAccount:account delegate:self];
    
    [_twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
        // store it ?
        NSLog(@"username is %@; userID is %@", username, userID);
        _accountCompletionBlock(username, userID);
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

- (void)getTimelineAction {
    
    [_twitter getHomeTimelineSinceID:nil
                               count:20
                        successBlock:^(NSArray *statuses) {
                            
                            NSLog(@"-- statuses: %@", statuses);
                        } errorBlock:^(NSError *error) {
                            // TODO: handle error
                        }];
}

#pragma mark STTwitterAPIOSProtocol

- (void)twitterAPI:(STTwitterAPI *)twitterAPI accountWasInvalidated:(ACAccount *)invalidatedAccount {
    if(twitterAPI != _twitter) return;
    NSLog(@"-- account was invalidated: %@ | %@", invalidatedAccount, invalidatedAccount.username);
}

@end
