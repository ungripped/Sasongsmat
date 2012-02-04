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
#import "SSMOverviewController.h"

/*
#define FEATURED_ROW_COUNT 4

enum Sections {
    kSeasonSection = 0,
    NUM_SECTIONS
};

enum SeasonSectionRows {
    kFirstSeasonRow = 0,
    NUM_SEASON_SECTION_ROWS
};
*/

@interface FoodItemsOverviewController : SSMOverviewController <EGORefreshTableHeaderDelegate, UIWebViewDelegate, UIScrollViewDelegate> {
}

@end
