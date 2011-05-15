//
//  RootViewController.m
//  iphoneSync
//
//  Created by nickfox on 5/12/11.
//  Copyright 2011 websmithing.com. All rights reserved.
//

#import "RootViewController.h"
#import "ChildTableViewController.h"
#import "DataController.h"
#import "UIImage+TableCellImageScaler.h"
#import <QuartzCore/QuartzCore.h>
#import "Product.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Catalog";

    dataController = [[DataController alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(couchDBNotificationHandler:) name:@"couchDBChanged" object:nil];
}

- (void)couchDBNotificationHandler:(NSNotification *)notification
{
	NSLog(@"notification: %@",(NSString*)[notification object]);
    [dataController loadJsonFromFile];
    [self.tableView reloadData];
	
}

- (void)dealloc {
    [dataController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath  *)indexPath{
    return 67;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataController.product count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    Product *product = (Product *)[dataController.product objectAtIndex:indexPath.row];
    
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 7.0;
    UIImage *image = [UIImage imageNamed:product.image];
    
    if (image) {
        // this is using the category in UIImage+TableCellImageScaler.h
        cell.imageView.image = [image imageScaledToSize:CGSizeMake(60, 60)];
    } else {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentProductFilePath = [documentsDirectory stringByAppendingPathComponent:@"syncfolder"]; 
        NSString *temp = [documentProductFilePath stringByAppendingString:@"/"];
        NSString *imagePath = [temp stringByAppendingString:product.image];
        
        //NSLog(@"imagePath: %@", imagePath);
        
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        cell.imageView.image = [image imageScaledToSize:CGSizeMake(60, 60)];
        
    }
    
    cell.textLabel.text = product.name;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChildTableViewController *childTableViewController = [[ChildTableViewController alloc] initWithNibName:@"ChildTableViewController" bundle:nil];
    
    childTableViewController.product = (Product *)[dataController.product objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:childTableViewController animated:YES];
    [childTableViewController release];
}

@end
