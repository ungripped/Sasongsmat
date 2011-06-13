//
//  FoodListItem.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-06-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
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
