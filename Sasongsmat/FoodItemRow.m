//
//  FoodItemRow.m
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FoodItemRow.h"


@implementation FoodItemRow
@synthesize itemName, itemSeason, categoryImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [itemName release];
    [itemSeason release];
    [categoryImage release];
    
    [super dealloc];
}

@end
