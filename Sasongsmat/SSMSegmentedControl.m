//
//  MCSegmentedControl.m
//
//  Created by Matteo Caldari on 21/05/2010.
//  Copyright 2010 Matteo Caldari. All rights reserved.
//
//  Modified by Matti Ryhänen on 2011-06-28

#import "SSMSegmentedControl.h"

#define kCornerRadius  10.0f

@interface SSMSegmentedControl (Private)
@property (nonatomic, retain, readwrite) NSMutableArray *items;
- (BOOL)mustCustomize;
@end


@implementation SSMSegmentedControl

@synthesize selectedItemImage, unselectedItemImage, separatorImage, indicatorImage;
@synthesize indicatorLayer;

#pragma mark -
#pragma mark Object life cycle

- (void)awakeFromNib {
	NSMutableArray *ar = [NSMutableArray arrayWithCapacity:self.numberOfSegments];

	for (int i = 0; i < self.numberOfSegments; i++) {
		NSString *aTitle = [self titleForSegmentAtIndex:i];
		if (aTitle) {
			[ar addObject:aTitle];
		} else {
			UIImage *anImage = [self imageForSegmentAtIndex:i];
			if (anImage) {
				[ar addObject:anImage];
			}
		}
	}
	
	self.items = ar;
	[self setNeedsDisplay];
}

- (id)initWithItems:(NSArray *)array {
    self = [super initWithItems:array];
	if (self) {
		NSMutableArray *mutableArray = [array mutableCopy];
		self.items = mutableArray;
		[mutableArray release];
	}
	
	return self;
}



- (void)dealloc {
    self.selectedItemImage   = nil;
    self.unselectedItemImage = nil;
    self.separatorImage      = nil;
    self.indicatorImage      = nil;
    self.indicatorLayer      = nil;
	self.items               = nil;
	self.font                = nil;
	self.selectedItemColor   = nil;
	self.unselectedItemColor = nil;
	
    [super dealloc];
}

- (BOOL)mustCustomize {
	return self.segmentedControlStyle == UISegmentedControlStyleBordered
		|| self.segmentedControlStyle == UISegmentedControlStylePlain;
}

#pragma mark -
#pragma mark Custom accessors

- (UIFont *)font {
	if (font == nil) {
		self.font = [UIFont boldSystemFontOfSize:18.0f];
	}
	return font;
}

- (void)setFont:(UIFont *)aFont {
	if (font != aFont) {
		[font release];
		font = [aFont retain];
		
		[self setNeedsDisplay];
	}
}

- (UIColor *)selectedItemColor {
	if (selectedItemColor == nil) {
		self.selectedItemColor = [UIColor whiteColor];
	}
	return selectedItemColor;
}

- (void)setSelectedItemColor:(UIColor *)aColor {
	if (aColor != selectedItemColor) {
		[selectedItemColor release];
		selectedItemColor = [aColor retain];
		
		[self setNeedsDisplay];
	}
}

- (UIColor *)unselectedItemColor {
	if (unselectedItemColor == nil) {
		self.unselectedItemColor = [UIColor grayColor];
	}
	return unselectedItemColor;
}

- (void)setUnselectedItemColor:(UIColor *)aColor {
	if (aColor != unselectedItemColor) {
		[unselectedItemColor release];
		unselectedItemColor = [aColor retain];
		
		[self setNeedsDisplay];
	}
}

- (void)setIndicatorImage:(UIImage *)anImage {
    if (anImage != indicatorImage) {
        [indicatorImage release];
        indicatorImage = [anImage retain];
        
        
        int x = round(self.bounds.size.width / self.numberOfSegments) / 2 - indicatorImage.size.width / 2;
        
        self.indicatorLayer = [CALayer layer];
        
        // TODO: Change magic 43.
        self.indicatorLayer.frame = CGRectMake(x, 43, indicatorImage.size.width, indicatorImage.size.height);
        self.indicatorLayer.contents = (id)indicatorImage.CGImage;

        [self.layer addSublayer:self.indicatorLayer];
    }
    
   

}
- (NSMutableArray *)items {
	return items;
}

- (void)setItems:(NSMutableArray *)array {
	if (items != array) {
		[items release];
		items = [array retain];
	}
}

#pragma mark -
#pragma mark Overridden UISegmentedControl methods

- (NSUInteger)numberOfSegments {
	if (!self.items || ![self mustCustomize]) {
		return [super numberOfSegments];
	} else {
		return self.items.count;
	}
}

