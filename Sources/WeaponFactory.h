//
//  WeaponFactory.h
//  DuckyFighter
//
//  Created by Liaiss Merzougue on 24/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WeaponTable.h"


#define DOWN_DIRECTION 0
#define UP_DIRECTION 1
#define LEFT_DIRECTION 2
#define RIGHT_DIRECTION 3
#define UP_RIGHT_DIRECTION 4
#define UP_LEFT_DIRECTION 5
#define DOWN_RIGHT_DIRECTION 6
#define DOWN_LEFT_DIRECTION 7
#define ALL_DIRECTION 8
#define ALL_DOUBLE_DIRECTION 9

@interface WeaponFactory : NSObject {

}

+ (void) createWeapon : (WeaponTable*) weaponTable: (NSInteger) weaponId: (NSInteger) weaponType: (NSInteger) firePower : (NSInteger) direction :(NSInteger) x: (NSInteger) y;

@end
