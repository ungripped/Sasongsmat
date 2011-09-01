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
    InSeason
};


@interface SeasonInfoItem : NSObject {
    int seasonData[12];
}

- (id)initWithDictionary:(NSDictionary *)months;

@end
