//
//  SasongsmatAppDelegate.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-05-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface SasongsmatAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate, ZBarReaderDelegate> {

}

- (void)openBarcodeController;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end
