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
    [itemView release];
    [initialHTML release];
    [urlString release];
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
    [self loadArticle];
}

- (void)viewDidUnload
{
    [self setItemView:nil];
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
    
    //[self initJavaScript:@"jquery"];
    //[self initJavaScript:@"article"];
}

- (void)initJavaScript:(NSString *)fileName {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jquery" ofType:@"js" inDirectory:@""];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSString *jqString = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    
    NSString *jsString = [NSString stringWithFormat:@"var script = document.createElement('script');"  
     "script.type = 'text/javascript';"  
     "script.text = \"%@\";"  
     "document.head.appendChild(script);", jqString]; 
    
    NSLog(@"%@", jsString);
    [itemView stringByEvaluatingJavaScriptFromString:jsString];
    
    NSLog(@"Loading javascript: %@", fileName);
    filePath = [[NSBundle mainBundle] pathForResource:@"article" ofType:@"js" inDirectory:@""];
    fileData = [NSData dataWithContentsOfFile:filePath];
    jsString = [[NSMutableString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
              
    
        
    NSLog(@"jsstring: %@", jsString);
    NSString * js = [itemView stringByEvaluatingJavaScriptFromString:jsString];
    
    NSLog(@"js: %@", js);
}

- (IBAction)reload:(id)sender {
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSLog(@"Fetching article: %@", url);
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        
        NSDictionary *responseJson = (NSDictionary *)[responseString JSONValue];
        
        NSString *fullArticle = [responseJson valueForKeyPath:@"parse.text.*"];
        
        NSLog(@"response: %@", fullArticle);
        
        self.initialHTML = fullArticle;
        
        [self loadArticle];
    }];
    
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"Error: %@", error);
        
        // TODO: Set error message and tap-message in section footer
    }];
    
    [request startAsynchronous];
}
@end
