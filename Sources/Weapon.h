//
//  Weapon.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "MovingObject.h"
#import "ObjectInfo.h"
#import "MoveMap.h"

enum {      
	WEAPON_PLAYER   = 0,
	WEAPON_ENEMY   = 1,
};

@interface Weapon : MovingObject {
 
	NSUInteger m_WeaponType;
	MoveMap* m_MoveMap;
}

- (id) initWeapon : (ObjectInfo*) info : (NSUInteger) weaponType;

- (void) dealloc;

- (void) move: (NSInteger) x: (NSInteger) y;

- (void) loadMoveFile : (NSString*) file;

- (void) actionCollision : (GameObject*) obj : (PlayerScore*)  score;

- (NSUInteger) getWeaponType;

@end
