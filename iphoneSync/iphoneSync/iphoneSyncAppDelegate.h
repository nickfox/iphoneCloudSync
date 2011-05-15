//
//  iphoneSyncAppDelegate.h
//  iphoneSync
//
//  Created by nickfox on 5/12/11.
//  Copyright 2011 websmithing.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropboxSDK.h"

@class StarsController;
@class SyncController;

@interface iphoneSyncAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, DBSessionDelegate> {
    SyncController *syncController;
}

@property (nonatomic, retain) SyncController *syncController;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
