//
//  FoodItemsUtilities.m
//  Sasongsmat
//
//  Created by Matti on 2011-09-02.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "FoodItemsUtilities.h"
#import "SeasonIndicatorView.h"
#import "FoodListItem.h"

@implementation FoodItemsUtilities

+ (UITableViewCell *)foodItemCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath forItem:(FoodListItem *)item {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FoodItemRowCell"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"FoodItemRowCell"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    cell.textLabel.text = item.name;
    
    SeasonIndicatorView *indicatorView = [[SeasonIndicatorView alloc] initWithFrame:CGRectMake(60, 30, 230, 20)];
    
    indicatorView.seasonInfoItem = item.seasonInfo;
    [cell addSubview:indicatorView];
    
    [indicatorView release];
    cell.detailTextLabel.text = @" ";
    
    UIImage *image = [UIImage imageNamed:item.iconName];
    cell.imageView.image = image;
    return cell;
}


- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
