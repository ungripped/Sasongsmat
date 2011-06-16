//
//  ScannerViewController.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-06-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ScannerViewController : UIViewController {
    ZBarReaderView *readerView;
}

@property (nonatomic, retain) ZBarReaderView *readerView;

@end
