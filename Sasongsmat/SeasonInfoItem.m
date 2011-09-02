//
//  SeasonInfoItem.m
//  Sasongsmat
//
//  Created by Matti on 2011-09-01.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "SeasonInfoItem.h"

@implementation SeasonInfoItem
@synthesize seasonData;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)months {
    
    self = [self init];
    
    if (self) {
        NSArray *keys = [months allKeys];
        NSMutableArray *tempData = [NSMutableArray arrayWithCapacity:12];
        for (int i = 0; i < 12; i++) {
            [tempData addObject:[NSNull null]];
        }
        
        for (NSString *key in keys) {
            int monthIndex = [[key substringFromIndex:6] intValue] - 1;
            int val = [[months objectForKey:key] intValue];
            
            if (val == 0) {
                [tempData replaceObjectAtIndex:monthIndex withObject:[NSNumber numberWithInt:NotInSeason]];
            }
            else if (val > 15 && val < 28) {
                [tempData replaceObjectAtIndex:monthIndex withObject:[NSNumber numberWithInt:LargelyInSeason]];
            }
            else if (val > 0 && val <= 15) {
                [tempData replaceObjectAtIndex:monthIndex withObject:[NSNumber numberWithInt:PartlyInSeason]];
            }
            else if (val >= 28) {
                 [tempData replaceObjectAtIndex:monthIndex withObject:[NSNumber numberWithInt:InSeason]];
            }
            else {
                [tempData insertObject:[NSNumber numberWithInt:-1] atIndex:monthIndex];
            }
        }
        self.seasonData = [NSArray arrayWithArray:tempData];
    }
    
    return self;
}

- (void)dealloc {
    [seasonData release];
    [super dealloc];
}

- (NSString *)description {
    NSMutableString *str = [NSMutableString stringWithCapacity:24];
    
    for (NSNumber *s in seasonData) {
        [str appendFormat:@"%d:", [s intValue]];
    }
    
    return str;
}

@end
