//
//  SeasonInfoItem.h
//  Sasongsmat
//
//  Created by Matti on 2011-09-01.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <Foundation/Foundation.h>

enum SeasonStatus {
    NotInSeason,
    PartlyInSeason,
    LargelyInSeason,
    InSeason
};


@interface SeasonInfoItem : NSObject {
}

@property (nonatomic, retain) NSArray *seasonData;

- (id)initWithDictionary:(NSDictionary *)months;

@end
