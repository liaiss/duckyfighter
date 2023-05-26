//
//  MovingObject.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "MovingObject.h"
#import "GameObject.h"
#import "LayerManager.h"
#import "SoundManager.h"
#import "Util.h"
#import "Enemy.h"

static int remainingMovingObject = 0;

@implementation MovingObject

- (id) initMovingObject : (ObjectInfo*) info {
	
	if (![super initObject : info]) {
		return nil; 
	}
    
    // NSLog(@"Allocate Moving Object: %x.", self);
    
    remainingMovingObject++;
	
	m_SpeedY = [info getSpeedY];

	m_NewXMin   = [info getXPos];
	m_NewYMin   = [info getYPos];
	
	m_UpStep     = 1;
	m_DownStep   = 1;
	m_LeftStep   =  1;
	m_RightStep  = 1;
	
	m_SpriteUp = nil;
	m_SpriteDown = nil;
	m_SpriteLeft = nil;
	m_SpriteRight = nil;
	m_SpriteFire = nil;
	m_SpriteMissile = nil;
	m_SpriteExplode = nil;
	
	m_State = MOVING_OBJECT_NOTHING;
	
	// Initialize picture.
	[self setSpriteUp:[info getResourcesUp]:[info getTimeCountPerFrame]:[info getLoopFrameStart]:[info isReservedResource]];
	[self setSpriteDown:[info getResourcesDown]:[info getTimeCountPerFrame]:[info getLoopFrameStart]:[info isReservedResource]];
	[self setSpriteLeft:[info getResourcesLeft]:[info getTimeCountPerFrame]:[info getLoopFrameStart]:[info isReservedResource]];
	[self setSpriteRight:[info getResourcesRight]:[info getTimeCountPerFrame]:[info getLoopFrameStart]:[info isReservedResource]];
	[self setSpriteFire:[info getResourcesFire]:[info getTimeCountPerFrame]:[info getLoopFrameStart]:[info isReservedResource]];
	[self setSpriteMissile:[info getResourcesMissile]:[info getTimeCountPerFrame]:[info getLoopFrameStart]:[info isReservedResource]];
	[self setSpriteExplode:[info getResourcesExplode]:[info getTimeCountPerFrame]:[info getLoopFrameStart]:[info isReservedResource]];
	
	m_Explode = YES;
	
	NSUInteger width = [m_SpriteUp getWidth];
	NSUInteger height = [m_SpriteUp getHeight];
	
	[self setWidth:width];
	[self setHeight:height];
	
	m_NewXMax   = [info getXPos] + width;
	m_NewYMax   = [info getYPos] + height;
	
	m_Sound = [[SoundManager soundManager] getSound:[info getSound]:SOUND_EXTENSION:[info isReservedResource]];
	
    
    m_WaitEndSprite = NO;
    
	return self;
}

- (void) dealloc {
	
	[m_SpriteUp release]; 
	[m_SpriteDown release]; 
	[m_SpriteLeft release]; 
	[m_SpriteRight release]; 
	[m_SpriteFire release];
	[m_SpriteMissile release];
	[m_SpriteExplode release];
	[super dealloc]; 
    remainingMovingObject--;
//	NSLog (@"Release moving object: %d", remainingMovingObject);
}

- (bool) checkCollisionMask: (GameObject*) obj {
	// Check CurrentLayer content in order to check alpha bit to detect collision with the parameter Gameobject
    return YES;
}

