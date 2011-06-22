//
//  SSMNavigationBar.m
//  NavbarTest
//
//  Created by Matti Ryhänen on 11-06-22.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SSMNavigationBar.h"


@implementation SSMNavigationBar

+ (UILabel *)titleLabelWithText:(NSString *)title {
    
    CGSize size = [title sizeWithFont:[UIFont boldSystemFontOfSize:20.0]];
    CGRect frame = CGRectMake(0, 0, size.width, 44);
    
    UILabel *label = [[[UILabel alloc] initWithFrame:frame] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.8];
    label.shadowOffset = CGSizeMake(0, 1.0);
    
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.145 green:0.173 blue:0.129 alpha:1.0];

    label.text = title;
    
    return label;
}

- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed: @"summer-header.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end
