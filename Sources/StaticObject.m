//
//  StaticObject.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "StaticObject.h"
#import "SoundManager.h"

@implementation StaticObject

- (id) initStaticObject : (ObjectInfo*) info {
	
	if (![super initObject : info]) {
		return nil; 
	}
        
	[self setSprite:[info getResourcesUp]:[info getTimeCountPerFrame]:[info getLoopFrameStart]:[info isReservedResource]];
	
	if (m_StaticSprite != nil) {
	
   	    [self setWidth:[m_StaticSprite getWidth]];
	    [self setHeight:[m_StaticSprite getHeight]];
	}
	
	m_Sound = [[SoundManager soundManager] getSound:[info getSound]:SOUND_EXTENSION:[info isReservedResource]];
	
	return self;
}

- (void) dealloc {
	
	if (m_StaticSprite != nil) {
	    [m_StaticSprite release];
	}
	
	[super dealloc]; 
}

- (void) setSprite : (NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved {
    m_StaticSprite = [[GameSprite alloc] initSprite:array:timeCountPerFrame:loopFrameStart:isReserved];
}

- (bool) checkCollisionMask: (GameObject*) obj {
    return YES;
}

- (void) draw  {	
	if (nil == m_StaticSprite) {
		return;
	}
	
	[m_StaticSprite draw:m_XMin:m_YMin];

	[m_StaticSprite next:YES];
}


@end
