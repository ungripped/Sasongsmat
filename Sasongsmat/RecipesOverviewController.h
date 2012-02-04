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
#import "EGORefreshTableHeaderView.h"
#import "LoaderView.h"


//@class ItemSearchDelegate; 

@interface RecipesOverviewController : UIViewController <EGORefreshTableHeaderDelegate, UIWebViewDelegate, UIScrollViewDelegate> {
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    
    //ItemSearchDelegate *searchDelegate;
    
    BOOL _reloading;
    UIWebView *_itemsView;
    LoaderView *_loaderView;
    UIScrollView *_parentScrollView;
    UIScrollView *_itemsScrollView;
}
@property (nonatomic, retain) IBOutlet UIWebView *itemsView;

@property (nonatomic, retain) LoaderView *loaderView;
@property (nonatomic, retain) IBOutlet UIScrollView *parentScrollView;
@property (nonatomic, retain) UIScrollView *itemsScrollView;

//@property (nonatomic, retain) IBOutlet ItemSearchDelegate *searchDelegate;

- (void)loadFoodItems;
- (void)loadRecipe:(NSString *)recipeName;

@end
