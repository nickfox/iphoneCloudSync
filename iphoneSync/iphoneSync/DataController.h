//
//  DataController.h
//  iphoneSync
//
//  Created by nickfox on 5/12/11.
//  Copyright 2011 websmithing.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DataController : NSObject {
    NSMutableArray *product;
    NSMutableString *currentProduct;
}


@property (nonatomic, retain) NSMutableArray *product;
@property (nonatomic, retain) NSMutableString *currentProduct;


-(void) loadJsonFromFile;

@end
