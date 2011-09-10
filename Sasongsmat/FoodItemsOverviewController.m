//
//  FoodItemsOverviewController.m
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-07-18.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "FoodItemsOverviewController.h"
#import "FoodItemsCompleteListController.h"
#import "FoodListItem.h"
#import "ItemArticleViewController.h"
#import "SSMNavigationBar.h"
#import "SSMApi.h"
#import "SeasonIndicatorView.h"
#import "FoodItemsUtilities.h"

@implementation FoodItemsOverviewController
@synthesize seasonHeaderView, seasonFooterView;
@synthesize seasonFoodItems;
@synthesize searchDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [seasonHeaderView release];
    [seasonFooterView release];
    [seasonFoodItems release];
    [searchDelegate release];
    [super dealloc];
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
    self.seasonFoodItems = [NSArray array];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"autumn.png"]];
    self.navigationItem.titleView = titleView;
    [titleView release];
    
    self.navigationItem.title = @"Råvaror";
    //self.navigationItem.titleView = [SSMNavigationBar titleLabelWithText:self.navigationItem.title];
    
    //isLoading = NO;
    _reloading = NO;
    seasonFooterView.hidden = NO;
    
    UIViewController *tempController = [[UIViewController alloc] initWithNibName:@"SeasonHeaderView" bundle:nil];
    self.seasonHeaderView = tempController.view;
    
    [tempController release];
    
    tempController = [[UIViewController alloc] initWithNibName:@"SeasonFooterView" bundle:nil];
    self.seasonFooterView = tempController.view;
    
    [tempController release];
    [self loadFoodItems];
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
	}
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
    
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)loadFoodItems {
    SSMApi *api = [SSMApi sharedSSMApi];
    
    _reloading = YES;
    self.seasonFooterView.hidden = NO;
    UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[seasonFooterView viewWithTag:1];
    spinner.hidden = NO;
    [spinner startAnimating];
    UILabel *footerMessage = (UILabel *)[seasonFooterView viewWithTag:2];
    footerMessage.text = @"Laddar aktuell säsongsmat...";
    
    [api getSeasonItemsInNamespace:@"0" withBlock:^(NSArray *items) {
        NSSortDescriptor *sd = [[NSSortDescriptor alloc] initWithKey:@"interestWeight" ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sd];
        self.seasonFoodItems = [[FoodListItem listItemsForJsonArray:items] sortedArrayUsingDescriptors:sortDescriptors];
        
        
        
        [sd release];
        
        //NSLog(@"season food items: %@", seasonFoodItems);
        
        /*
        NSRange range;
        range.location = 0;
        range.length = [seasonFoodItems count] > FEATURED_ROW_COUNT ? FEATURED_ROW_COUNT : [seasonFoodItems count];
        
        self.featuredFoodItems = [seasonFoodItems subarrayWithRange:range];
        
        NSLog(@"Season food items count: %i", [seasonFoodItems count]);
        NSLog(@"Featured food items count: %i", [featuredFoodItems count]);
        */
        seasonFooterView.hidden = YES;
        
        
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kSeasonSection] withRowAnimation:UITableViewRowAnimationFade];
        
        self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
        
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];

    } error:^(NSError *error) {
        seasonFooterView.hidden = NO;
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[seasonFooterView viewWithTag:1];
        [spinner stopAnimating];
        spinner.hidden = YES;
        UILabel *footerMessage = (UILabel *)[seasonFooterView viewWithTag:2];
        footerMessage.text = [error localizedDescription];
        
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];

        //NSLog(@"Error: %@", [error localizedDescription]);
        
        // TODO: Set error message and tap-message in section footer
    }];
}

- (void)viewDidUnload
{
    [self setSearchDelegate:nil];
    [super viewDidUnload];
    self.seasonHeaderView = nil;
    self.seasonFooterView = nil;
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
    // Return the number of sections.
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kSeasonSection:
            return [seasonFoodItems count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kSeasonSection:
            if (true) {
                FoodListItem *item = [seasonFoodItems objectAtIndex:indexPath.row];
                return [FoodItemsUtilities foodItemCell:tableView indexPath:indexPath forItem:item];
            }
            break;
            
        default:
            break;
    }
        //cell.itemSeason.text = @"6 jun - 9 jul";
    
    //cell.textLabel.text = @"Majrova";
    // Configure the cell...
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kSeasonSection:
            return seasonHeaderView;
        default:
            return nil;
    }
}
 */

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    switch (section) {
        case kSeasonSection:
            return seasonFooterView;
        default:
            return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kSeasonSection:
            return 55;
        default:
            return 0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kSeasonSection:
            return 45;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case kSeasonSection:
            if (seasonFooterView.hidden) {
                return 0;
            }
            else {
                return 45;
            }
        default:
            return 0;
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
    switch (indexPath.section) {
        case kSeasonSection:
            [self loadArticleWithIndexPath:indexPath];
            break;
            
        default:
            break;
    }
}

- (void)loadArticleWithIndexPath:(NSIndexPath *)indexPath {
    FoodListItem *item = [seasonFoodItems objectAtIndex:indexPath.row];
    
    [FoodItemsUtilities loadArticleWithIndexPath:indexPath onTableView:self.tableView foodListItem:item navigationController:self.navigationController];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark - EGORefreshTableHeaderDelegate methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    
    NSLog(@"Did trigger refresh...");
    [self loadFoodItems];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    return [NSDate date];
}

@end
