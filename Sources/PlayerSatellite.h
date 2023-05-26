//
//  PlayerSatellite.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "WeaponTable.h"
#import "GameObject.h"
#import "PlayerScore.h"
#import "ObjectInfo.h"
#import "MovingObject.h"

@interface PlayerSatellite : MovingObject {
	WeaponTable* m_WeaponsTable;
	NSUInteger m_CurrentWeapon;
	NSUInteger m_AttractionPerimeter;

    NSUInteger m_WeaponX;
    NSUInteger m_WeaponY;
}

- (void) actionCollision: (GameObject*) obj: (PlayerScore*) sc;

- (id) initSatellite : (ObjectInfo*) info : (NSUInteger) attractionPerimeter;

- (void) dealloc;

- (void) move:(NSInteger) x:(NSInteger) y;

- (void) moveWeapon;

- (void) fire;

- (void) draw;

- (bool) detectCollision : (GameObject*) obj: (PlayerScore*) sc;

- (void) setCurrentWeapon:(NSUInteger) weaponValue;

- (void) destroyWeapons;

@end
