//
//  SeasonIndicatorView.m
//  Sasongsmat
//
//  Created by Matti on 2011-09-02.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "SeasonIndicatorView.h"

@implementation SeasonIndicatorView
@synthesize seasonInfoItem;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.85;
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSArray *colors = [NSArray arrayWithObjects:
                       [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1] /*#f2f2f2*/,
                       [UIColor colorWithRed:0.549 green:0.776 blue:0.224 alpha:0.33] /*#d2fabe*/,
                       [UIColor colorWithRed:0.549 green:0.776 blue:0.224 alpha:0.67] /*#a9d56b*/, 
                       [UIColor colorWithRed:0.549 green:0.776 blue:0.224 alpha:1] /*#8cc639*/,
                       nil];

    NSString *letters[12] = {@"J", @"F", @"M", @"A", @"M", @"J", @"J", @"A", @"S", @"O", @"N", @"D"};
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:10.0f];
    
    
    CALayer *drawLayer = self.layer;
    drawLayer.contentsScale = [[UIScreen mainScreen] scale];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
    
    CGContextSetAllowsFontSmoothing(context, true);
    CGContextSetShouldSmoothFonts(context, true);
    
    CGContextSetAllowsFontSubpixelQuantization(context, true);
    CGContextSetShouldSubpixelQuantizeFonts(context, true);
    
    CGContextTranslateCTM(context, 0.0f, self.frame.size.height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    
    
    for (int i = 0; i < 12; i++) {
        int seasonMonthIndicator = [[seasonInfoItem.seasonData objectAtIndex:i] intValue];
        
        CGRect ovalRect = CGRectMake((18*i) + 3, 3, 15, 15);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddEllipseInRect(path, NULL, ovalRect);
        CGContextAddPath(context, path);
        
        CGContextSetFillColorWithColor(context, [[colors objectAtIndex:seasonMonthIndicator] CGColor]);
        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
        
        CGContextDrawPath(context, kCGPathFillStroke);
        
        CGPathRelease(path);
    
        
        CGSize fs = [letters[i] sizeWithFont:font];
        
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
        
        CGContextSelectFont(context, [[font fontName] cStringUsingEncoding:NSUTF8StringEncoding], [font pointSize], kCGEncodingMacRoman);
        CGContextSetTextDrawingMode(context, kCGTextFill);
        
        CGContextShowTextAtPoint(context, (18*i) + 3 + 7-floor(fs.width/2), 7, [letters[i] cStringUsingEncoding:NSUTF8StringEncoding], 1);
        
        
    }
    
    CGContextRestoreGState(context);
}

- (void)dealloc {
    [seasonInfoItem release];
    [super dealloc];
}

@end
