//
//  iphoneSyncAppDelegate.m
//  iphoneSync
//
//  Created by nickfox on 5/12/11.
//  Copyright 2011 websmithing.com. All rights reserved.
//

#import "iphoneSyncAppDelegate.h"
#import "SyncController.h"

@implementation iphoneSyncAppDelegate

@synthesize window=_window;
@synthesize navigationController=_navigationController;
@synthesize syncController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // from dropbox app
    NSString *consumerKey = @"DROPBOX_CONSUMER_KEY";
	NSString *consumerSecret = @"DROPBOX_CONSUMER_SECRET";
    
	DBSession* session = [[DBSession alloc] initWithConsumerKey:consumerKey consumerSecret:consumerSecret];
	session.delegate = self; 
	[DBSession setSharedSession:session];
    [session release];    
          
    self.window.rootViewController = self.navigationController;
    
    self.syncController = [[SyncController alloc] init];
    //[self.syncController addObserver:[[self.navigationController viewControllers] objectAtIndex:0] forKeyPath:@"couchDBChanged" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [self.syncController checkForCouchDBUpdates];
    [self.syncController getLocalFileList];
    
    if (![[DBSession sharedSession] isLinked]) {
        NSLog(@"is not Linked");
        // your dropbox email and password
        [self.syncController.restClient loginWithEmail:@"DROPBOX_EMAIL" password:@"DROPBOX_PASSWORD"];
    } else {
        NSLog(@"isLinked");
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *dropboxHash = [prefs stringForKey:@"dropboxHash"];
        [self.syncController.restClient loadMetadata:@"/syncfolder" withHash:dropboxHash];
    }
}

- (void)sessionDidReceiveAuthorizationFailure:(DBSession*)session {
	NSLog(@"Session received authorization failure.");
}

- (void)applicationWillResignActive:(UIApplication *)application{
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

- (void)dealloc {
    [syncController release];
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
