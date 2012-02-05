//
//  LoaderView.h
//  Sasongsmat
//
//  Created by Matti on 2011-10-13.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoaderView : UIView {
    UILabel *loadingLabel;
    UILabel *errorLabel;
    
    UIActivityIndicatorView *indicator;
}

- (void)fadeOut;
- (void)showError:(NSString *)errorMessage;


@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UILabel *errorLabel;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;

@end
