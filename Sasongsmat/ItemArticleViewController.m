//
//  ItemArticleView.m
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-07-18.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "ItemArticleViewController.h"
#import "LoaderView.h"
#import "SSMApiClient.h"

@implementation ItemArticleViewController
@synthesize segmentedControl;
@synthesize itemView;
@synthesize infoView;
@synthesize recipeView;
@synthesize initialHTML, itemName;
@synthesize infoHTML;
@synthesize article;
@synthesize recipes;
@synthesize loaderView;

/*
+ (void)articleControllerForArticle:(NSString *)articleName loadedBlock:(ArticleLoadedBlock)articleLoadedBlock errorBlock:(ArticleLoadFailedBlock)articleFailedBlock {
    
    SSMApi *api = [SSMApi sharedSSMApi];
    
    [api getArticleWithName:articleName loadedBlock:^(NSDictionary *article) {
        
        ItemArticleViewController *controller = [[[ItemArticleViewController alloc] initWithNibName:@"ItemArticleView" bundle:nil] autorelease];
        
        controller.article = article;
        
        articleLoadedBlock(controller);  
        
    } error:^(NSError *error) {
        articleFailedBlock(error);
    }];
}
*/


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
    [infoHTML release];
    [itemName release];
    [segmentedControl release];
    [recipeView release];
    [article release];
    [recipes release];
    [infoView release];
    [loaderView release];
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
    self.loaderView.loadingLabel.text = @"Laddar artikel...";
    
    [self.view addSubview:self.loaderView];
    
    
    //http://xn--ssongsmat-v2a.nu/w/api.php?action=parse&format=json&page=Mangold
    
    NSDictionary *dict = [NSDictionary 
                          dictionaryWithObjects:[NSArray arrayWithObjects:@"parse", @"json", self.itemName, nil]
                          
                          forKeys:[NSArray arrayWithObjects:@"action", @"format", @"page", nil]];

    SSMApiClient *client = [SSMApiClient sharedClient];
    [client getPath:@"w/api.php" parameters:dict success:^(id object) {
        article = [(NSDictionary *)object retain];
        
        self.initialHTML = [article valueForKeyPath:@"parse.text.*"];
        
        //NSLog(@"%@", self.initialHTML);
        
        self.itemName = [article valueForKeyPath:@"parse.displaytitle"];
        self.navigationItem.title = self.itemName;
        
        NSMutableArray *articleReceipes = [NSMutableArray array];
        
        NSArray *links = [article valueForKeyPath:@"parse.links"];
        for (NSDictionary *link in links) {
            NSLog(@"%@", link);
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
        [self.recipeView reloadData];
        
        [self loadArticle];

        
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
        // set up views
     /*
          */
}

- (void)viewDidUnload
{
    [self setItemView:nil];
    [self setSegmentedControl:nil];
    [self setRecipeView:nil];
    [self setInfoView:nil];
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
    
    NSLog(@"%@", html);
    [itemView loadHTMLString:html baseURL:baseURL];
    [self.loaderView fadeOut];
}

- (void)loadInfo {
    self.infoHTML = [itemView stringByEvaluatingJavaScriptFromString:@"removeInfoBoxes();"];
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    
    NSString *js = @"<script src=\"jquery.js\"></script><script src=\"articleInfo.js\"></script>";
    NSString *css = @"<link rel=\"stylesheet\" href=\"articleInfo.css\" type=\"text/css\" media=\"screen\" charset=\"utf-8\">";
    
    NSString *html = [NSString stringWithFormat:@"%@%@%@", js, css, self.infoHTML];

    [infoView loadHTMLString:html baseURL:baseURL];
    infoLoaded = YES;
}


- (IBAction)segmentSelected:(id)sender {
    NSInteger selected = segmentedControl.selectedSegmentIndex;

    switch (selected) {
        case 0:
            itemView.hidden = NO;
            recipeView.hidden = YES;
            infoView.hidden = YES;
            break;
        case 1:
            itemView.hidden = YES;
            recipeView.hidden = NO;
            infoView.hidden = YES;
            break;
        case 2:
            itemView.hidden = YES;
            recipeView.hidden = YES;
            infoView.hidden = NO;
            
            // TODO: perhaps move views into their own controllers...?
            if (!infoLoaded) { [self loadInfo]; }
            break;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    NSURL *url = [request mainDocumentURL];
    //NSString *ret = [url path];
    
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
    
    ItemArticleViewController *controller = [[ItemArticleViewController alloc] initWithNibName:@"ItemArticleView" bundle:nil];
    controller.itemName = articleName;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}


/*

- (void)loadNewArticle:(NSString *)articleName {
    // TODO: Show load indicator...
    
    [ItemArticleViewController articleControllerForArticle:articleName loadedBlock:^(ItemArticleViewController * controller) {
        [self.navigationController pushViewController:controller animated:YES];
    } errorBlock:^(NSError * error) {
        if(error.code == ASIRequestCancelledErrorType) {
            NSLog(@"Request cancelled, ignoring error callback block.");
        }
        else {
            // Handle error
            NSLog(@"Error loading article: %@", [error localizedDescription]);
        }
    }];
}

 */
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([recipes count] > 0) {
        return [recipes count];
    }
    else { 
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecipeCell"] autorelease];
        
    }
    
    if ([recipes count] > 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [recipes objectAtIndex:indexPath.row];
    }
    else {
        cell.textLabel.text = [NSString stringWithFormat:@"Det finns ännu inga recept med %@", self.itemName];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([recipes count] > 0) {
        NSLog(@"Show recipe: %@", [recipes objectAtIndex:indexPath.row]);
    }
    else {
        NSLog(@"No recipes.");
    }
}


@end
