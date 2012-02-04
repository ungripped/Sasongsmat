//
//  SearchResultsDelegate.h
//  AsynchSearch
//
//  Created by Matti on 2011-09-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ASIHTTPRequest;

@interface SearchResultsDelegate : NSObject <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate> {
    
    ASIHTTPRequest *activeRequest;
    
    NSMutableArray *_searchResults;
    UISearchDisplayController *_searchController;
    
    NSOperationQueue *_searchQueue;
}
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchController;

@property (nonatomic, retain) ASIHTTPRequest *activeRequest;

- (void)searchRequest:(NSString *)searchString;

- (void)showResults:(NSArray *)result;
@end
