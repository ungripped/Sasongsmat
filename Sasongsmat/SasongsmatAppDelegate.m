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
