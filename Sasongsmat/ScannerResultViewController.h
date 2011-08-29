//
//  ScannerResultViewController.h
//  Sasongsmat
//
//  Created by Matti on 2011-08-29.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScannerResultViewController : UIViewController {
    UIView *loaderView;
    UIActivityIndicatorView *indicatorView;
    
    NSString *barcodeData;
    NSString *typeName;
    
}

@property (nonatomic, retain) IBOutlet UIView *loaderView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, retain) NSString *barcodeData;
@property (nonatomic, retain) NSString *typeName;

@end
