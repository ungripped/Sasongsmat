//
//  SearchResultsDelegate.h
//  AsynchSearch
//
//  Created by Matti on 2011-09-09.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SSMSearchDelegate <NSObject>

- (void)handleResult:(NSString *)result;

@end

typedef enum {
    SSMSearchTypeArticle,
    SSMSearchTypeRecipe
} SSMSearchType;

@interface SearchResultsDelegate : NSObject <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate> {
    
    id<SSMSearchDelegate> ssmDelegate;

    NSMutableArray *_searchResults;
    UISearchDisplayController *_searchController;
    
    NSOperationQueue *_searchQueue;
    
    SSMSearchType searchType;
}
@property (nonatomic, retain) IBOutlet UISearchDisplayController *searchController;
@property (nonatomic, assign) IBOutlet id<SSMSearchDelegate> ssmDelegate;
@property (nonatomic) SSMSearchType searchType;

- (void)searchRequest:(NSString *)searchString;

- (void)showResults:(NSArray *)result;
@end
