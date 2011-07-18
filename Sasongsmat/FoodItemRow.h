//
//  FoodItemRow.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-07-18.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
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
