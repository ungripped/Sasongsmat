//
//  KnownItemViewController.m
//  Sasongsmat
//
//  Created by Matti on 2012-02-05.
//  Copyright (c) 2012 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "KnownItemViewController.h"
#import "ItemArticleViewController.h"
#import "RecipeViewController.h"
#import "SSMApiClient.h"

@interface KnownItemViewController () {
    NSArray *recipes;
    NSArray *alternatives;
}

@property (nonatomic, retain) NSArray *recipes;
@property (nonatomic, retain) NSArray *alternatives;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForItemDescriptionAtRow:(int)row;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForBarcodeInfoAtRow:(int)row;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRecipeAtRow:(int)row;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForAlternativeAtRow:(int)row;

- (void)loadRecipesForArticle:(NSString *)articleName;
- (void)loadAlternativesForArticle:(NSString *)articleName;



@end

@implementation KnownItemViewController

@synthesize barcodeInfo;
@synthesize recipes;
@synthesize alternatives;
@synthesize itemNameLabel;
@synthesize seasonInfoLabel;
@synthesize seasonActivityIndicator;
@synthesize itemInfoCell;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

# pragma mark - Load extra stuff

- (void)loadRecipesForArticle:(NSString *)articleName {
    //NSLog(@"Loading recipes for article: %@", articleName);
    SSMApiClient *client = [SSMApiClient sharedClient];
    
    NSArray *parameterKeys = [NSArray arrayWithObjects:
                              @"action",
                              @"format",
                              @"titles",
                              @"prop",
                              @"plnamespace",
                              nil];
    
    NSArray *parameterVaues = [NSArray arrayWithObjects:
                               @"query",
                               @"json",
                               articleName,
                               @"info|links",
                               @"550",
                               nil];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:parameterVaues forKeys:parameterKeys];
    
    [client getPath:@"w/api.php" parameters:parameters success:^(id object) {
        NSDictionary *recipeResponse = [(NSDictionary *)object retain];
        //NSLog(@"%@", recipeResponse);
        
        NSDictionary *pages = [recipeResponse valueForKeyPath:@"query.pages"];
        NSDictionary *page = [[pages allValues] objectAtIndex:0];
        
        NSMutableArray *articleReceipes = [NSMutableArray array];
        NSArray *links = [page objectForKey:@"links"];
        for (NSDictionary *link in links) {
            //NSLog(@"%@", link);
            NSNumber *ns = [link objectForKey:@"ns"];
            if ([ns isEqualToNumber:[NSNumber numberWithInt:550]]) {
                NSString *fullRecipeName = [link objectForKey:@"title"];
                
                NSRange range = [fullRecipeName rangeOfString:@"Recept:"];
                
                if (range.location == 0) {
                    [articleReceipes addObject:[fullRecipeName substringFromIndex:range.length]];
                }
            }
        }
        
        self.recipes = articleReceipes;
        [self.tableView reloadData];
        
        [recipeResponse release];
        
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];
    
    
    
}

- (void)loadAlternativesForArticle:(NSString *)articleName {
    //NSLog(@"Loading alternatives for article: %@", articleName);
    SSMApiClient *client = [SSMApiClient sharedClient];
    
    NSArray *parameterKeys = [NSArray arrayWithObjects:
                              @"action",
                              @"query",
                              @"format",
                              nil];
    
    NSArray *parameterVaues = [NSArray arrayWithObjects:
                               @"ask",
                               [NSString stringWithFormat:@"[[%@]]|?Kan ersättas med", articleName],
                               @"json",
                               nil];
    
    NSDictionary *parameters = [NSDictionary dictionaryWithObjects:parameterVaues forKeys:parameterKeys];
    
    [client getPath:@"w/api.php" parameters:parameters success:^(id object) {
        NSDictionary *alternativesResponse = [(NSDictionary *)object retain];
        
        NSDictionary *results = [alternativesResponse valueForKeyPath:@"query.results"];
        NSDictionary *article = [[results allValues] objectAtIndex:0];
        
        
        NSArray *alts = [[[article objectForKey:@"printouts"] allValues] objectAtIndex:0];
        NSMutableArray *articleAlternatives = [NSMutableArray array];
        //NSLog(@"Alternatives: \n%@", alts);
        for (NSDictionary *alternative in alts) {
            [articleAlternatives addObject:[alternative objectForKey:@"fulltext"]];
        }
        
        self.alternatives = articleAlternatives;
        
        [alternativesResponse release];
        
        [self.tableView reloadData];        
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];
    
    
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    [allViewControllers removeObjectAtIndex:1];
    self.navigationController.viewControllers = allViewControllers;
    
    //self.searchResultsDelegate.ssmDelegate = self;
    
    NSString *articleName = [barcodeInfo objectForKey:@"Artikel"];
    
    self.itemNameLabel.text = articleName;
    self.navigationItem.title = articleName;
    
    
    //http://xn--ssongsmat-v2a.nu/w/api.php?action=ssmksasong&rvlista=Gr%C3%B6nk%C3%A5l&format=json
    // {"ssm":{"Gr\u00f6nk\u00e5l":{"exists":true,"isasong":true}}}
    NSArray *seasonKeys    = [NSArray arrayWithObjects:
                              @"action",
                              @"format",
                              @"rvlista",
                              nil];
    
    NSArray *seasonObjects = [NSArray arrayWithObjects:
                              @"ssmksasong",
                              @"json",
                              articleName,
                              nil];
    
    NSDictionary *seasonDict = [NSDictionary dictionaryWithObjects:seasonObjects forKeys:seasonKeys];
                              

    SSMApiClient *client = [SSMApiClient sharedClient];
    [client getPath:@"w/api.php" parameters:seasonDict success:^(id object) {
        NSDictionary *seasonResponse = [(NSDictionary *)object retain];
        //NSLog(@"%@", seasonResponse);
        
        NSString *keyPath = [NSString stringWithFormat:@"ssm.%@.isasong", articleName];
        BOOL inSeason = [[seasonResponse valueForKeyPath:keyPath] boolValue];

        if (inSeason) {
            self.seasonInfoLabel.text = [NSString stringWithFormat:@"%@ är i säsong nu!", articleName];
            [self loadRecipesForArticle:articleName];
        }
        else {
            self.seasonInfoLabel.text = [NSString stringWithFormat:@"%@ är inte i säsong just nu.", articleName];
            [self loadRecipesForArticle:articleName];
        }
        
        [self loadAlternativesForArticle:articleName];
        
        [self.seasonActivityIndicator stopAnimating];
        self.seasonInfoLabel.hidden = NO;
        
        
        [seasonResponse release];
        
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"Error: %@", [error localizedDescription]);
        
    }];

    
    
    // ns: 550 = recept
    //http://xn--ssongsmat-v2a.nu/w/api.php?action=parse&format=json&page=Gr%C3%B6nk%C3%A5l&prop=images|links
    
    
}



