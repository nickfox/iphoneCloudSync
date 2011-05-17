//
//  SyncController.m
//  Sunset
//
//  Created by nickfox on 5/7/11.
//  Copyright 2011 websmithing.com. All rights reserved.
//

#import "SyncController.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"

@implementation SyncController

@synthesize localSyncFileList, dropboxFileList, localFilesNeedingToBeAdded, localFilesNeedingToBeDeleted;

-(id) init {
    if ((self = [super init])) {
        // NSLog(@"viewWillAppear called");
                
        // this will unlink the session and remove the oauth tokens from the credential store
        //[[DBSession sharedSession] unlink];
        
        // reset the hash from dropbox and changes value from couchdb
        // NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        // [prefs setObject:@"" forKey:@"dropboxHash"];
        // [prefs setObject:@"" forKey:@"lastSequenceFromCouchDB"];
        
        NSString *couchDBUserName = @"COUCHDB_USERNAME";
        NSString *couchDBPassword = @"COUCHDB_PASSWORD";
        
        couchDBUrl = [NSString stringWithFormat:@"http://%@:%@@%@.cloudant.com/iphonecouchsync", couchDBUserName, couchDBPassword, couchDBUserName];
        
        // NSLog(@"couchDBUrl: %@", couchDBUrl);
        [self createSyncFolderIfDoesntExist];
    }
    return self;
}

#pragma mark -
#pragma mark Dropbox Methods

- (void)createSyncFolderIfDoesntExist {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *syncFilePath = [documentsDirectory stringByAppendingPathComponent:@"syncfolder"];  
    
    BOOL isDir;
    if ([fileManager fileExistsAtPath:syncFilePath isDirectory:&isDir] && isDir) {
        NSLog(@"dir exists: %@", syncFilePath);  
    } else {
        NSError *error;
        [fileManager createDirectoryAtPath:syncFilePath withIntermediateDirectories:YES attributes:nil error:&error];
        NSLog(@"dir does not exist: %@", syncFilePath);
    }
    
    [fileManager release];    
}

- (void)syncLocalFilesWithDropbox {
    self.localFilesNeedingToBeAdded = [NSMutableArray arrayWithArray:self.dropboxFileList];
    self.localFilesNeedingToBeDeleted = [NSMutableArray arrayWithArray:self.localSyncFileList];
    [self.localFilesNeedingToBeAdded removeObjectsInArray:self.localSyncFileList];
    [self.localFilesNeedingToBeDeleted removeObjectsInArray:self.dropboxFileList];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *syncFilePath = [documentsDirectory stringByAppendingPathComponent:@"syncfolder"];
    
    for (NSString *files in self.localFilesNeedingToBeAdded){
        NSString *fileToLocalPath = [syncFilePath stringByAppendingPathComponent:files];
        // NSLog(@"local files for adding: %@", fileToLocalPath);
        NSString *fileFromDropboxPath = [NSString stringWithFormat:@"/syncfolder/%@", files]; 
        
        [self.restClient loadFile:fileFromDropboxPath intoPath:fileToLocalPath];
    }
    
    NSError *error;
    NSFileManager *deleteMgr = [NSFileManager defaultManager];
    
    for (NSString *files in self.localFilesNeedingToBeDeleted){
        NSString *filePath = [syncFilePath stringByAppendingPathComponent:files];
        // NSLog(@"local files for deleting: %@", filePath);
        [deleteMgr removeItemAtPath:filePath error:&error];
    }
}

- (void)getLocalFileList {
    self.localSyncFileList = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *syncFilePath = [documentsDirectory stringByAppendingPathComponent:@"syncfolder"];
    
    NSError *error;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *fileList = [manager  contentsOfDirectoryAtPath:syncFilePath error:&error];
    for (NSString *files in fileList){
        // NSLog(@"local files: %@", files);
        [self.localSyncFileList addObject:files];
    }
    
}

#pragma mark -
#pragma mark CouchDB Methods

- (void)checkForCouchDBUpdates {    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *lastSequenceFromCouchDB = [prefs stringForKey:@"lastSequenceFromCouchDB"];
    
    NSString *changeUrl;
    if ([lastSequenceFromCouchDB length] == 0) {
        changeUrl = [couchDBUrl stringByAppendingString:@"_changes"];
    } else {
        changeUrl = [couchDBUrl stringByAppendingFormat:@"_changes?since=%@", lastSequenceFromCouchDB];
    }
    
    // NSLog(@"changeUrl: %@", changeUrl);
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:changeUrl]];
    [request setCompletionBlock:^{        
        NSString *responseString = [request responseString];
        
        SBJsonParser *parser = [[SBJsonParser alloc] init]; 
        NSDictionary *json = (NSDictionary *) [parser objectWithString:responseString error:nil];
        NSArray *changes = [json objectForKey:@"results"];
        int changesCount = [changes count];
        
        if (changesCount > 0) {
            [self getCouchDBUpdates];
            NSLog(@"CouchDB changed");
        } else {
            NSLog(@"CouchDB not changed");
        }
        
        NSString *lastSequenceFromCouchDB = [json valueForKey:@"last_seq"];        
        [prefs setObject:lastSequenceFromCouchDB forKey:@"lastSequenceFromCouchDB"];
        
        [parser release];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
    [request startAsynchronous];
}

- (void)getCouchDBUpdates {
    NSString *couchUrl = [couchDBUrl stringByAppendingString:@"_design/iphonecouchsync/_view/syncView"];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:couchUrl]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *jsonDocumentsFilePath = [documentsDirectory stringByAppendingPathComponent:@"product.json"];
    
    //NSLog(@"destPath: %@", jsonDocumentsFilePath);
    [request setDownloadDestinationPath:jsonDocumentsFilePath];
    
    [request setCompletionBlock:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"couchDBChanged" object:@"couchDB product.json file updated"];
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", [error localizedDescription]);
    }];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark Dropbox Delegate

- (DBRestClient*)restClient {
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    return restClient;
}

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata *)metadata {
    self.dropboxFileList = [[NSMutableArray alloc] init];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:metadata.hash forKey:@"dropboxHash"];
    
    // NSLog(@"metadata hash: %@",  metadata.hash);
    
	for (DBMetadata *child in metadata.contents) {		
		NSString *itemName = [[child.path pathComponents] lastObject];
        // NSLog(@"metadata: %@", itemName);
		[self.dropboxFileList addObject:itemName];
	}
	
	[self syncLocalFilesWithDropbox];
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path {
    NSLog(@"metadataUnchangedAtPath");
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error{
    
	NSLog(@"Error, %@, \n, %@", [error localizedDescription], [error userInfo]);
	
}

#pragma mark -
#pragma mark DBRestClient Methods

- (void)restClientDidLogin:(DBRestClient*)client {
    NSLog(@"restClientDidLogin.");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *dropboxHash = [prefs stringForKey:@"dropboxHash"];
    [self.restClient loadMetadata:@"/syncfolder" withHash:dropboxHash];
}

- (void)restClient:(DBRestClient*)client loginFailedWithError:(NSError*)error {
    NSLog(@"loginFailedWithError.");
}

- (void)loginControllerDidLogin:(DBLoginController*)controller {
    NSLog(@"loginControllerDidLogin.");  
}

- (void)loginControllerDidCancel:(DBLoginController*)controller {
	NSLog(@"loginControllerDidCancel.");
}

- (void)dealloc {
    [couchDBUrl release];
    [localFilesNeedingToBeAdded release];
    [localFilesNeedingToBeDeleted release];
    [dropboxFileList release];
    [localSyncFileList release];
    [restClient release];
    [super dealloc];
}

@end
