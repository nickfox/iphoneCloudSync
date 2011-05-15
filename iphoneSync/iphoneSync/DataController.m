//
//  DataController.m
//  iphoneSync
//
//  Created by nickfox on 5/12/11.
//  Copyright 2011 websmithing.com. All rights reserved.
//

#import "DataController.h"
#import "JSON.h"
#import "Product.h"

@implementation DataController

@synthesize product, currentProduct;

-(id) init {
    if ((self = [super init])) {
        [self loadJsonFromFile];
    }
    return self;
}

-(void) loadJsonFromFile {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentProductFilePath = [documentsDirectory stringByAppendingPathComponent:@"product.json"]; 
    NSString *bundleProductFilePath = [[NSBundle mainBundle] pathForResource:@"product" ofType:@"json"];    
    NSString *productFilePath;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    // means we have a product.json file from couchdb
    if ([fileManager fileExistsAtPath:documentProductFilePath]) {
        // NSLog(@"documentProductFilePath: %@", documentProductFilePath);
        productFilePath = [[NSString alloc] initWithString:documentProductFilePath];  
    } else {
        // NSLog(@"bundleProductFilePath: %@", bundleProductFilePath);
        productFilePath = [[NSString alloc] initWithString:bundleProductFilePath]; 
    }    
    [fileManager release];
    
    NSError *error = nil;
    NSString *fileContent = [[NSString alloc] initWithContentsOfFile:productFilePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLog(@"file error: %@", [error localizedDescription]);
    }
    [productFilePath release];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init]; 
    NSDictionary *json = (NSDictionary *) [parser objectWithString:fileContent error:nil];
    NSArray *items = [json objectForKey:@"rows"];  
    
    self.product = [NSMutableArray arrayWithCapacity: 5];
        
    for (int i = 0; i < [items count]; i++) {
        Product *tempProduct = [[Product alloc] init];
        
        NSDictionary *value = [[items objectAtIndex:i] objectForKey:@"value"];        
        tempProduct.productID = [value objectForKey:@"_id"];
        tempProduct.name = [value objectForKey:@"name"];
        tempProduct.description = [value objectForKey:@"description"];
        tempProduct.image = [value objectForKey:@"image"];

        [self.product addObject:tempProduct]; 
        [tempProduct release];
    }
    
    self.currentProduct = [[NSMutableString alloc] initWithString:@""];
       
    [fileContent release];
    [parser release];
}

- (void)dealloc {
    [product release];
    [currentProduct release];
    [super dealloc];
}

@end

