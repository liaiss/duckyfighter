//
//  MovingObject.h
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
	MOVING_OBJECT_NOTHING   = 0,
	MOVING_OBJECT_UP        = 1,
	MOVING_OBJECT_DOWN      = 2,
	MOVING_OBJECT_LEFT      = 3,
	MOVING_OBJECT_RIGHT     = 4,
	MOVING_OBJECT_EXPLODE   = 5, 
	MOVING_OBJECT_DISAPPEAR = 6,
	MOVING_OBJECT_FIRE      = 7,
	MOVING_OBJECT_LAUNCH_MISSILE = 8
};

@protocol MovingObjectProtocol

- (void) moveUp ;

- (void) moveDown ;

- (void) moveLeft;

- (void) moveRight;

- (void) fire;

- (void) launchMissile;

- (void) playSoundExplode;

- (void) explode;

- (bool) isExplode;

- (void) resetExplode;

- (NSInteger) getState;

@end

@interface MovingObject : GameObject<MovingObjectProtocol> {
	
	NSInteger m_NewXMin;
	NSInteger m_NewYMin;
	NSInteger m_NewXMax;
	NSInteger m_NewYMax;
	
	NSUInteger m_UpStep;
	NSUInteger m_DownStep;
	NSUInteger m_LeftStep;
	NSUInteger m_RightStep;
	
	NSInteger m_SpeedY;
	
	GameSprite* m_SpriteUp;
	GameSprite* m_SpriteDown;
	GameSprite* m_SpriteLeft;
	GameSprite* m_SpriteRight;
	GameSprite* m_SpriteFire; 
	GameSprite* m_SpriteMissile; 
	GameSprite* m_SpriteExplode;
	
    bool m_WaitEndSprite;
    
	bool m_Explode;
	
	Sound* m_Sound;
	
	NSInteger m_State;
}


- (id) initMovingObject : (ObjectInfo*) info;

- (void) dealloc ; 

- (void) draw;

- (void) moveUp ;

- (void) moveDown ;

- (void) moveLeft;

- (void) moveRight;

- (void) move:(NSInteger) x: (NSInteger) y;

- (void) fire;

- (void) launchMissile;

- (void) playSoundExplode;

- (void) explode;

- (bool) isExplode;

- (void) resetExplode;

- (void) setSpriteUp:(NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved;

- (void) setSpriteDown:(NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved;

- (void) setSpriteLeft:(NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved;

- (void) setSpriteRight:(NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved;

- (void) setSpriteFire:(NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved;

- (void) setSpriteMissile:(NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved;

- (void) setSpriteExplode : (NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved;

- (void) setSpeedX : (NSInteger) speedX;

- (void) setSpeedY : (NSInteger) speedY;

- (void) setX : (NSInteger) x;

- (void) setY : (NSInteger) y;

- (NSInteger) getSpeedY;

- (NSInteger) getState;


@end
