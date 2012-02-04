//
//  RecipeViewController.m
//  Sasongsmat
//
//  Created by Matti on 2011-10-26.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "RecipeViewController.h"
#import "SSMApiClient.h"
#import "LoaderView.h"


@implementation RecipeViewController

@synthesize recipeView;
@synthesize loaderView;
@synthesize recipe;
@synthesize recipeName, initialHTML;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    self.loaderView.loadingLabel.text = @"Laddar artikel...";
    
    [self.view addSubview:self.loaderView];
    
    
    //http://xn--ssongsmat-v2a.nu/w/api.php?action=parse&format=json&page=Mangold
    
    NSDictionary *dict = [NSDictionary 
                          dictionaryWithObjects:[NSArray arrayWithObjects:@"parse", @"json", self.recipeName, nil]
                          
                          forKeys:[NSArray arrayWithObjects:@"action", @"format", @"page", nil]];
    
    SSMApiClient *client = [SSMApiClient sharedClient];
    [client getPath:@"w/api.php" parameters:dict success:^(id object) {
        recipe = [(NSDictionary *)object retain];
        
        self.initialHTML = [recipe valueForKeyPath:@"parse.text.*"];
        
        //NSLog(@"%@", self.initialHTML);
        
        self.recipeName = [recipe valueForKeyPath:@"parse.displaytitle"];
        self.navigationItem.title = self.recipeName;
        
        /*
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
        
        self.recipes = articleReceipes;
        */
        [self loadArticle];
        
        
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)loadArticle {
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSLog(@"%@", path);
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *js = @"<script src=\"jquery.js\"></script><script src=\"recipe.js\"></script>";
    NSString *css = @"<link rel=\"stylesheet\" href=\"recipe.css\" type=\"text/css\" media=\"screen\" charset=\"utf-8\">";
    
    NSString *html = [NSString stringWithFormat:@"%@%@%@", js, css, self.initialHTML];
    
    //NSLog(@"%@", html);
    [recipeView loadHTMLString:html baseURL:baseURL];
    [self.loaderView fadeOut];
}


- (void)viewDidUnload
{
    [self setRecipeView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [recipeView release];
    [super dealloc];
}
@end
