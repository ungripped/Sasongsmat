//
//  FoodItemsOverviewController.m
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-07-18.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "FoodItemsOverviewController.h"
#import "ItemArticleViewController.h"

@implementation FoodItemsOverviewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    viewTitle = @"Råvaror";
    listType = @"articles";
    [super viewDidLoad];
}

- (void)loadArticle:(NSString *)article {
    
    ItemArticleViewController *controller = [[ItemArticleViewController alloc] initWithNibName:@"ItemArticleView" bundle:nil];
    controller.itemName = article;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    [controller release];
}


@end
