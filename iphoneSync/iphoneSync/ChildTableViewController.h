//
//  ChildTableViewController.h
//  iphoneSync
//
//  Created by nickfox on 5/12/11.
//  Copyright 2011 websmithing.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Product;

@interface ChildTableViewController : UITableViewController {
    UIView *headerView;
    Product *product;
}
@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) Product *product;

@end
