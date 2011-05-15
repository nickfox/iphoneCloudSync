//
//  Product.m
//  Sunset
//
//  Created by nickfox on 3/23/11.
//  Copyright 2011 websmithing.com. All rights reserved.
//

#import "Product.h"

@implementation Product

@synthesize productID, name, description, image;

- (void)dealloc {
    [productID release];
	[name release];
	[description release];
	[image release];
	[super dealloc];
}

@end
