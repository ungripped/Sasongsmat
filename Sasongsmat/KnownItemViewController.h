//
//  KnownItemViewController.h
//  Sasongsmat
//
//  Created by Matti on 2012-02-05.
//  Copyright (c) 2012 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <UIKit/UIKit.h>

enum KnownItemSections {
    ItemInfoSection,
    RecipeSection,
    AlternativesSection,
    KnownItemBarcodeInfoSection,
    KNOWN_NUM_SECTIONS
};

enum ItemInfoSection {
    ItemInfo,
    NUM_INFO_ROWS
};


@interface KnownItemViewController : UITableViewController {
    NSDictionary *barcodeInfo;
}


@property (nonatomic, retain) NSDictionary *barcodeInfo;
@property (retain, nonatomic) IBOutlet UILabel *itemNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *seasonInfoLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *seasonActivityIndicator;
@property (retain, nonatomic) IBOutlet UITableViewCell *itemInfoCell;

@end
