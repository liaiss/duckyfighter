//
//  ScreenInfo.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 28/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface ScreenInfo : NSObject {
    NSInteger m_Width;
	NSInteger m_Height;
}

- (id) initScreenInfo;

- (void) dealloc;

- (NSInteger) getWidth;

- (NSInteger) getHeight;

- (void) setWidth:(NSInteger) width ;
- (void) setHeight:(NSInteger) height;

+ (ScreenInfo*) screenInfo;


@end
