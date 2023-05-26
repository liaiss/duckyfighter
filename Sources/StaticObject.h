//
//  StaticObject.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "GameObject.h"
#import "GameSprite.h"
#import "Sound.h"

enum {
    STATIC_OBJECT_DEFAULT_TYPE = 0,
	STATIC_OBJECT_BONUS_GENERATOR_TYPE = 1
};

@interface StaticObject : GameObject {

    GameSprite* m_StaticSprite;
	
	Sound* m_Sound;
}

- (id) initStaticObject : (ObjectInfo*) info;

- (void) dealloc;

- (void) setSprite :  (NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved;

@end
