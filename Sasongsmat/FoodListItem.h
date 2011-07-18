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


@interface FoodListItem : NSObject {
    
}

@property (nonatomic, retain) NSString *label;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *url;


+ (NSArray *)listItemsForJsonArray:(NSArray *)items;


- (NSString *)description;

@end
