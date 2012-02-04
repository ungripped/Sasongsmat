//
//  RecipesOverviewController.m
//  Sasongsmat
//
//  Created by Matti on 2011-10-21.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "RecipesOverviewController.h"
#import "RecipeViewController.h"

@implementation RecipesOverviewController

- (void)viewDidLoad
{
    viewTitle = @"Recept";
    listType = @"recipes";
    
    [super viewDidLoad];
}


- (void)loadArticle:(NSString *)article {
    RecipeViewController *controller = [[RecipeViewController alloc] initWithNibName:@"RecipeViewController" bundle:nil];
    controller.recipeName = article;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}

@end
