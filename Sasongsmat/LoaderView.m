//
//  LoaderView.m
//  Sasongsmat
//
//  Created by Matti on 2011-10-13.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "LoaderView.h"

@implementation LoaderView

@synthesize loadingLabel, errorLabel, indicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //UIColor *bgColor = [UIColor colorWithRed:0.953 green:0.953 blue:0.953 alpha:1];
        UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"loader-bg.png"]];
        // Initialization code
        self.backgroundColor = bgColor;
        
        self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 139, 280, 21)];
        self.loadingLabel.textAlignment = UITextAlignmentCenter;
        self.loadingLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1]; /* #333 */
        self.loadingLabel.shadowColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
        self.loadingLabel.shadowOffset = CGSizeMake(0, 1);
        
        self.loadingLabel.text = @"Laddar sägongsmat...";
        
        self.loadingLabel.backgroundColor = [UIColor clearColor];
        
        self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 176, 280, 21)];
        self.errorLabel.hidden = YES;
        
        self.indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        self.indicator.frame = CGRectMake(142, 168, 37, 37);
        
        [self addSubview:loadingLabel];
        [self addSubview:errorLabel];
        [self addSubview:indicator];
        
        [self.indicator startAnimating];
    }
    return self;
}

- (void)dealloc {
    [loadingLabel release];
    [errorLabel release];
    [indicator release];
    [super dealloc];
}


-(void)fadeOut {
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.alpha = 0.0;
    [UIView commitAnimations];
}

- (void)showError:(NSString *)errorMessage {
    self.errorLabel.text = errorMessage;
    self.errorLabel.hidden = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
