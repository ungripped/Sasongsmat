//
//  BarcodeItemViewController.h
//  Sasongsmat
//
//  Created by Matti on 2011-09-12.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarcodeItemViewController : UIViewController {
    UIActivityIndicatorView *itemLoadIndicator;
    UIActivityIndicatorView *imageLoadIndicator;
    
    NSDictionary *barcodeInfo;
    UILabel *itemNameLabel;
    UIImageView *itemImage;
}

@property (nonatomic, retain) IBOutlet UILabel *itemNameLabel;
@property (nonatomic, retain) IBOutlet UIImageView *itemImage;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *itemLoadIndicator;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *imageLoadIndicator;

@property (nonatomic, retain) NSDictionary *barcodeInfo;

@end
