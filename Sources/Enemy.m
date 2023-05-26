//
//  Enemy.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "MoveMap.h"
#import "Enemy.h"
#import "Level.h"
#import "WeaponFactory.h"

static int remainingEnemy = 0;

@implementation Enemy

- (id) initEnemy:(ObjectInfo*) info {
	
	if (![super initMovingObject:info]) {
	    return nil;
	}
    
    // NSLog(@"Allocate Enemy: %x.", self);
    
    remainingEnemy++;
	
	m_MoveMap = [[MoveMap alloc] initMoveMap];
	
	m_WeaponTab = [[WeaponTable alloc] initWeaponTable];
	m_CurrentWeapon = [info getWeapon];
	m_FirePower = [info getWeaponPower];
    
	m_WeaponX = [info getWeaponX];
    m_WeaponY = [info getWeaponY];
	
    m_Direction = [info getWeaponDirection];
    
	[self loadMoveFile:[info getMoveFile]];
	
    m_WaitEndSprite = NO;
    
	return self;
	
}

- (void) dealloc {
	[m_WeaponTab release];
	[m_MoveMap release];
	[super dealloc];
    remainingEnemy--;
   // NSLog(@"Enemy release: %d", remainingEnemy);
}

- (void) loadMoveFile : (NSString*) file {
    [m_MoveMap loadMoveFile:file];
}

- (void) move :(NSInteger) x:(NSInteger) y {
	/* si l'ennemi est en train d'exploser on deplace ses armes */
    
    if (!m_Explode && (m_State == MOVING_OBJECT_EXPLODE))
    {
		[m_WeaponTab move:x:y];	
        return;
    }
	
    if (m_State == MOVING_OBJECT_NOTHING) {
	switch ([m_MoveMap nextMove]) {
		case   MOVE_UP: 
			[super moveUp]; 
			break;
		case    MOVE_DOWN: 
			[super moveDown];  
			break;
		case MOVE_LEFT: 
			[super moveLeft];
			break;
		case MOVE_RIGHT: 
			[super moveRight];
			break;
		case   MOVE_UP_LEFT: 
			[super moveUp];
			[super moveLeft];
			break;
		case   MOVE_UP_RIGHT: 
			[super moveUp];
			[super moveRight];
			break;
		case    MOVE_DOWN_LEFT: 
			[super moveDown]; 
			[super moveLeft];
			break;
		case    MOVE_DOWN_RIGHT: 
			[super moveDown]; 
			[super moveRight];
			break;	
		case MOVE_UP_N_FIRE: 
			[super moveUp];
			[self fire]; 
			break;
		case MOVE_DOWN_N_FIRE: 
			[super moveDown];
			[self fire];  
			break;
		case MOVE_LEFT_N_FIRE: 
			[super moveLeft];
			[self fire];
			break;
		case MOVE_RIGHT_N_FIRE: 
			[super moveRight];
			[self fire];
			break;
		case MOVE_UP_LEFT_N_FIRE: 
			[super moveUp];
			[super moveLeft];
			[self fire]; 
			break;
		case MOVE_UP_RIGHT_N_FIRE: 
			[super moveUp];
			[super moveRight];
			[self fire]; 
			break;
		case MOVE_DOWN_LEFT_N_FIRE: 
			[super moveDown];
			[super moveLeft];
			[self fire];  
			break;
		case MOVE_DOWN_RIGHT_N_FIRE: 
			[super moveDown];
			[super moveRight];
			[self fire];  
			break;
		case MOVE_FIRE: 
			[self fire];
			break;
		case NO_MOVE: 
			if (m_YMin  == y) {
				[super fire];
			}        
			
			[super move:x:y];	 
			
			break;
		default: [super move:x:y];	
			break;
	}
    }
    
    [m_WeaponTab move:x:y];	
}

- (void) actionCollision : (GameObject*) obj: (PlayerScore*)  sc {
	if ((obj->m_Energy > 0) && (m_Energy > 0)) {
	    m_Energy -= obj->m_Impact;
		
      
        if ([obj isKindOfClass:[PlayerShip class]]) {
            if ([(PlayerShip*) obj getShield] <= 0) {
                [obj setEnergy:[obj getEnergy] - m_Impact];
		    } 
		}
		
		[sc update:m_Impact];
	}
}

- (bool) detectCollision: (GameObject*) obj: (PlayerScore*) sc{
	bool result = NO;
    
    result = result || [super detectCollision:obj:sc];
    result = result || [m_WeaponTab detectCollision:obj:sc];
	
    return result;
}

- (void) fire {
    
	if (m_CurrentWeapon != 0) {
	    [super fire];
        
		[WeaponFactory createWeapon:m_WeaponTab :m_CurrentWeapon :WEAPON_ENEMY :m_FirePower :m_Direction :m_XMin + m_WeaponX :m_YMin + m_WeaponY];
    }
}

- (void) draw {
	[super draw];
    [m_WeaponTab draw];
}

- (void) setWeapon:(NSUInteger) weapon {
    m_CurrentWeapon = weapon;
}


@end
