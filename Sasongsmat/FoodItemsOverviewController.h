//
//  FoodItemsOverviewController.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-06-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//[

#import <UIKit/UIKit.h>

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

@interface FoodItemsOverviewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    
    UIView *seasonHeaderView;
    UIView *seasonFooterView;
    
    NSArray *featuredFoodItems;
    NSArray *seasonFoodItems;
    
    
    BOOL isLoading;
}

@property (nonatomic, retain) UIView *seasonHeaderView;
@property (nonatomic, retain) UIView *seasonFooterView;

@property (nonatomic, retain) NSArray *seasonFoodItems;
@property (nonatomic, retain) NSArray *featuredFoodItems;

- (void)loadFoodItems;
- (void)loadArticle:(NSString *)name;


@end