- (void) draw {
	
	GameSprite* currentSprite;
    NSInteger NewVal;
	
    switch (m_State) {
			
        case MOVING_OBJECT_UP: 
			
			if (nil == m_SpriteUp) {
				return;
			}
			
			currentSprite = m_SpriteUp;
			
			NewVal = m_YMin - m_UpStep;
			
			m_YMin = (NewVal < m_NewYMin) ? m_NewYMin : NewVal;
			
			NewVal = m_YMax - m_UpStep;
			
			m_YMax = (NewVal < m_NewYMax) ? m_NewYMax:NewVal;
			
			break;
		case MOVING_OBJECT_DOWN: 
			
			if (nil == m_SpriteDown) {
				return;
			}
			
			currentSprite = m_SpriteDown;
			
			NewVal = m_YMin + m_DownStep;
			
			m_YMin = (NewVal > m_NewYMin) ? m_NewYMin : NewVal;
			
			NewVal = m_YMax + m_DownStep;
			
			m_YMax = NewVal > m_NewYMax ? (m_NewYMax): NewVal;
			
			break;
		case MOVING_OBJECT_LEFT: 
			
			if (nil == m_SpriteLeft) {
			    return;
		    }
			
			currentSprite = m_SpriteLeft;
			
			NewVal = m_XMin - m_LeftStep;
			
			m_XMin = (NewVal < m_NewXMin) ?(m_NewXMin): NewVal;
			
			NewVal = m_XMax - m_LeftStep;
			
			m_XMax = NewVal < m_NewXMax ? (m_NewXMax): NewVal;
			
			break;
		case MOVING_OBJECT_RIGHT: 
			
			if (nil == m_SpriteRight) {
			    return;
		    }
			
			currentSprite = m_SpriteRight;
			
			NewVal = m_XMin + m_RightStep;
			
			m_XMin = (NewVal > m_NewXMin) ? m_NewXMin: NewVal;
			
			NewVal = m_XMax + m_RightStep;
			
			m_XMax = (NewVal > m_NewXMax) ? m_NewXMax: NewVal;
			
			break;
		case MOVING_OBJECT_FIRE:
			if (nil == m_SpriteFire) {
			    return;
		    }
			
			currentSprite = m_SpriteFire;
			
			break;
		case MOVING_OBJECT_LAUNCH_MISSILE:
			if (nil == m_SpriteMissile) {
			    return;
		    }
			
			currentSprite = m_SpriteMissile;
			
			break;
			
			
		case MOVING_OBJECT_EXPLODE:
			
			if (m_SpriteExplode == nil) {
				m_Explode = YES;
				return;
			}
			
			currentSprite = m_SpriteExplode; 
			
            break; 			
			
		case MOVING_OBJECT_NOTHING: 
			
				if (nil == m_SpriteRight) {
					return;
				} 
				
				currentSprite = m_SpriteRight;
			
			break;
		default: return; 
    }  
		
	[currentSprite draw:m_XMin:m_YMin];
		
	if ([currentSprite next:m_WaitEndSprite]) {
			
		if (m_State == MOVING_OBJECT_EXPLODE) {
			m_Explode = YES;
			m_State = MOVING_OBJECT_DISAPPEAR;
		} else {
			m_State = MOVING_OBJECT_NOTHING;  
		}
	}
}

- (void) move:(NSInteger) x: (NSInteger) y {

    [self moveLeft];
	
	if (y > m_YMax) {
		[self moveUp];
	} else if (y < m_YMin) {
		[self moveDown];
	}
}

- (void) moveUp {
	
	if (m_State != MOVING_OBJECT_NOTHING) {
        m_YMin = m_NewYMin;   
        m_YMax = m_NewYMax;
        m_XMin = m_NewXMin;
        m_XMax = m_NewXMax;
    }
	
    m_NewYMin = m_YMin + m_SpeedY;	
    m_NewYMax = m_YMax + m_SpeedY;
	
    if (m_State != MOVING_OBJECT_UP) {
		m_State = MOVING_OBJECT_UP;
    }	
}


- (void) moveDown {
	
	if (m_State != MOVING_OBJECT_NOTHING) {
        m_YMin = m_NewYMin;   
        m_YMax = m_NewYMax;
        m_XMin = m_NewXMin;
        m_XMax = m_NewXMax;
    }
	
    m_NewYMin = m_YMin - m_SpeedY;	
    m_NewYMax = m_YMax - m_SpeedY;
	
    if (m_State != MOVING_OBJECT_DOWN) {
		m_State = MOVING_OBJECT_DOWN;
    }	
}


- (void) moveLeft {
	
	if (m_State != MOVING_OBJECT_NOTHING) {
        m_YMin = m_NewYMin;   
        m_YMax = m_NewYMax;
        m_XMin = m_NewXMin;
        m_XMax = m_NewXMax;
    }
    
    m_NewXMin = m_XMin - m_SpeedX;	
    m_NewXMax = m_XMax - m_SpeedX;	
	
    if (m_State != MOVING_OBJECT_LEFT) { 
        m_State = MOVING_OBJECT_LEFT;
    }
}


- (void) moveRight {
	
	if (m_State != MOVING_OBJECT_NOTHING) {
        m_YMin = m_NewYMin;   
        m_YMax = m_NewYMax;
        m_XMin = m_NewXMin;
        m_XMax = m_NewXMax;
    }
    
    m_NewXMin = m_XMin + m_SpeedX;	
    m_NewXMax = m_XMax + m_SpeedX;	
	
    if (m_State != MOVING_OBJECT_RIGHT) {
        m_State = MOVING_OBJECT_RIGHT;
    }
	
}


- (void) fire {
    if (m_State != MOVING_OBJECT_FIRE)  {
        m_State = MOVING_OBJECT_FIRE;
    }
}

