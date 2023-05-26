//
//  Weapon.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "Weapon.h"
#import "PlayerShip.h"
#import "MoveMap.h"
#import "Enemy.h"
#import "Sound.h"

@implementation Weapon


- (id) initWeapon : (ObjectInfo*) info : (NSUInteger) weaponType {
	
	if (![super initMovingObject : info]) {
		return nil; 
	}
            
	m_WeaponType = weaponType;	
	
	m_MoveMap = [[MoveMap alloc] initMoveMap];
	
	[self loadMoveFile:[info getMoveFile]];
	
	[m_Sound play:NO];
	
    m_WaitEndSprite = YES;
    
	return self;

}

- (void) dealloc {
    
	[m_MoveMap release];
	[super dealloc];
}

- (void) move: (NSInteger) x: (NSInteger) y {
	
	if ((m_State != MOVING_OBJECT_EXPLODE) && (m_State != MOVING_OBJECT_DISAPPEAR)) {
	
        switch ([m_MoveMap nextMove]) {
			
	      case   MOVE_UP: [self moveUp];
						break;
		  case MOVE_DOWN: [self moveDown];
						break;
		  case MOVE_LEFT: [self moveLeft];
						break;
		  case MOVE_RIGHT: [self moveRight];
						break;
		  case MOVE_UP_LEFT: [self moveUp];
							 [self moveLeft]; 
						break;
		  case MOVE_DOWN_LEFT: [self moveDown];
							   [self moveLeft]; 
				        break;
		  case MOVE_UP_RIGHT: [self moveUp];
						      [self moveRight]; 
				        break;
		  case MOVE_DOWN_RIGHT:[self moveDown]; 
							   [self moveRight];
				        break;
		  case NO_MOVE:	 // No move just one walk to the left or right depending of weapon type
						 if (m_WeaponType == WEAPON_ENEMY) {
				             [self moveLeft];
						 } else {
				             [self moveRight];
			             }
		  default: break; 
	    }
	}
}

- (void) loadMoveFile : (NSString*) file {
	[m_MoveMap loadMoveFile:file];
}

- (void) actionCollision : (GameObject*) obj : (PlayerScore*)  score {
	
	// on teste le cas ou l'on entre en collision avec une autre Arme 
    if ([obj isKindOfClass:[Weapon class]]) {    
        return;
    }
	
	m_Energy -= [obj getImpact];
	
    // on teste le cas ou une arme du Joueur entre en collision avec un ennemi     
    if ((m_WeaponType == WEAPON_PLAYER) && [obj isKindOfClass:[Enemy class]]) {
        
		[obj setEnergy:[obj getEnergy] - m_Impact];
	
		if (([obj getEnergy] <= 0) && ([(MovingObject*)obj getState] != MOVING_OBJECT_EXPLODE) && ([(MovingObject*)obj getState] != MOVING_OBJECT_DISAPPEAR)) {
			[(Enemy*) obj explode];
		}
		
		// update score
		[score update: [obj getImpact]];
    }
	
    // on teste le cas ou une arm ennemi entre en collision avec le joueur 
    if ((m_WeaponType == WEAPON_ENEMY) && [obj isKindOfClass:[PlayerShip class]]) {
		if (([(MovingObject*) obj getState] != MOVING_OBJECT_EXPLODE) && 
            ([(MovingObject*) obj getState] != MOVING_OBJECT_DISAPPEAR))
        {
		  // if faut tester si le joueur a un bouclier actif
		  if ([(PlayerShip*)obj getShield] <= 0) { 
            [obj setEnergy:[obj getEnergy] - m_Impact];
		  } else {
			[(PlayerShip*) obj setShield:[(PlayerShip*)obj getShield] - 1];
		  }
        
          if ([obj getEnergy] <= 0) {
            [(PlayerShip*)obj explode];
          }
        }
    } 
	
	if ((m_Energy <= 0) && (m_State != MOVING_OBJECT_EXPLODE) && (m_State != MOVING_OBJECT_DISAPPEAR)) {
	    [self explode];
	}
}

- (NSUInteger) getWeaponType {
    return m_WeaponType;
}

- (void) playSoundExplode {
    // Sound is played when weapon is created and not when weapon is destroyed.
}

@end
