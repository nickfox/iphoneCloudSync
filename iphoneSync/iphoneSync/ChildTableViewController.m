//
//  ChildTableViewController.m
//  iphoneSync
//
//  Created by nickfox on 5/12/11.
//  Copyright 2011 websmithing.com. All rights reserved.
//

#import "ChildTableViewController.h"
#import "Product.h"
#import <QuartzCore/QuartzCore.h>

@implementation ChildTableViewController
@synthesize headerView, product;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.product.name;
    
    CGRect imageFrame = CGRectMake((self.tableView.bounds.size.width-200)/2, 20, 200, 200); // x,y,w,h
    UIImage *image = [UIImage imageNamed:self.product.image];
    UIImageView *imageView;
    
    if (image) {
        imageView = [[UIImageView alloc] initWithImage:image];
    } else {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentProductFilePath = [documentsDirectory stringByAppendingPathComponent:@"syncfolder"]; 
        NSString *temp = [documentProductFilePath stringByAppendingString:@"/"];
        NSString *imagePath = [temp stringByAppendingString:product.image];
        
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        imageView = [[UIImageView alloc] initWithImage:image];
        
    }
    
    imageView.layer.cornerRadius = 7;
    imageView.layer.masksToBounds = YES;
    [imageView.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [imageView.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [imageView.layer setBorderWidth: 1.0];
    imageView.frame = imageFrame;
    [self.headerView addSubview:imageView];
    [imageView release]; 
    
}

- (void)viewDidUnload {
    [self setHeaderView:nil];
    [super viewDidUnload];
}

- (void)dealloc {
    [product release];
    [headerView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {    
    //UIFont *cellFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
    
    NSString *cellText = self.product.description;    
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    return labelSize.height + 15;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.text = product.description;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
