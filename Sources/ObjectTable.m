//
//  ObjectTable.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 26/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "ObjectTable.h"
#import "GameObject.h"
#import "Enemy.h"
#import "ScreenInfo.h"

#define OFFSET_SCREEN 100

@implementation ObjectTable

- (id) initObjectTable : (NSInteger) capacity {
	
	if (![super init]) {
		return nil; 
	}
	
    m_ObjectTable = [[NSMutableArray alloc] initWithCapacity: capacity];
	
	return self;
}

- (void) dealloc {
    
    [m_ObjectTable removeAllObjects];
	[m_ObjectTable release];
	[super dealloc];

}

- (void) add: (GameObject*) object {
	[m_ObjectTable addObject:object];
}

- (void) remove: (NSUInteger) index {
	[m_ObjectTable removeObjectAtIndex:index];
}

- (bool) detectCollision : (GameObject*) object : (PlayerScore*) score {
	
	bool result = NO;
	
	unsigned int count = [self getSize];
    for (unsigned int i = 0; i < count; ++i) {
        result = result || [[self get:i] detectCollision:object:score];
    }
	
    return result;
}

- (void) move : (NSInteger) x : (NSInteger) y {
	
	GameObject* currentObject = nil;
	
	for (unsigned int i = 0; i < [self getSize];) {
    
		currentObject = (GameObject*)[m_ObjectTable objectAtIndex:i];
	    [currentObject move:x:y];
		
		//NSLog(@"check object : w:%d h:%d o:%d, xm:%d - xM:%d - ym:%d - yM:%d - E:%d ", [[ScreenInfo screenInfo] getWidth], [[ScreenInfo screenInfo] getHeight], OFFSET_SCREEN, [currentObject getXMin], [currentObject getXMax], [currentObject getYMin], [currentObject getYMax], [currentObject getEnergy]);	
        if (([currentObject getXMax] < -OFFSET_SCREEN) || ([currentObject getXMin] > ([[ScreenInfo screenInfo] getWidth] + OFFSET_SCREEN)) ||
            ([currentObject getYMax] < -OFFSET_SCREEN) || ([currentObject getYMin] > ([[ScreenInfo screenInfo] getHeight] + OFFSET_SCREEN)) ||
            ([currentObject getEnergy] <= 0)) {
			
            if ([currentObject isKindOfClass:[MovingObject class]]) {
				if ([currentObject getEnergy] <= 0) {
					if ([(MovingObject*) currentObject isExplode]) {
						// NSLog(@"1 Remove object.");
						// TODO: free object memory
						[self remove:i];
					} else {
						++i;
					}
				} else {
					// NSLog(@"2 Remove object.");
					[self remove:i];
				}  
            } else {
                // TODO: free object memory currentObject
			//	NSLog(@"3 Remove object.");
			   [self remove:i];
            }
		} else {
			++i;
		}     
    }
}

- (void) draw {
	unsigned int count = [self getSize];
    for (unsigned int i = 0; i < count; ++i) {
	    [(GameObject*)[m_ObjectTable objectAtIndex:i] draw];
	}
}

- (NSUInteger) getSize {
    return [m_ObjectTable count];
}

- (GameObject*) get : (NSUInteger) index {
    return (GameObject*)[m_ObjectTable objectAtIndex:index];
}

- (void) clear {
    [m_ObjectTable removeAllObjects];
}

@end
