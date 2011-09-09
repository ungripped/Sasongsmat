//
//  FoodItemsUtilities.h
//  Sasongsmat
//
//  Created by Matti on 2011-09-02.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FoodListItem;

@interface FoodItemsUtilities : NSObject

+ (UITableViewCell *)foodItemCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath forItem:(FoodListItem *)item;

+ (void)loadArticleWithIndexPath:(NSIndexPath *)indexPath onTableView:(UITableView *)tableView foodListItem:(FoodListItem *)item navigationController:(UINavigationController *)navigationController;

//+ (void)loadArticleWithIndexPath:(NSIndexPath *)indexPath onTableView:(UITableView *)tableView articleName:(NSString *)name navigationController:(UINavigationController *)navigationController;

@end
