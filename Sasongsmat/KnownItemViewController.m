//
//  KnownItemViewController.m
//  Sasongsmat
//
//  Created by Matti on 2012-02-05.
//  Copyright (c) 2012 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "KnownItemViewController.h"
#import "ItemArticleViewController.h"
#import "SSMApiClient.h"

@implementation KnownItemViewController

@synthesize barcodeInfo;
@synthesize itemNameLabel;
@synthesize seasonInfoLabel;
@synthesize seasonActivityIndicator;
@synthesize itemInfoCell;

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
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    [allViewControllers removeObjectAtIndex:1];
    self.navigationController.viewControllers = allViewControllers;
    
    //self.searchResultsDelegate.ssmDelegate = self;
    
    NSString *articleName = [barcodeInfo objectForKey:@"Artikel"];
    
    self.itemNameLabel.text = articleName;
    self.navigationItem.title = articleName;
    
    
    //http://xn--ssongsmat-v2a.nu/w/api.php?action=ssmksasong&rvlista=Gr%C3%B6nk%C3%A5l&format=json
    // {"ssm":{"Gr\u00f6nk\u00e5l":{"exists":true,"isasong":true}}}
    NSArray *seasonKeys    = [NSArray arrayWithObjects:
                              @"action",
                              @"format",
                              @"rvlista",
                              nil];
    
    NSArray *seasonObjects = [NSArray arrayWithObjects:
                              @"ssmksasong",
                              @"json",
                              articleName,
                              nil];
    
    NSDictionary *seasonDict = [NSDictionary dictionaryWithObjects:seasonObjects forKeys:seasonKeys];
                              

    SSMApiClient *client = [SSMApiClient sharedClient];
    [client getPath:@"w/api.php" parameters:seasonDict success:^(id object) {
        NSDictionary *seasonResponse = [(NSDictionary *)object retain];
        NSLog(@"%@", seasonResponse);
        
        NSString *keyPath = [NSString stringWithFormat:@"ssm.%@.isasong", articleName];
        BOOL inSeason = [[seasonResponse valueForKeyPath:keyPath] boolValue];

        if (inSeason) {
            self.seasonInfoLabel.text = [NSString stringWithFormat:@"%@ är i säsong nu!", articleName];
        }
        else {
            self.seasonInfoLabel.text = [NSString stringWithFormat:@"%@ är inte i säsong nu.", articleName];
        }
        
        [self.seasonActivityIndicator stopAnimating];
        self.seasonInfoLabel.hidden = NO;
        
        
        [seasonResponse release];
        
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];

    
    
    // ns: 550 = recept
    //http://xn--ssongsmat-v2a.nu/w/api.php?action=parse&format=json&page=Gr%C3%B6nk%C3%A5l&prop=images|links
    
    
}

- (void)viewDidUnload
{
    [self setItemNameLabel:nil];
    [self setItemInfoCell:nil];
    [self setSeasonInfoLabel:nil];
    [self setSeasonActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    return KNOWN_NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case ItemInfoSection:
            return NUM_INFO_ROWS;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case ItemInfoSection:
            return [self tableView:tableView cellForItemDescriptionAtRow:indexPath.row];
        case KnownItemBarcodeInfoSection:
            return nil;
//            return [self tableView:tableView cellForBarcodeInfoAtRow:indexPath.row];
        default: 
            return nil;
    }}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForItemDescriptionAtRow:(int)row {
    UITableViewCell *cell;
    
    switch (row) {
        case ItemInfo:
            cell = [tableView dequeueReusableCellWithIdentifier:@"ItemInfo"];
            if (cell == nil) {
                cell = self.itemInfoCell;
            }
            break;
        default:
            return nil;
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ItemInfoSection && indexPath.row == ItemInfo) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loader-bg.png"]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ItemInfoSection && indexPath.row == ItemInfo) {
        return 102;
    }
    else {
        return 44;
    }
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

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSString *artikel = [self.barcodeInfo valueForKey:@"Artikel"];

    ItemArticleViewController *controller = [[ItemArticleViewController alloc] initWithNibName:@"ItemArticleView" bundle:nil];
    controller.itemName = artikel;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}

- (void)dealloc {
    [itemNameLabel release];
    [itemInfoCell release];
    [seasonInfoLabel release];
    [seasonActivityIndicator release];
    [super dealloc];
}
@end
