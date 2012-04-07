//
//  SSMOverviewController.m
//  Sasongsmat
//
//  Created by Matti on 2012-02-04.
//  Copyright (c) 2012 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "SSMOverviewController.h"
#import "SSMWebClient.h"
#import "AFHTTPRequestOperation.h"


@implementation SSMOverviewController

@synthesize itemsView = _itemsView;
@synthesize loaderView = _loaderView;
@synthesize parentScrollView = _parentScrollView;
@synthesize itemsScrollView = _itemsScrollView;

@synthesize searchDelegate;

- (void)dealloc
{
    [searchDelegate release];
    [_itemsView release];
    [_parentScrollView release];
    [_itemsScrollView release];
    [_loaderView release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loaderView = [[LoaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.loaderView.alpha = 1.0;
    
    [self.view addSubview:self.loaderView];
    
    for (id subview in self.itemsView.subviews) {
        if ([[subview class] isSubclassOfClass: [UIScrollView class]])
        {
            // Find the UIScrollView of the UIWebView
            self.itemsScrollView = (UIScrollView *)subview;
            
            //view.bounces = NO;
            self.itemsScrollView.delegate = self;
            
            // Hook in the EGORefreshTableHeaderView on the UIWebView
            if (_refreshHeaderView == nil) {
                EGORefreshTableHeaderView *headerView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.view.bounds.size.height, self.view.frame.size.width, self.view.bounds.size.height)];
                headerView.delegate = self;
                [self.itemsScrollView addSubview:headerView];
                _refreshHeaderView = headerView;
                [headerView release];
            }
            
        }
    }
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spring.png"]];
    titleView.alpha = .1f;
    self.navigationItem.titleView = titleView;
    [titleView release];
    
    self.navigationItem.title = viewTitle;
    _reloading = NO;
    
    [self loadFoodItems];
    
    
	
	//  update the last update date
	[_refreshHeaderView refreshLastUpdatedDate];
}

- (void)loadFoodItems {
    _reloading = YES;
    SSMWebClient *client = [SSMWebClient sharedClient];
    [client getPath:listType parameters:nil success:^(id object) {
        [self.loaderView fadeOut];
        [self.itemsView loadHTMLString:[object responseString] baseURL:client.baseURL];
        _reloading = NO;
        
        
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error: %@", error);
        // Show error message in loader view
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.parentScrollView) {
        
    }
    else {
        CGPoint off = [scrollView contentOffset];
        //NSLog(@"%f - %f", off.x, off.y);
        CGPoint newOff;
        if (off.y < 88 && off.y >= 0)
            newOff = CGPointMake(0, off.y / 2);
        else if (off.y >= 88)
            newOff = CGPointMake(0, 44);
        else if (off.y < 0) {
            newOff = CGPointMake(0, 0);
            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        }
        //NSLog(@"new off: %f - %f", newOff.x, newOff.y);
        self.parentScrollView.contentOffset = newOff;
        
        
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    _reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.itemsScrollView];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request mainDocumentURL];
    
    switch (navigationType) {
        case UIWebViewNavigationTypeOther:
            return YES;
        case UIWebViewNavigationTypeLinkClicked:
            if ([[url scheme] isEqualToString:@"ssm"]) {
                [self loadArticle:[url lastPathComponent]];
            }
            return NO;
        default:
            return NO;
    }
}

- (void)loadArticle:(NSString *)article {
    
    /*
    
    ItemArticleViewController *controller = [[ItemArticleViewController alloc] initWithNibName:@"ItemArticleView" bundle:nil];
    controller.itemName = article;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
     */
}


- (void)viewDidUnload
{
    [self setSearchDelegate:nil];
    [self setItemsView:nil];
    [self setParentScrollView:nil];
    [self setLoaderView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}

#pragma mark - EGORefreshTableHeaderDelegate methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view {
    
    NSLog(@"Did trigger refresh...");
    [self loadFoodItems];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view {
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view {
    return [NSDate date];
}

@end
