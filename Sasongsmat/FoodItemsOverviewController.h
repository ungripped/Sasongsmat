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

#define FEATURED_ROW_COUNT 4

enum Sections {
    kSeasonSection = 0,
    kCategoriesSection,
    NUM_SECTIONS
};

enum SeasonSectionRows {
    kFirstSeasonRow = 0,
    NUM_SEASON_SECTION_ROWS
};

@interface FoodItemsOverviewController : UITableViewController <EGORefreshTableHeaderDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    UIView *seasonHeaderView;
    UIView *seasonFooterView;
    
    NSArray *featuredFoodItems;
    NSArray *seasonFoodItems;
    
    
    //BOOL isLoading;
    BOOL _reloading;
}

@property (nonatomic, retain) UIView *seasonHeaderView;
@property (nonatomic, retain) UIView *seasonFooterView;

@property (nonatomic, retain) NSArray *seasonFoodItems;
@property (nonatomic, retain) NSArray *featuredFoodItems;

- (void)loadFoodItems;
- (void)loadArticleWithIndexPath:(NSIndexPath *)indexPath;


@end
