//
//  SearchResultsDelegate.m
//  AsynchSearch
//
//  Created by Matti on 2011-09-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchResultsDelegate.h"
#import "SSMApiClient.h"
#import "ItemArticleViewController.h"

@implementation SearchResultsDelegate
@synthesize searchController = _searchController;
@synthesize ssmDelegate;

- (void)awakeFromNib {
    _searchResults = [[NSMutableArray alloc] initWithCapacity:10];
    [_searchResults retain];
    
    _searchQueue = [[NSOperationQueue new] retain];
    [_searchQueue setMaxConcurrentOperationCount:1];
}

- (void)dealloc {
    [_searchResults release];
    [_searchController release];
    [_searchQueue release];
    [super dealloc];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [_searchResults objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *article = [_searchResults objectAtIndex:indexPath.row];
    
    if (ssmDelegate != nil) {
        [ssmDelegate handleResult:article];
        [_searchController setActive:false];
    }
    else {
        
        ItemArticleViewController *controller = [[ItemArticleViewController alloc] initWithNibName:@"ItemArticleView" bundle:nil];
        controller.itemName = article;
    
        [_searchController.searchContentsController.navigationController pushViewController:controller animated:YES];
    
        [controller release];
    }
}


#pragma mark - Search display controller delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchString.length >= 3) {
        [self searchRequest:searchString];
    }
    return NO;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    [_searchQueue cancelAllOperations];
}

- (void)searchRequest:(NSString *)searchString {
    NSLog(@"Searching for: %@", searchString);
    [_searchQueue cancelAllOperations];
    
    [_searchQueue addOperationWithBlock:^{
        
        NSDictionary *dict = [NSDictionary 
                              dictionaryWithObjects:[NSArray arrayWithObjects:@"query", @"json", @"search", [NSString stringWithFormat:@"%@%@", searchString, @"*"], @"Baskategori|bild", nil]
                              
                              forKeys:[NSArray arrayWithObjects:@"action", @"format", @"list", @"srsearch", @"srprop", nil]];
        
        SSMApiClient *client = [SSMApiClient sharedClient];
        [client getPath:@"w/api.php" parameters:dict success:^(id object) {
            
            NSDictionary *responseJson = [(NSDictionary *)object retain];
            
            NSArray *tmp = [[[responseJson objectForKey:@"query"] allValues] objectAtIndex:0];
            
            if ([tmp count] > 0) {
                NSMutableArray *result = [NSMutableArray arrayWithCapacity:[tmp count]];
                NSLog(@"%@", tmp);
                for (NSDictionary *obj in tmp) {
                    [result addObject:[obj objectForKey:@"title"]];
                }
                
                [self showResults:result];
            }
            else {
                [self showResults:tmp];
            }

            
        } failure:^(NSHTTPURLResponse *response, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }];
}

-(void)showResults:(NSArray *)result {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // Modify your instance variables here on the main
        // UI thread.
        [_searchResults removeAllObjects];
        [_searchResults addObjectsFromArray:result];
        
        // Reload your search results table data.
        [self.searchController.searchResultsTableView reloadData];
    }];

}

@end
