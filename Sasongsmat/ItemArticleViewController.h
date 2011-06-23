//
//  ItemArticleView.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-06-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemArticleViewController : UIViewController <UIWebViewDelegate> {
    
    UIWebView *itemView;
    UITableView *recipeView;
    NSString *initialHTML;
    NSString *urlString;
    UISegmentedControl *segmentedControl;
}
@property (nonatomic, retain) IBOutlet UIWebView *itemView;
@property (nonatomic, retain) IBOutlet UITableView *recipeView;
@property (nonatomic, retain) NSString *initialHTML;
@property (nonatomic, retain) NSString *urlString;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

- (void)loadNewArticle:(NSString *)article;
- (void)loadArticle;
- (IBAction)segmentSelected:(id)sender;

@end
