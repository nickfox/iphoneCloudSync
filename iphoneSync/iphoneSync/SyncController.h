//
//  SyncController.h
//  Sunset
//
//  Created by nickfox on 5/7/11.
//  Copyright 2011 websmithing.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DropboxSDK.h"


@interface SyncController : NSObject <DBLoginControllerDelegate, DBRestClientDelegate>  {
    DBRestClient *restClient;    
    NSMutableArray *dropboxFileList;
    NSMutableArray *localSyncFileList;    
    NSMutableArray *localFilesNeedingToBeAdded;
    NSMutableArray *localFilesNeedingToBeDeleted;
    NSMutableString *couchDBUrl;
}

@property (nonatomic, readonly) DBRestClient *restClient;
@property (nonatomic, retain) NSMutableArray *dropboxFileList;
@property (nonatomic, retain) NSMutableArray *localSyncFileList;
@property (nonatomic, retain) NSMutableArray *localFilesNeedingToBeAdded;
@property (nonatomic, retain) NSMutableArray *localFilesNeedingToBeDeleted;

- (void)getLocalFileList;
- (void)syncLocalFilesWithDropbox;
- (void)createSyncFolderIfDoesntExist;

- (void)checkForCouchDBUpdates;
- (void)getCouchDBUpdates;

@end
