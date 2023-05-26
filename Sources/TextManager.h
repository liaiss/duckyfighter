//
//  TextManager.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 13/09/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>


@interface TextManager : NSObject {
	NSString* m_Font;
    
    CGFloat m_RedColorComponent;
    CGFloat m_GreenColorComponent;
    CGFloat m_BlueColorComponent;
    CGFloat m_AlphaColorComponent;
    
    bool m_StrokeEnabled;
}

- (void) setFont:(NSString*) fontName;

- (void) setColor: (CGFloat) red: (CGFloat) green: (CGFloat) blue: (CGFloat) alpha;

- (void) setStroke: (bool) strokeEnabled;

- (void) drawText:(NSString*) text:(CGSize) dimension: (NSUInteger) size: (NSInteger) x: (NSInteger) y;

+ (TextManager*) textManager;

@end
