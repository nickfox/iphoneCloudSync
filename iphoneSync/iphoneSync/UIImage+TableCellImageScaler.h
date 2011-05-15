//
//  UIImage+TableCellImageScaler.h
//  Sunset
//
//  Created by nickfox on 3/25/11.
//  Copyright 2011 websmithing.com. All rights reserved.
//

// category to scale a table cell image
// http://atastypixel.com/blog/easy-rounded-corners-on-uitableviewcell-image-view/

@interface UIImage (TableCellImageScaler)
- (UIImage*)imageScaledToSize:(CGSize)size;
@end

