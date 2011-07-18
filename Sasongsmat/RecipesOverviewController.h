//
//  RecipesOverviewController.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-07-18.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

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

@interface RecipesOverviewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    
    UIView *seasonHeaderView;
    UIView *seasonFooterView;
    
    NSArray *featuredRecipes;
    NSArray *seasonRecipes;
    
    
    BOOL isLoading;
}

@property (nonatomic, retain) UIView *seasonHeaderView;
@property (nonatomic, retain) UIView *seasonFooterView;

@property (nonatomic, retain) NSArray *seasonRecipes;
@property (nonatomic, retain) NSArray *featuredRecipes;

- (void)loadRecipes;
- (void)loadRecipeWithIndexPath:(NSIndexPath *)indexPath;
- (void)loadRecipe:(NSString *)name;


@end
