//
//  ScannerResultViewController.m
//  Sasongsmat
//
//  Created by Matti on 2011-08-29.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "ScannerResultViewController.h"
#import "SSMApi.h"
#import "UnknownItemViewController.h"

@implementation ScannerResultViewController
@synthesize loaderView;
@synthesize indicatorView;
@synthesize barcodeData, typeName;

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Read: %@:%@", self.typeName, self.barcodeData);
}

- (void)viewDidAppear:(BOOL)animated {
    SSMApi *api = [SSMApi sharedSSMApi];
    [self.indicatorView startAnimating];
    
    [api getBarcodeDataForBarcode:self.barcodeData withBlock:^(NSDictionary *result) {
        NSLog(@"Result: %@", result);
        [self.indicatorView stopAnimating];
        
        NSDictionary *codeInfo = [result objectForKey:@"streckkod"];
        
        if ([codeInfo objectForKey:@"Artikel"] == nil) {
            UnknownItemViewController *controller = [[UnknownItemViewController alloc] initWithNibName:@"UnknownItemViewController" bundle:nil];
            
            controller.barcodeInfo = codeInfo;
            
            [self.navigationController pushViewController:controller animated:YES];
                        
            [controller release];
        }
        
    } error:^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [self.indicatorView stopAnimating];
    }];

    
}

- (void)viewDidUnload
{
    [self setLoaderView:nil];
    [self setBarcodeData:nil];
    [self setTypeName:nil];
    
    [self setIndicatorView:nil];
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
    [loaderView release];
    [typeName release];
    [barcodeData release];
    [indicatorView release];
    [super dealloc];
}
@end
