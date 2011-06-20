//
//  ItemArticleView.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-06-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ItemArticleViewController : UIViewController {
    
    UIWebView *itemView;
    NSString *initialHTML;
    NSString *urlString;
}
@property (nonatomic, retain) IBOutlet UIWebView *itemView;
@property (nonatomic, retain) NSString *initialHTML;
@property (nonatomic, retain) NSString *urlString;

- (IBAction)reload:(id)sender;
- (void)loadArticle;
- (void)initJavaScript:(NSString *)fileName;

@end
