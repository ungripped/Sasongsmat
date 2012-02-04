//
//  RecipeViewController.h
//  Sasongsmat
//
//  Created by Matti on 2011-10-26.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoaderView;

@interface RecipeViewController : UIViewController <UIWebViewDelegate> {
    LoaderView *loaderView;
    
    NSString *recipeName;
    NSDictionary *recipe;
    
    NSString *initialHTML;
    UIWebView *recipeView;
}


@property (nonatomic, retain) IBOutlet UIWebView *recipeView;
@property (nonatomic, retain) LoaderView *loaderView;
@property (nonatomic, retain) NSString *recipeName;
@property (nonatomic, retain) NSDictionary *recipe;
@property (nonatomic, retain) NSString *initialHTML;

- (void)loadArticle;

@end
