//
//  UIImage+TableCellImageScaler.m
//  Sunset
//
//  Created by nickfox on 3/25/11.
//  Copyright 2011 websmithing.com. All rights reserved.
//

#import "UIImage+TableCellImageScaler.h"

// category to scale a table cell image

@implementation UIImage (TableCellImageScaler)
- (UIImage*)imageScaledToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
