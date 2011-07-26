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

enum BaseCategory {
    Fruit,
    Meat,
    Fish
};


@interface FoodListItem : NSObject {
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *iconName;
@property (nonatomic) enum BaseCategory baseCategory;

+ (NSArray *)listItemsForJsonArray:(NSArray *)items;


- (NSString *)description;

@end
