//
//  FoodItemsCompleteListController.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-06-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FoodItemsCompleteListController : UITableViewController {
        
    NSArray *seasonFoodItems;
}

@property (nonatomic, retain) NSArray *seasonFoodItems;

- (void)loadArticle:(NSString *)name;

@end
