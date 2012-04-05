//
//  SasongsmatAppDelegate.m
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-07-18.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "SasongsmatAppDelegate.h"
#import "ScannerResultViewController.h"

@implementation SasongsmatAppDelegate


@synthesize window=_window;

@synthesize tabBarController=_tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setAppearances];
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    [ZBarReaderViewController class];

    
    UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:1];
    
    ZBarReaderViewController *reader = (ZBarReaderViewController *)[navController topViewController];
    reader.readerDelegate = self;
    reader.showsZBarControls = NO;
    reader.showsCameraControls = NO;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.readerView.frame = CGRectMake(0, 0, reader.view.frame.size.width, reader.view.frame.size.height);
    //reader.readerView.frame = reader.view.frame;
    
    
    
    return YES;
}

- (void)setAppearances
{
    /** Nav bars **/
    UIImage *barBg = [UIImage imageNamed:@"navbar.png"];
    [[UINavigationBar appearance] setBackgroundImage:barBg forBarMetrics:UIBarMetricsDefault];
        
    UIColor *navTextColor = [UIColor colorWithRed:73.0/255.0 green:73.0/255.0 blue:73.0/255.0 alpha:1.0];
    NSDictionary *navTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                       navTextColor,
                                       UITextAttributeTextColor, 
                                       [UIColor whiteColor], 
                                       UITextAttributeTextShadowColor, 
                                       [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], 
                                       UITextAttributeTextShadowOffset, 
                                       nil];
    
    NSDictionary *navTextHighlightAttributres = [NSDictionary dictionaryWithObjectsAndKeys:
                                                 [UIColor blackColor],
                                                 UITextAttributeTextColor, 
                                                 [UIColor whiteColor], 
                                                 UITextAttributeTextShadowColor, 
                                                 [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], 
                                                 UITextAttributeTextShadowOffset, 
                                                 nil];
        
    [[UINavigationBar appearance] setTitleTextAttributes:navTextAttributes];
    
    /** Search bar **/
    [[UISearchBar appearance] setBackgroundImage:barBg];
    
    /** Bar button items **/
    UIImage *backButtonImage = [[UIImage imageNamed:@"back-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 3)];
    UIImage *backButtonPressedImage = [[UIImage imageNamed:@"back-button-pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 3)];
    
    UIImage *barButtonImage = [[UIImage imageNamed:@"bar-button.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 3, 0, 3)];
    UIImage *barButtonPressedImage = [[UIImage imageNamed:@"bar-button-pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 3, 0, 3)];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:barButtonPressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:navTextAttributes forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:navTextHighlightAttributres forState:UIControlStateHighlighted];

    
    /** Segmented controls **/
    UIImage *normalImage = [[UIImage imageNamed:@"seg-normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *pressedImage = [[UIImage imageNamed:@"seg-pressed.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIImage *selectedImage = [[UIImage imageNamed:@"seg-selected.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [[UISegmentedControl appearance] setBackgroundImage:normalImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:pressedImage forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:selectedImage forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [[UISegmentedControl appearance] setDividerImage:[UIImage imageNamed:@"seg-separator.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

/*
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController == [tabBarController.viewControllers objectAtIndex:1]) {
        [self openBarcodeController];
        return NO;
    }
    return YES;
}

 */
- (void)openBarcodeController {
    /*
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    
    //[reader.scanner setSymbology: ZBAR_QRCODE
    //                      config: ZBAR_CFG_ENABLE
    //                          to: 0];
    reader.readerView.zoom = 1.0;
    
    [self.tabBarController presentModalViewController:reader animated:YES];
     */
}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    //UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    //[reader dismissModalViewControllerAnimated:YES];
    
    UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:1];
    
    ScannerResultViewController *vc = [[ScannerResultViewController alloc] initWithNibName:@"ScannerResultViewController" bundle:nil];
    
    vc.barcodeData = symbol.data;
    vc.typeName = symbol.typeName;
    
    [navController pushViewController:vc animated:YES];
}
/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
