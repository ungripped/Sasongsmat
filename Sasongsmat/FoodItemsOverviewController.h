//
//  FoodItemsOverviewController.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-06-10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

enum Sections {
    kSeasonSection = 0,
    NUM_SECTIONS
};

enum SeasonSectionRows {
    kFirstSeasonRow = 0,
    NUM_SEASON_SECTION_ROWS
};

@interface FoodItemsOverviewController : UITableViewController {
    
    UIView *seasonHeaderImageView;
}

@property (nonatomic, retain) IBOutlet UIView *seasonHeaderImageView;
@end