- (void)drawRect:(CGRect)rect {
    
	// Only the bordered and plain style are customized
	if (![self mustCustomize]) {
		[super drawRect:rect];
		return;
	}

	
	for (UIView *subView in self.subviews) {
		[subView removeFromSuperview];
	}
	
	// TODO: support for segment custom width
	//CGSize itemSize = CGSizeMake(round(rect.size.width / self.numberOfSegments), rect.size.height);
	
    CGSize itemSize = CGSizeMake(round(rect.size.width / self.numberOfSegments), self.selectedItemImage.size.height);
    
	CGContextRef c = UIGraphicsGetCurrentContext();
    
	CGContextSaveGState(c);
    
    for (int i = 0; i < self.numberOfSegments; i++) {
        
        //BOOL isLeftItem = i == 0;
        BOOL isRightItem = i == self.numberOfSegments - 1;
        
        CGRect imgRect = CGRectMake(i * itemSize.width, 0.0f, itemSize.width, itemSize.height);
        
        CGContextSaveGState(c);
        CGContextTranslateCTM(c, 0, rect.size.height); 
        CGContextScaleCTM(c, 1.0, -1.0);  
        
        
        
        if (i == self.selectedSegmentIndex) {
            CGImageRef image = self.selectedItemImage.CGImage;
            CGContextDrawImage(c, imgRect, image);
        }
        else {
            CGImageRef image = self.unselectedItemImage.CGImage;
            CGContextDrawImage(c, imgRect, image);
        }
        
        if (!isRightItem) {
            CGImageRef separator = self.separatorImage.CGImage;
            CGRect separatorRect = CGRectMake(((i+1) * itemSize.width) - self.separatorImage.size.width, 0.0f, self.separatorImage.size.width, self.separatorImage.size.height);
            
            CGContextDrawImage(c, separatorRect, separator);
        }
        
        CGContextRestoreGState(c);
                
        NSString *string = (NSString *)[items objectAtIndex:i];
        CGSize stringSize = [string sizeWithFont:self.font];
        CGRect stringRect = CGRectMake(i * itemSize.width + (itemSize.width - stringSize.width) / 2, 
                                       (itemSize.height + stringSize.height) / 2,// + kTopPadding, 
                                       stringSize.width,
                                       stringSize.height);
        
        [[UIColor colorWithWhite:0.0f alpha:.2f] setFill];
        
        if (self.selectedSegmentIndex == i) {
            [string drawInRect:CGRectOffset(stringRect, 0.0f, 1.0f) withFont:self.font];
            [self.selectedItemColor setFill];	
            [self.selectedItemColor setStroke];	

        }
        else {
            [string drawInRect:CGRectOffset(stringRect, 0.0f, -1.0f) withFont:self.font];
            [self.unselectedItemColor setFill];
        }
        [string drawInRect:stringRect withFont:self.font];
        
        /*
        if (self.selectedSegmentIndex == i) {
            [[UIColor colorWithWhite:0.0f alpha:.2f] setFill];
            [string drawInRect:CGRectOffset(stringRect, 0.0f, 1.0f) withFont:self.font];
            [self.selectedItemColor setFill];	
            [self.selectedItemColor setStroke];	
            [string drawInRect:stringRect withFont:self.font];
        } else {
            [[UIColor whiteColor] setFill];			
            [string drawInRect:CGRectOffset(stringRect, 0.0f, -1.0f) withFont:self.font];
            [self.unselectedItemColor setFill];
            [string drawInRect:stringRect withFont:self.font];
        }
         */
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if (![self mustCustomize]) {
		[super touchesBegan:touches withEvent:event];
	} else {
		CGPoint point = [[touches anyObject] locationInView:self];
		int itemIndex = floor(self.numberOfSegments * point.x / self.bounds.size.width);
		self.selectedSegmentIndex = itemIndex;
        
        int x = selectedItemImage.size.width * itemIndex + selectedItemImage.size.width / 2;
        
		
        [UIView beginAnimations:@"indicator" context:nil];
        indicatorLayer.frame = CGRectMake(x, 43, indicatorImage.size.width, indicatorImage.size.height);
        [UIView commitAnimations];
        
		[self setNeedsDisplay];
	}
}

- (void)setSegmentedControlStyle:(UISegmentedControlStyle)aStyle {
	[super setSegmentedControlStyle:aStyle];
	if ([self mustCustomize]) {
		[self setNeedsDisplay];
	}
}

- (void)setTitle:(NSString *)title forSegmentAtIndex:(NSUInteger)segment {
	
	if (![self mustCustomize]) {
		[super setTitle:title forSegmentAtIndex:segment];
	} else {
		[self.items replaceObjectAtIndex:segment withObject:title];
		[self setNeedsDisplay];
	}
}

- (void)setImage:(UIImage *)image forSegmentAtIndex:(NSUInteger)segment {
	if (![self mustCustomize]) {
		[super setImage:image forSegmentAtIndex:segment];
	} else {
		[self.items replaceObjectAtIndex:segment withObject:image];
		[self setNeedsDisplay];
	}
}

- (void)insertSegmentWithTitle:(NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated {
	if (![self mustCustomize]) {
		[super insertSegmentWithTitle:title atIndex:segment animated:animated];
	} else {
		if (segment >= self.numberOfSegments) return;
		[super insertSegmentWithTitle:title atIndex:segment animated:animated];
		[self.items insertObject:title atIndex:segment];
		[self setNeedsDisplay];
	}
}

- (void)insertSegmentWithImage:(UIImage *)image atIndex:(NSUInteger)segment animated:(BOOL)animated {
	if (![self mustCustomize]) {
		[super insertSegmentWithImage:image atIndex:segment animated:animated];
	} else {
		if (segment >= self.numberOfSegments) return;
		[super insertSegmentWithImage:image atIndex:segment animated:animated];
		[self.items insertObject:image atIndex:segment];
		[self setNeedsDisplay];
	}
}

- (void)removeSegmentAtIndex:(NSUInteger)segment animated:(BOOL)animated {
	if (![self mustCustomize]) {
		[super removeSegmentAtIndex:segment animated:animated];
	} else {
		if (segment >= self.numberOfSegments) return;
		[self.items removeObjectAtIndex:segment];
		[self setNeedsDisplay];
	}
}


@end
