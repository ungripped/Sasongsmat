//
//  FoodItemsOverviewController.m
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-06-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FoodItemsOverviewController.h"
#import "FoodItemsCompleteListController.h"
#import "FoodListItem.h"
#import "ItemArticleViewController.h"
#import "SSMNavigationBar.h"

#import "ASIHTTPRequest.h"
#import "SBJson.h"

@implementation FoodItemsOverviewController
@synthesize seasonHeaderView, seasonFooterView;
@synthesize seasonFoodItems, featuredFoodItems;

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
    [featuredFoodItems release];
    
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
    self.featuredFoodItems = [NSArray array];
    
    self.navigationItem.titleView = [SSMNavigationBar titleLabelWithText:self.navigationItem.title];
    
    isLoading = NO;
    
    UIViewController *tempController = [[UIViewController alloc] initWithNibName:@"SeasonHeaderView" bundle:nil];
    self.seasonHeaderView = tempController.view;
    
    [tempController release];
    
    tempController = [[UIViewController alloc] initWithNibName:@"SeasonFooterView" bundle:nil];
    self.seasonFooterView = tempController.view;
    
    [tempController release];
    [self loadFoodItems];
    
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)loadFoodItems {
    
    NSURL *url = [NSURL URLWithString:@"http://xn--ssongsmat-v2a.nu/ssm/Special:Ask/-5B-5B:+-5D-5D-20-5B-5BI_s%C3%A4song::1912-06-12-5D-5D/limit%3D500/format%3Djson"];
    
    //NSURL *url = [NSURL URLWithString:@"http://localhost/~matti/ssm/result-.json"];
    //NSURL *url = [NSURL URLWithString:@"http://localhost/~matti/ssm/result-0.json"];
    //NSURL *url = [NSURL URLWithString:@"http://localhost/~matti/ssm/result-full.json"];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        //NSLog(@"%@", responseString);
        
        NSDictionary *responseJson = (NSDictionary *)[responseString JSONValue];
        
        self.seasonFoodItems = [FoodListItem listItemsForJsonArray:[responseJson objectForKey:@"items"]];
        
        NSLog(@"%@", seasonFoodItems);
        NSRange range;
        range.location = 0;
        range.length = [seasonFoodItems count] > FEATURED_ROW_COUNT ? FEATURED_ROW_COUNT : [seasonFoodItems count];
        
        self.featuredFoodItems = [seasonFoodItems subarrayWithRange:range];
        
        NSLog(@"Season food items count: %i", [seasonFoodItems count]);
        NSLog(@"Featured food items count: %i", [featuredFoodItems count]);
        
        isLoading = NO;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:kSeasonSection] withRowAnimation:UITableViewRowAnimationFade];
        self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
        //[self.tableView reloadData];
        //[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }];
    
    [request setFailedBlock:^{
        isLoading = NO;
        NSError *error = [request error];
        NSLog(@"Error: %@", error);
        
        // TODO: Set error message and tap-message in section footer
    }];
    
    isLoading = YES;
    [request startAsynchronous];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.seasonHeaderView = nil;
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
    // Return the number of sections.
    return NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case kSeasonSection:
            return [seasonFoodItems count] > FEATURED_ROW_COUNT ? [featuredFoodItems count] + 1 : [featuredFoodItems count];
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kSeasonSection:
            if (indexPath.row == [featuredFoodItems count]) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreIndicator"];
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreIndicator"] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                cell.textLabel.text = @"Mer säsongsmat";
                
                return cell;
            }
            else {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodItemRowCell"];
                
                if (cell == nil) {
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FoodItemRowCell"] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                
                FoodListItem *item = [featuredFoodItems objectAtIndex:indexPath.row];
                cell.textLabel.text = item.label;
                cell.detailTextLabel.text = @"6 dagar kvar";
                
                UIImage *image = [UIImage imageNamed:item.type];
                cell.imageView.image = image;
                
                return cell;
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
    switch (section) {
        case kCategoriesSection:
            return @"Alla råvaror";            
        default:
            return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kSeasonSection:
            return seasonHeaderView;
        default:
            return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    switch (section) {
        case kSeasonSection:
            // TODO: Show message in footer if there's no rows.
            if (isLoading) {
                seasonFooterView.hidden = NO;
            }
            else {
                seasonFooterView.hidden = YES;
            }
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
        case kCategoriesSection:
            return 36;
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    switch (section) {
        case kSeasonSection:
            if (isLoading) {
                return 45;
            }
            else {
                return 0;
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
            if (indexPath.row == [featuredFoodItems count]) {
                FoodItemsCompleteListController *completeListController = [[FoodItemsCompleteListController alloc] initWithNibName:@"FoodItemsCompleteListController" bundle:nil];
                
                completeListController.seasonFoodItems = self.seasonFoodItems;
                
                [self.navigationController pushViewController:completeListController animated:YES];
                
                [completeListController release];
            }
            else {
                FoodListItem *item = [featuredFoodItems objectAtIndex:indexPath.row];
                [self loadArticle:item.label];
            }
            break;
            
        default:
            break;
    }
}

- (void)loadArticle:(NSString *)name {
    NSString *urlString = [NSString stringWithFormat:@"http://www.xn--ssongsmat-v2a.nu/w/api.php?action=parse&page=%@&format=json", [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSLog(@"Fetching article: %@", url);
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        
        NSDictionary *responseJson = (NSDictionary *)[responseString JSONValue];
        
        NSString *fullArticle = [responseJson valueForKeyPath:@"parse.text.*"];

        NSLog(@"response: %@", fullArticle);
        
        ItemArticleViewController *controller = [[ItemArticleViewController alloc] initWithNibName:@"ItemArticleView" bundle:nil];
        controller.initialHTML = fullArticle;
        controller.urlString = urlString;
        controller.navigationItem.title = name;
        
        [self.navigationController pushViewController:controller animated:YES];
        
        
    }];
    
    [request setFailedBlock:^{
        isLoading = NO;
        NSError *error = [request error];
        NSLog(@"Error: %@", error);
        
        // TODO: Set error message and tap-message in section footer
    }];
    
    [request startAsynchronous];
}

@end
