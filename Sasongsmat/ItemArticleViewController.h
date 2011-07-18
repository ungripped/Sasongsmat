//
//  ItemArticleView.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-07-18.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSMSegmentedControl.h"
@class ItemArticleViewController;

typedef void (^ArticleLoadedBlock)(ItemArticleViewController *);
typedef void (^ArticleLoadFailedBlock)(NSError *);


@interface ItemArticleViewController : UIViewController <UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    SSMSegmentedControl *segmentedControl;
    
    UIWebView *itemView;
    UIWebView *infoView;
    UITableView *recipeView;
    
    NSString *initialHTML;
    NSString *infoHTML;
    NSString *itemName;
    NSDictionary *article;
    NSArray *recipes;
    
    BOOL infoLoaded;
}

@property (nonatomic, retain) IBOutlet SSMSegmentedControl *segmentedControl;


@property (nonatomic, retain) IBOutlet UIWebView *itemView;
@property (nonatomic, retain) IBOutlet UIWebView *infoView;
@property (nonatomic, retain) IBOutlet UITableView *recipeView;

@property (nonatomic, retain) NSString *initialHTML;
@property (nonatomic, retain) NSString *infoHTML;
@property (nonatomic, retain) NSString *itemName;
@property (nonatomic, retain) NSDictionary *article;
@property (nonatomic, retain) NSArray *recipes;

- (void)loadNewArticle:(NSString *)articleName;
- (void)loadArticle;
- (void)loadInfo;
- (IBAction)segmentSelected:(id)sender;

+ (void)articleControllerForArticle:(NSString *)articleName loadedBlock:(ArticleLoadedBlock)articleLoadedBlock errorBlock:(ArticleLoadFailedBlock)articleFailedBlock;

@end
