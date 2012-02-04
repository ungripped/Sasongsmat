//
//  FoodItemsOverviewController.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-07-18.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LoaderView.h"

@class ItemSearchDelegate; 

#define FEATURED_ROW_COUNT 4

enum Sections {
    kSeasonSection = 0,
    NUM_SECTIONS
};

enum SeasonSectionRows {
    kFirstSeasonRow = 0,
    NUM_SEASON_SECTION_ROWS
};

@interface FoodItemsOverviewController : UIViewController <EGORefreshTableHeaderDelegate, UIWebViewDelegate, UIScrollViewDelegate> {
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    ItemSearchDelegate *searchDelegate;
    BOOL _reloading;
    UIWebView *_itemsView;
    LoaderView *_loaderView;
    UIScrollView *_parentScrollView;
    UIScrollView *_itemsScrollView;
    
    
}
@property (nonatomic, retain) IBOutlet UIWebView *itemsView;

@property (nonatomic, retain) LoaderView *loaderView;
@property (nonatomic, retain) IBOutlet UIScrollView *parentScrollView;
@property (nonatomic, retain) UIScrollView *itemsScrollView;

@property (nonatomic, retain) IBOutlet ItemSearchDelegate *searchDelegate;

- (void)loadFoodItems;
- (void)loadArticle:(NSString *)article;

@end
