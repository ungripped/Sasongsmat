//
//  RecipesOverviewController.h
//  Sasongsmat
//
//  Created by Matti on 2011-10-21.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSMOverviewController.h"

@interface RecipesOverviewController : SSMOverviewController <EGORefreshTableHeaderDelegate, UIWebViewDelegate, UIScrollViewDelegate> {
}

@end
