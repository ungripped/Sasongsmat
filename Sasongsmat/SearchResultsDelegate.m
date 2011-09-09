//
//  SearchResultsDelegate.m
//  AsynchSearch
//
//  Created by Matti on 2011-09-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SearchResultsDelegate.h"
#import "ASIHTTPRequest.h"
#import "SSMApi.h"
#import "ItemArticleViewController.h"

@implementation SearchResultsDelegate
@synthesize searchController = _searchController;
@synthesize activeRequest;

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

- (void)loadArticleWithIndexPath:(NSIndexPath *)indexPath onTableView:(UITableView *)tableView articleName:(NSString *)item navigationController:(UINavigationController *)navigationController {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    UIView *accessoryView = [cell accessoryView];
    
    [cell setAccessoryView:indicator];
    [indicator startAnimating];
    
    
    [ItemArticleViewController articleControllerForArticle:item loadedBlock:^(ItemArticleViewController * controller) {
        
        [navigationController pushViewController:controller animated:YES];
        [indicator removeFromSuperview];
        [cell setAccessoryView:accessoryView];
        [indicator release];
    } errorBlock:^(NSError * error) {
        [indicator removeFromSuperview];
        [cell setAccessoryView:accessoryView];
        [indicator release];
        
        if(error.code == ASIRequestCancelledErrorType) {
            NSLog(@"Request cancelled, ignoring error callback block.");
        }
        else {
            NSLog(@"Error loading article: %@", error);
            // TODO: Set error message and tap-message in section footer
        }
        
    }];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [_searchResults objectAtIndex:indexPath.row];
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *article = [_searchResults objectAtIndex:indexPath.row];
    
    [self loadArticleWithIndexPath:indexPath onTableView:tableView articleName:article navigationController:_searchController.searchContentsController.navigationController]; // really? Ick
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
        SSMApi *api = [SSMApi sharedSSMApi];
        NSArray *data = [api search:searchString];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            // Modify your instance variables here on the main
            // UI thread.
            [_searchResults removeAllObjects];
            [_searchResults addObjectsFromArray:data];
            
            // Reload your search results table data.
            [self.searchController.searchResultsTableView reloadData];
        }];
        /*
        NSURL *url = [NSURL URLWithString:@"http://labs.adobe.com/technologies/spry/data/photos.csv"];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request appendPostData:[searchString dataUsingEncoding:NSUTF8StringEncoding]]; // Set the POST data to our search string
        [request startSynchronous];
        NSError *error = [request error];
        if (!error) {
            NSLog(@"Got result for %@", searchString);
            NSString *responseString = [request responseString];
            NSArray *data = [responseString componentsSeparatedByString:@","];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // Modify your instance variables here on the main
                // UI thread.
                [_searchResults removeAllObjects];
                [_searchResults addObjectsFromArray:data];
                
                // Reload your search results table data.
                [self.searchController.searchResultsTableView reloadData];
            }];
        }
         */
    }];
}

#pragma mark - Search
/*
- (void)searchRequest:(NSString *)searchString {
    NSLog(@"Searching for: %@", searchString);
    if (activeRequest != nil) {
        NSLog(@"Cancelling request!");
        [activeRequest cancel];
    }
    NSURL *url = [NSURL URLWithString:@"http://labs.adobe.com/technologies/spry/data/photos.csv"];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request appendPostData:[searchString dataUsingEncoding:NSUTF8StringEncoding]]; // Set the POST data to our search string
    
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        NSArray *data = [responseString componentsSeparatedByString:@","];
        
        [_searchResults addObjectsFromArray:data];
        [self.searchController.searchResultsTableView reloadData];
        NSLog(@"Result for %@ displayed", searchString);
        [activeRequest release];
        activeRequest = nil;

        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        if(error.code == 4) {
            NSLog(@"Canceled request for: %@", searchString);
        }
        else {
            NSLog(@"Handle this error: %@", [request error]);
        }
        [activeRequest release];
        activeRequest = nil;
    }];
    
    [request startAsynchronous];
    activeRequest = request;
    [activeRequest retain];
}
 */





@end
