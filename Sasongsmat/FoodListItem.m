//
//  FoodListItem.m
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-07-18.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "FoodListItem.h"


@implementation FoodListItem

@synthesize name, iconName, baseCategory;

+ (NSArray *)listItemsForJsonArray:(NSArray *)items {
    NSLog(@"%@", items);
    NSMutableArray *objItems = [[[NSMutableArray alloc] init] autorelease];
    
    for(NSDictionary *dictItem in items) {
        FoodListItem *li = [[FoodListItem alloc] init];
        
        li.name = [dictItem objectForKey:@"namn"];
        
        NSString *bc = [dictItem objectForKey:@"baskategori"];
        
        if ([bc isEqualToString:@"Frukt och grönsaker"]) {
            li.baseCategory = Fruit;
            li.iconName = @"fruit";
        }
        else if ([bc isEqualToString:@"Fisk och skaldjur"]) {
            li.baseCategory = Fish;
            li.iconName = @"fish";
        }
        else if ([bc isEqualToString:@"Kött"]) {
            li.baseCategory = Meat;
            li.iconName = @"meat";
        }
        
        [objItems addObject:li];
        
        [li release];
    }
    
    return objItems;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ : %@", self.name, self.iconName];
}

@end