- (void)viewDidUnload
{
    [self setItemNameLabel:nil];
    [self setItemInfoCell:nil];
    [self setSeasonInfoLabel:nil];
    [self setSeasonActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return KNOWN_NUM_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case ItemInfoSection:
            return NUM_INFO_ROWS;
            break;
        case KnownItemBarcodeInfoSection:
            return [barcodeInfo count];
            break;
        case RecipeSection:
            return [recipes count];
            break;
        case AlternativesSection:
            return [alternatives count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case ItemInfoSection:
            return [self tableView:tableView cellForItemDescriptionAtRow:indexPath.row];
        case KnownItemBarcodeInfoSection:
            return [self tableView:tableView cellForBarcodeInfoAtRow:indexPath.row];
        case RecipeSection:
            return [self tableView:tableView cellForRecipeAtRow:indexPath.row];
        case AlternativesSection:
            return [self tableView:tableView cellForAlternativeAtRow:indexPath.row];
        default: 
            return nil;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case KnownItemBarcodeInfoSection:
            return @"Information från streckkoden";
        case RecipeSection:
            if ([self.recipes count] > 0) {
                return @"Recept";
            }
            else {
                return nil;
            }
        case AlternativesSection:
            if ([self.alternatives count] > 0) {
                return @"Alternativa råvaror";
            }
            else {
                return nil;
            }
        default:
            return nil;
    }
}



#pragma mark - Cell creation methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForItemDescriptionAtRow:(int)row {
    UITableViewCell *cell;
    
    switch (row) {
        case ItemInfo:
            cell = [tableView dequeueReusableCellWithIdentifier:@"ItemInfo"];
            if (cell == nil) {
                cell = self.itemInfoCell;
            }
            break;
        default:
            return nil;
            break;
    }
    
    return cell;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForBarcodeInfoAtRow:(int)row {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BarcodeInfoRow"];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:@"BarcodeInfoRow"] autorelease];
    }
    
    NSString *key = [[barcodeInfo allKeys] objectAtIndex:row];
    cell.textLabel.text = key;
    cell.detailTextLabel.text = [barcodeInfo objectForKey:key];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRecipeAtRow:(int)row {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RecipeCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RecipeCell"] autorelease];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [recipes objectAtIndex:row];
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForAlternativeAtRow:(int)row {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlternativeCell"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlternativeCell"] autorelease];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [alternatives objectAtIndex:row];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ItemInfoSection && indexPath.row == ItemInfo) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loader-bg.png"]];
    }
}

#pragma mark -

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == ItemInfoSection && indexPath.row == ItemInfo) {
        return 62;
    }
    else {
        return 44;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != RecipeSection && indexPath.section != AlternativesSection) {
        return nil;
    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == RecipeSection) {
        NSString * recipe = [recipes objectAtIndex:indexPath.row];
    
        RecipeViewController *controller = [[RecipeViewController alloc] initWithNibName:@"RecipeViewController" bundle:nil];
    
        controller.recipeName = recipe;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if (indexPath.section == AlternativesSection) {
        NSString * alternativeName = [alternatives objectAtIndex:indexPath.row];
        
        ItemArticleViewController *controller = [[ItemArticleViewController alloc] initWithNibName:@"ItemArticleView" bundle:nil];
        controller.itemName = alternativeName;
        
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];

    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    NSString *artikel = [self.barcodeInfo valueForKey:@"Artikel"];

    ItemArticleViewController *controller = [[ItemArticleViewController alloc] initWithNibName:@"ItemArticleView" bundle:nil];
    controller.itemName = artikel;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}

- (void)dealloc {
    [itemNameLabel release];
    [itemInfoCell release];
    [seasonInfoLabel release];
    [seasonActivityIndicator release];
    [super dealloc];
}
@end
