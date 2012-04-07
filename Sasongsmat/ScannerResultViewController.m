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
//#import "SSMApi.h"
#import "UnknownItemViewController.h"
#import "KnownItemViewController.h"
#import "SSMApiClient.h"

@implementation ScannerResultViewController

@synthesize loaderView;
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
    self.loaderView = [[LoaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    self.loaderView.alpha = 1.0;

    
    self.loaderView.loadingLabel.text = @"Laddar streckkod...";
    [self.view addSubview:self.loaderView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"Read: %@:%@", self.typeName, self.barcodeData);
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"Kod: %@", self.barcodeData);
    
    NSDictionary *dict = [NSDictionary                        dictionaryWithObjects:[NSArray arrayWithObjects:
                                                 @"ssmstreckkod", 
                                                 @"json", 
                                                 self.barcodeData, 
                                                 nil]
                          
                          forKeys:[NSArray arrayWithObjects:
                                   @"action", 
                                   @"format", 
                                   @"kod",
                                   nil]];
    
    SSMApiClient *client = [SSMApiClient sharedClient];
    [client getPath:@"w/api.php" parameters:dict success:^(id object) {
        NSDictionary *barcodeResponse = [(NSDictionary *)object retain];
        NSLog(@"%@", barcodeResponse);
        
        NSMutableDictionary *codeInfo = [NSMutableDictionary dictionaryWithDictionary:[barcodeResponse objectForKey:@"streckkod"]];
        [codeInfo setObject:barcodeData forKey:@"streckkod"];
        
        UIViewController *controller;
        
        if ([codeInfo objectForKey:@"message"] != nil) {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Fel"
                                                              message:[codeInfo objectForKey:@"message"]
                                                             delegate:self
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            
            [message show];
        }
        else if ([codeInfo objectForKey:@"Artikel"] == nil) {
            controller = [[UnknownItemViewController alloc] initWithNibName:@"UnknownItemViewController" bundle:nil];
        }
        else {
            controller = [[KnownItemViewController alloc] initWithNibName:@"KnownItemViewController" bundle:nil];
        }
        
        [controller performSelector:@selector(setBarcodeInfo:) withObject:codeInfo];
        [self.navigationController pushViewController:controller animated:YES];

        [controller release];
        [barcodeResponse release];
        
    } failure:^(NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error: %@", error);
        NSLog(@"Error: %@", [error localizedDescription]);
       
        [self.loaderView showError:[error localizedDescription]];

    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [self setLoaderView:nil];
    [self setBarcodeData:nil];
    [self setTypeName:nil];
    
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
    [super dealloc];
}
@end
