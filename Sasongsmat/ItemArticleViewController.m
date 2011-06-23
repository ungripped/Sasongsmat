//
//  ItemArticleView.m
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-06-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ItemArticleViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@implementation ItemArticleViewController
@synthesize segmentedControl;
@synthesize itemView;
@synthesize initialHTML, urlString;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    itemView.delegate = nil;
    [itemView release];
    [initialHTML release];
    [urlString release];
    [segmentedControl release];
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
    
    /*
    [segmentedControl setImage:[UIImage imageNamed:@"segment_selected.png"]forSegmentAtIndex:0];
    [segmentedControl setImage:[UIImage imageNamed:@"segment_middle.png"]forSegmentAtIndex:1];
    [segmentedControl setImage:[UIImage imageNamed:@"segment_normal.png"]forSegmentAtIndex:2];

    */
    
    [self loadArticle];
}

- (void)viewDidUnload
{
    [self setItemView:nil];
    [self setSegmentedControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)loadArticle {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *js = @"<script src=\"jquery.js\"></script><script src=\"article.js\"></script>";
    NSString *css = @"<link rel=\"stylesheet\" href=\"article.css\" type=\"text/css\" media=\"screen\" charset=\"utf-8\">";
    
    NSString *html = [NSString stringWithFormat:@"%@%@%@", js, css, self.initialHTML];
    [itemView loadHTMLString:html baseURL:baseURL];
}

- (IBAction)segmentSelected:(id)sender {
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request mainDocumentURL];
    NSString *ret = [url path];
    
    NSLog(@"URL: %@", ret);
    
    NSLog(@"Navtype: %d", navigationType);
    
    switch (navigationType) {
        case UIWebViewNavigationTypeOther:
            return YES;
        case UIWebViewNavigationTypeLinkClicked:
            if ([url pathExtension] != nil &&
                ![[url pathExtension] isEqualToString:@""]) {
                NSLog(@"Path with extension: '%@'", [url pathExtension]);
                return NO;
            }
            NSString *obj = [url lastPathComponent];
            [self loadNewArticle:obj];
            return NO;
        default:
            return NO;
    }
}


// TODO: loadNewArticle is just proof of concept, do refactor...
- (void)loadNewArticle:(NSString *)article {
    NSString *newUrlString = [NSString stringWithFormat:@"http://www.xn--ssongsmat-v2a.nu/w/api.php?action=parse&page=%@&format=json", [article stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:newUrlString];
    
    NSLog(@"Fetching article: %@", url);
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        
        NSDictionary *responseJson = (NSDictionary *)[responseString JSONValue];
        
        NSString *fullArticle = [responseJson valueForKeyPath:@"parse.text.*"];
        
        NSLog(@"response: %@", fullArticle);
        
        ItemArticleViewController *controller = [[ItemArticleViewController alloc] initWithNibName:@"ItemArticleView" bundle:nil];
        controller.initialHTML = fullArticle;
        controller.urlString = urlString;
        controller.navigationItem.title = article;
        
        [self.navigationController pushViewController:controller animated:YES];
        
        
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", error);
        
        // TODO: Set error message and tap-message in section footer
    }];
    
    [request startAsynchronous];
}

@end
