//
//  ScannerViewController.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-07-18.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ScannerViewController : UIViewController {
    ZBarReaderView *readerView;
}

@property (nonatomic, retain) ZBarReaderView *readerView;

@end
