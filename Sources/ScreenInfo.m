//
//  ScreenInfo.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 28/07/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "ScreenInfo.h"


@implementation ScreenInfo

- (id) initScreenInfo {
    if (![super init]) {
	    return nil;
	}
	
	m_Width = 0;
	m_Height = 0;
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (NSInteger) getWidth {
    return m_Width;
}

- (NSInteger) getHeight {
    return m_Height;
}

- (void) setWidth:(NSInteger) width {
    m_Width = width;
}

- (void) setHeight:(NSInteger) height {
    m_Height = height;
}

+ (ScreenInfo*) screenInfo {
    static ScreenInfo *instance = nil;
	
    if (instance == nil) {
        instance = [[ScreenInfo alloc] initScreenInfo];
    }
	
    return instance;
}


@end
