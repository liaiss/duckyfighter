//
//  Sprite.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 20/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "GameSprite.h"
#import "Layer.h"
#import "LayerManager.h"

@implementation GameSprite


- (id) initSprite:(NSArray*) array: (NSUInteger) timeCountPerFrame: (NSUInteger) loopFrameStart: (bool) isReserved {
	
	if (![super init]) {
	    return nil;
	}
	
	NSUInteger tabSize = [array count];
	
    m_PicTab = nil;
    
	if (tabSize != 0) {
        m_PicTab = [[NSMutableArray alloc] initWithCapacity:tabSize];
	} 
	
	if (m_PicTab != nil) {
	        
        // NSLog(@"Allocate sprite: %x.", self);
	
        [m_PicTab addObject:[[LayerManager layerManager] getLayer:[array objectAtIndex:0]:isReserved]];

	    for (NSInteger i = 1; i < tabSize; ++i) {
            [(NSMutableArray*)m_PicTab insertObject:[[LayerManager layerManager] getLayer:[array objectAtIndex:i]:isReserved] atIndex:i];
	    }
	
	    m_NbTimerMax = timeCountPerFrame;
	    m_CurrentFrame = 0;
	    m_NbTimerCnt = 0;
    	m_LoopFrameStart = loopFrameStart;
	}

	return self;
}

- (void) dealloc {
    if (m_PicTab != nil) {
	    [m_PicTab removeAllObjects];
	    [m_PicTab release]; 
    }
	[super dealloc];
	// NSLog(@"Release sprite: %x.", self);
}

- (NSUInteger) getFrame {
    return m_CurrentFrame;
}

- (NSUInteger) getFrameCount {
    return [m_PicTab count];
}

- (void) reset {
    m_CurrentFrame = 0;
    m_NbTimerCnt = 0;
}

- (bool) next: (bool) waitEnd {	
	bool retVal = NO; 
	bool condition = NO;
    
    if (m_PicTab != nil) {
        
        if (!waitEnd) {
            condition = (m_CurrentFrame == ([m_PicTab count] - 1));
        }
    
	    if ((condition) || (m_NbTimerCnt >= m_NbTimerMax)) {
		
		    if (m_CurrentFrame < ([m_PicTab count] - 1)) {
			    ++m_CurrentFrame;
		    } else {
			    m_CurrentFrame = m_LoopFrameStart;
			    retVal = YES;
		    }
		
		    m_NbTimerCnt = 0;
	    } else {
		    ++m_NbTimerCnt;
	    }  
	}
    
	return retVal;
}

- (void) draw : (NSInteger) x: (NSInteger) y {
    if (m_PicTab != nil) {
	    Layer* currentLayer = (Layer*) [m_PicTab objectAtIndex:m_CurrentFrame];
	    [currentLayer draw:x:y];
    }
}

- (NSUInteger) getWidth {
    if (m_PicTab != nil) {
        Layer* currentLayer = (Layer*) [m_PicTab objectAtIndex:m_CurrentFrame];
	    return [currentLayer getWidth];
    } else {
        return 0;
    }
}

- (NSUInteger) getHeight {
    if (m_PicTab != nil) {
	    Layer* currentLayer = (Layer*) [m_PicTab objectAtIndex:m_CurrentFrame];
	    return [currentLayer getHeight];
    } else {
        return 0;
    }
}

@end
