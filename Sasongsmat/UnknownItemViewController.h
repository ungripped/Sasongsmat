//
//  UnknownItemViewController.h
//  Sasongsmat
//
//  Created by Matti on 2011-09-11.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <UIKit/UIKit.h>

enum Sections {
    UnknownItemSection,
    BarcodeInfoSection,
    NUM_SECTIONS
};

enum UnknownItemSection {
    ItemDescription,
    NUM_ROWS
};

@class SearchResultsDelegate; 

@interface UnknownItemViewController : UITableViewController {
    UITableViewCell *descriptionCell;
    
    NSDictionary *barcodeInfo;
    SearchResultsDelegate *searchResultsDelegate;
}

@property (nonatomic, retain) NSDictionary *barcodeInfo;
@property (nonatomic, retain) IBOutlet SearchResultsDelegate *searchResultsDelegate;
@property (nonatomic, retain) IBOutlet UITableViewCell *descriptionCell;
@end
