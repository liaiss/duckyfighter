//
//  Enemy.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "GameObject.h"
#import "PlayerScore.h"
#import "ObjectInfo.h"
#import "MovingObject.h"
#import "MoveMap.h"
#import "WeaponTable.h"
#import "Weapon.h"


@interface Enemy : MovingObject {
	MoveMap* m_MoveMap;
	
	WeaponTable* m_WeaponTab;
	NSUInteger m_CurrentWeapon;
	NSUInteger m_FirePower;
    
    NSUInteger m_WeaponX;
    NSUInteger m_WeaponY;  
    
    NSUInteger m_Direction;
}

- (id) initEnemy:(ObjectInfo*) info;

- (void) dealloc; 

- (void) loadMoveFile : (NSString*) file;

- (void) move :(NSInteger) x:(NSInteger) y;

- (bool) detectCollision: (GameObject*) obj: (PlayerScore*) sc;

- (void) fire;

- (void) draw;

- (void) setWeapon:(NSUInteger) weapon;

@end
