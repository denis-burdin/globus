//
//  AppDelegate.h
//  test
//
//  Created by Dennis Burdin on 30.01.17.
//  Copyright © 2017 Dennis Burdin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

