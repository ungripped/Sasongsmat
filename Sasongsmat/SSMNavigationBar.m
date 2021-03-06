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
    UIColor *color = [UIColor colorWithRed:1 green:0.8 blue:0 alpha:1]; /*#ffcc00*/
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColor(context, CGColorGetComponents( [color CGColor]));
    CGContextFillRect(context, rect);
    self.tintColor = color;
    
    //UIColor *lineColor = [UIColor colorWithRed:0.6 green:0.2 blue:0 alpha:1]; /*#993300*/
    
    CGContextSetLineWidth(context, 2);
    CGContextSetRGBStrokeColor(context, 0.6f, 0.2f, 0.0f, 1.0f);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width, rect.size.height);
    CGContextStrokePath(context);
    
    /*
    UIImage *image = [UIImage imageNamed: @"summer-header.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
     */
}

@end
