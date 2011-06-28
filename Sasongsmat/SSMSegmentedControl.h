//
//  MCSegmentedControl.h
//
//  Created by Matteo Caldari on 21/05/2010.
//  Copyright 2010 Matteo Caldari. All rights reserved.
//

//  Modified by Matti Ryhänen on 2011-06-28


#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SSMSegmentedControl : UISegmentedControl {

	NSMutableArray *items;
	
	UIFont  *font;
	UIColor *selectedItemColor;
	UIColor *unselectedItemColor;
    
    UIImage *selectedItemImage;
    UIImage *unselectedItemImage;
    UIImage *separatorImage;
    UIImage *indicatorImage;
    
    CALayer *indicatorLayer;
    
}

/**
 * Font for the segments with title
 * Default is sysyem bold 18points
 */
@property (nonatomic, retain) UIFont  *font;

/**
 * Color of the item in the selected segment
 * Applied to text and images
 */
@property (nonatomic, retain) UIColor *selectedItemColor;

/**
 * Color of the items not in the selected segment
 * Applied to text and images
 */
@property (nonatomic, retain) UIColor *unselectedItemColor;

@property (nonatomic, retain) UIImage *selectedItemImage;
@property (nonatomic, retain) UIImage *unselectedItemImage;
@property (nonatomic, retain) UIImage *separatorImage;
@property (nonatomic, retain) UIImage *indicatorImage;

@property (nonatomic, retain) CALayer *indicatorLayer;
@end
