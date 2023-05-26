//
//  MoveMap.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 23/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "MoveMap.h"


@implementation MoveMap

- (id) initMoveMap {
	if (![super init]) {
	    return nil;
	}
	
	m_MoveTab = nil;
	m_CurrentMove = 0;
	m_isRandom = NO;
	
	return self;
}

- (void) dealloc {
	if (m_MoveTab != nil) {
	    [m_MoveTab release];
	}
	[super dealloc];
}

- (void) loadMoveFile : (NSString*) file {
    NSBundle *bundle;
	NSString *path;
	
	if (file != nil) {
		if ([file isEqualToString:@"Random"]) {
			m_isRandom = YES;
		} else {
	        bundle = [NSBundle mainBundle];
	        path = [bundle pathForResource:file ofType:@"plist"];
			m_MoveTab = [[NSArray alloc] initWithContentsOfFile:path];
			m_isRandom = NO;
		}
	}
}

- (NSUInteger) nextMove {
	NSNumber* currentMoveNumber;
	NSUInteger mv = m_CurrentMove;
	
	if (m_MoveTab == nil)  {
		
		if (m_isRandom) {
		    return random() % (MAX_MOVE_COUNT - 2);
		}
		
		return NO_MOVE;
	}
	
	++m_CurrentMove;
	m_CurrentMove %=  [m_MoveTab count];
	
	currentMoveNumber = [m_MoveTab objectAtIndex:mv];
	
	return [currentMoveNumber unsignedIntValue];
}


@end
