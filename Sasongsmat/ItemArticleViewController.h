//
//  ItemArticleView.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-06-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemArticleViewController;

typedef void (^ArticleLoadedBlock)(ItemArticleViewController *);
typedef void (^ArticleLoadFailedBlock)(NSError *);


@interface ItemArticleViewController : UIViewController <UIWebViewDelegate> {
    
    UISegmentedControl *segmentedControl;
    
    UIWebView *itemView;
    UITableView *recipeView;
    
    NSString *initialHTML;
    NSDictionary *article;
    NSArray *recipes;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;


@property (nonatomic, retain) IBOutlet UIWebView *itemView;
@property (nonatomic, retain) IBOutlet UITableView *recipeView;

@property (nonatomic, retain) NSString *initialHTML;
@property (nonatomic, retain) NSDictionary *article;
@property (nonatomic, retain) NSArray *recipes;

- (void)loadNewArticle:(NSString *)articleName;
- (void)loadArticle;
- (IBAction)segmentSelected:(id)sender;

+ (void)articleControllerForArticle:(NSString *)articleName loadedBlock:(ArticleLoadedBlock)articleLoadedBlock errorBlock:(ArticleLoadFailedBlock)articleFailedBlock;

@end
