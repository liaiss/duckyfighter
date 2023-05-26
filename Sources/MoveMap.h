//
//  MoveMap.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 23/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

enum { 
	MOVE_DOWN = 0, 
	MOVE_UP = 1,
    MOVE_LEFT = 2,
    MOVE_RIGHT = 3,
	MOVE_UP_RIGHT = 4,
	MOVE_UP_LEFT = 5,
    MOVE_DOWN_RIGHT = 6, 
	MOVE_DOWN_LEFT = 7, 
    MOVE_UP_N_FIRE = 8,
    MOVE_DOWN_N_FIRE = 9, 
    MOVE_LEFT_N_FIRE = 10,
    MOVE_RIGHT_N_FIRE = 11,
	MOVE_UP_RIGHT_N_FIRE = 12,
	MOVE_UP_LEFT_N_FIRE = 13,
    MOVE_DOWN_RIGHT_N_FIRE = 14, 
	MOVE_DOWN_LEFT_N_FIRE = 15, 
	MOVE_FIRE = 16,
	NO_MOVE = 17,
	MAX_MOVE_COUNT = 18
};

@interface MoveMap : NSObject {
	
	NSArray* m_MoveTab; 
    NSUInteger m_CurrentMove;
	BOOL m_isRandom;
}

- (id) initMoveMap;

- (void) dealloc;

- (void) loadMoveFile : (NSString*) file;

- (NSUInteger) nextMove;

@end