- (void) launchMissile {
    if (m_State != MOVING_OBJECT_LAUNCH_MISSILE)  {
        m_State = MOVING_OBJECT_LAUNCH_MISSILE;
    }
}

- (void) explode {
	m_Impact = 0;
	m_State = MOVING_OBJECT_EXPLODE;
	[m_SpriteExplode reset];
	m_Explode = NO;
	[self playSoundExplode];
}

- (void) playSoundExplode {
    [m_Sound play:NO];
}

- (void) setSpriteUp:(NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved {
	
	NSUInteger newStep;
    
    if (array != nil)
    {
	    m_SpriteUp = [[GameSprite alloc] initSprite:array:timeCountPerFrame:loopFrameStart:isReserved];
	
        if ([m_SpriteUp getFrameCount] > 0) {
            newStep = m_SpeedY / [m_SpriteUp getFrameCount] - 1;
        } else {
            newStep = m_SpeedY;
        }

        m_UpStep = (newStep != 0) ? newStep : 1 ; 
    }
}

- (void) setSpriteDown:(NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved {
	
	NSUInteger newStep;
    
    if (array != nil)
    {
	    m_SpriteDown = [[GameSprite alloc] initSprite:array:timeCountPerFrame:loopFrameStart:isReserved];
        
        if ([m_SpriteDown getFrameCount] > 0) {
            newStep = m_SpeedY / [m_SpriteDown getFrameCount] - 1;
        } else {
            newStep = m_SpeedY;
        }
        
        m_DownStep = (newStep != 0) ? newStep : 1 ; 
    }
}

- (void) setSpriteLeft:(NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved {
    NSUInteger newStep;
    
    if (array != nil)
    {
	   m_SpriteLeft = [[GameSprite alloc] initSprite:array:timeCountPerFrame:loopFrameStart:isReserved];	
   
       if ([m_SpriteLeft getFrameCount] > 0) {
            newStep = m_SpeedX / [m_SpriteLeft getFrameCount] - 1;
       } else {
            newStep = m_SpeedX;
       } 
    
       m_LeftStep = (newStep != 0) ? newStep : 1 ; 
    }
}

- (void) setSpriteRight:(NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved {
    NSUInteger newStep;
    
    if (array != nil)
    {
	    m_SpriteRight = [[GameSprite alloc] initSprite:array:timeCountPerFrame:loopFrameStart:isReserved];	
	        
        if ([m_SpriteRight getFrameCount] > 0) {
            newStep = m_SpeedX / [m_SpriteRight getFrameCount] - 1;
        } else {
            newStep = m_SpeedX;
        } 
        
        m_RightStep = (newStep != 0) ? newStep : 1 ; 
    }
}

- (void) setSpriteFire :(NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved {
    if (array != nil)
    {
	    m_SpriteFire = [[GameSprite alloc] initSprite:array:timeCountPerFrame:loopFrameStart:isReserved];	
    }
}

- (void) setSpriteMissile :(NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved {
	if (array != nil)
    {
        m_SpriteMissile = [[GameSprite alloc] initSprite:array:timeCountPerFrame:loopFrameStart:isReserved];	
    }
}

- (void) setSpriteExplode : (NSArray*) array: (NSUInteger) timeCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved {
	if (array != nil)
    {
	    m_SpriteExplode = [[GameSprite alloc] initSprite:array:timeCountPerFrame:loopFrameStart:isReserved];
    }
}

- (void) resetExplode {
    m_Explode = YES;
	m_State = MOVING_OBJECT_NOTHING;
}

- (bool) isExplode{
	return m_Explode;
}

- (void) actionCollision : (GameObject*) obj : (PlayerScore*)  score {
    if ((m_State != MOVING_OBJECT_EXPLODE) && (m_State != MOVING_OBJECT_DISAPPEAR)) {
	    [super actionCollision:obj:score];
	
	    if (m_Energy <= 0) {
	       [self explode];
	    }
    }
}

- (void) setSpeedX : (NSInteger) speedX {
	m_SpeedX = speedX;
}

- (void) setSpeedY : (NSInteger) speedY {
	m_SpeedY = speedY;
}

- (NSInteger) getSpeedY {
	return m_SpeedY;
}

- (NSInteger) getState {
	return m_State;
}

- (void) setX : (NSInteger) x {
	[super setX:x];
	m_NewXMin   = m_XMin;
	m_NewXMax   = m_XMax;
}

- (void) setY : (NSInteger) y {
	[super setY:y]; 
	m_NewYMin   = m_YMin;
	m_NewYMax   = m_YMax;
}


@end
