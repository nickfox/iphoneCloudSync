//
//  Product.h
//  Sunset
//
//  Created by nickfox on 3/23/11.
//  Copyright 2011 websmithing.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject {
    NSString *productID;
	NSString *name;
	NSString *description;
	NSString *image;        
}

@property (nonatomic, retain) NSString *productID;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *image;

@end
