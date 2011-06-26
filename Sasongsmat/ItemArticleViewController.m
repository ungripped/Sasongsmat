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
#import "SSMNavigationBar.h"

@implementation ItemArticleViewController
@synthesize segmentedControl;
@synthesize itemView;
@synthesize recipeView;
@synthesize initialHTML;
@synthesize article;
@synthesize recipes;

+ (void)articleControllerForArticle:(NSString *)articleName loadedBlock:(ArticleLoadedBlock)articleLoadedBlock errorBlock:(ArticleLoadFailedBlock)articleFailedBlock {
    
    NSLog(@"Loading article: %@", articleName);
    NSString *urlString = [NSString stringWithFormat:@"http://www.xn--ssongsmat-v2a.nu/w/api.php?action=parse&page=%@&format=json", [articleName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary *responseJson = (NSDictionary *)[responseString JSONValue];
        
        ItemArticleViewController *controller = [[[ItemArticleViewController alloc] initWithNibName:@"ItemArticleView" bundle:nil] autorelease];
        
        controller.article = responseJson;
        
        articleLoadedBlock(controller);        
    }];
    
    [request setFailedBlock:^{
        articleFailedBlock([request error]);
    }];
    
    [request startAsynchronous];
}

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
    [segmentedControl release];
    [recipeView release];
    [article release];
    [recipes release];
    
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

    self.initialHTML = [article valueForKeyPath:@"parse.text.*"];
    self.navigationItem.title = [article valueForKeyPath:@"parse.displaytitle"];

    NSMutableArray *articleReceipes = [NSMutableArray array];
    
    NSArray *links = [article valueForKeyPath:@"parse.links"];
    for (NSDictionary *link in links) {
        
        NSNumber *ns = [link objectForKey:@"ns"];
        if ([ns isEqualToNumber:[NSNumber numberWithInt:550]]) {
            NSString *fullRecipeName = [link objectForKey:@"*"];
            
            NSRange range = [fullRecipeName rangeOfString:@"Recept:"];
            
            if (range.location == 0) {
                [articleReceipes addObject:[fullRecipeName substringFromIndex:range.length]];
            }
        }
    }

    NSLog(@"Recipes: %@", articleReceipes);
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
    [self setRecipeView:nil];
    [super viewDidUnload];
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
    NSInteger selected = segmentedControl.selectedSegmentIndex;

    switch (selected) {
        case 0:
            recipeView.hidden = YES;
            itemView.hidden = NO;
            break;
            
        case 1:
            itemView.hidden = YES;
            recipeView.hidden = NO;
            break;
        default:
            NSLog(@"Selected: %d", selected);
            break;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request mainDocumentURL];
    NSString *ret = [url path];
    
    NSLog(@"URL: %@", ret);
    
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


- (void)loadNewArticle:(NSString *)articleName {
    // TODO: Show load indicator...
    
    [ItemArticleViewController articleControllerForArticle:articleName loadedBlock:^(ItemArticleViewController * controller) {
        [self.navigationController pushViewController:controller animated:YES];
    } errorBlock:^(NSError * error) {
        NSLog(@"Error loading article: %@", error);
    }];
}

@end
