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

@synthesize label, type, url;

+ (NSArray *)listItemsForJsonArray:(NSArray *)items {
    
    NSMutableArray *objItems = [[[NSMutableArray alloc] init] autorelease];
    
    for(NSDictionary *dictItem in items) {
        FoodListItem *li = [[FoodListItem alloc] init];
        
        li.url = [dictItem objectForKey:@"url"];
        li.label = [dictItem objectForKey:@"label"];
        li.type = [dictItem objectForKey:@"type"];
        
        [objItems addObject:li];
        
        [li release];
    }
    
    return objItems;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ : %@", self.label, self.type];
}

@end
