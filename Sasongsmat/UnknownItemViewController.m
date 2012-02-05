//
//  UnknownItemViewController.m
//  Sasongsmat
//
//  Created by Matti on 2011-09-11.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "UnknownItemViewController.h"

@implementation UnknownItemViewController
@synthesize searchResultsDelegate;
@synthesize descriptionCell, barcodeInfo;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [self setDescriptionCell:nil];
    [self setBarcodeInfo:nil];
    [self setSearchResultsDelegate:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"Okänd råvara";
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    [allViewControllers removeObjectAtIndex:1];
    self.navigationController.viewControllers = allViewControllers;
    self.searchResultsDelegate.ssmDelegate = self;
    

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case UnknownItemSection:
            return NUM_ROWS;
        case BarcodeInfoSection:
            return barcodeInfo.count;
        default:
            return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == BarcodeInfoSection) {
        return @"Information från streckkoden";
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForItemDescriptionAtRow:(int)row {
    UITableViewCell *cell;
    
    switch (row) {
        case ItemDescription:
            cell = [tableView dequeueReusableCellWithIdentifier:@"UnknownItemDescription"];
            if (cell == nil) {
                cell = self.descriptionCell;
            }
            break;
        default:
            return nil;
            break;
    }
    
    return cell;
}
 
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == UnknownItemSection && indexPath.row == ItemDescription) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loader-bg.png"]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForBarcodeInfoAtRow:(int)row {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BarcodeInfoRow"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"BarcodeInfoRow"] autorelease];
    }
    
    NSString *key = [[barcodeInfo allKeys] objectAtIndex:row];
    cell.textLabel.text = key;
    cell.detailTextLabel.text = [barcodeInfo objectForKey:key];
    
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case UnknownItemSection:
            return [self tableView:tableView cellForItemDescriptionAtRow:indexPath.row];
        case BarcodeInfoSection:
            return [self tableView:tableView cellForBarcodeInfoAtRow:indexPath.row];
        default: 
            return nil;
    }
    
    /*
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    return cell;
     */
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == UnknownItemSection && indexPath.row == ItemDescription) {
        return 150;
    }
    else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)handleResult:(NSString *)result {
    NSLog(@"Handling search result: %@", result);
}

- (void)dealloc {
    [descriptionCell release];
    [barcodeInfo release];
    [searchResultsDelegate release];
    [super dealloc];
}

@end
