//
//  TextManager.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 13/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "TextManager.h"
#import "Util.h"
#import "Texture2D.h"

@implementation TextManager

- (void) setFont:(NSString*) fontName {
	[fontName retain];
    m_Font = fontName;
}

- (void) setColor: (CGFloat) red: (CGFloat) green: (CGFloat) blue: (CGFloat) alpha {
    m_RedColorComponent = red;
    m_GreenColorComponent = green;
    m_BlueColorComponent = blue;
    m_AlphaColorComponent = alpha;
}

- (void) setStroke: (bool) strokeEnabled {
    m_StrokeEnabled = strokeEnabled;
}

- (void) dealloc {
    [m_Font release];
	[super dealloc];
}

- (void) drawText:(NSString*) text:(CGSize) dimension: (NSUInteger) size: (NSInteger) x: (NSInteger) y {
	Texture2D* textTexture = [[Texture2D alloc] initWithString:text dimensions:dimension alignment:UITextAlignmentCenter fontName:m_Font fontSize:(size*1.0)
                                                      redColor:m_RedColorComponent greenColor:m_GreenColorComponent blueColor:m_BlueColorComponent alphaColor:m_AlphaColorComponent stroke:m_StrokeEnabled];
	[textTexture drawAtPoint:x:y];
	[textTexture release];
}

+ (TextManager*) textManager {
    static TextManager *instance = nil;
	
    if (instance == nil) {
        instance = [[TextManager alloc] init];
        
        [instance setStroke:NO];
    }
	
    return instance;
}


@end
