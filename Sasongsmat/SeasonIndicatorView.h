//
//  SeasonIndicatorView.h
//  Sasongsmat
//
//  Created by Matti on 2011-09-02.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SeasonInfoItem.h"

@interface SeasonIndicatorView : UIView

@property (nonatomic, retain) SeasonInfoItem *seasonInfoItem;
@end
