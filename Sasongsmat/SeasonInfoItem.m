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
        
        for (NSString *key in keys) {
            int monthIndex = [[key substringFromIndex:6] intValue] - 1;
            int val = [[months objectForKey:key] intValue];
            
            if (val == 0) {
                seasonData[monthIndex] = NotInSeason;
            }
            else if (val > 0 && val < 28) {
                seasonData[monthIndex] = PartlyInSeason;
            }
            else if (val >= 28) {
                seasonData[monthIndex] = InSeason;
            }
            else {
                seasonData[monthIndex] = -1; // Invalid
            }
        }
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d:%d",
            seasonData[0], seasonData[1], seasonData[2], seasonData[3],seasonData[4], seasonData[5], seasonData[6], seasonData[7], seasonData[8], seasonData[9], seasonData[10], seasonData[11]];
}

@end
