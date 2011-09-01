//
//  FoodListItem.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-07-18.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeasonInfoItem.h"

enum BaseCategory {
    Fruit,
    Meat,
    Fish
};


@interface FoodListItem : NSObject {
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic) int interestWeight;
@property (nonatomic) enum BaseCategory baseCategory;
@property (nonatomic, retain) SeasonInfoItem *seasonInfo;

+ (NSArray *)listItemsForJsonArray:(NSArray *)items;


- (NSString *)description;

@end
