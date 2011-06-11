//
//  FoodItemRow.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FoodItemRow : UITableViewCell {
    UILabel *itemName;
    UILabel *itemSeason;
    
    UIImageView *categoryImage;
}

@property (nonatomic, retain) IBOutlet UILabel *itemName;
@property (nonatomic, retain) IBOutlet UILabel *itemSeason;
@property (nonatomic, retain) IBOutlet UIImageView *categoryImage;

@end
