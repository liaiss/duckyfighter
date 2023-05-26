//
//  WeaponTable.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 26/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "Weapon.h"
#import "ObjectTable.h"

@interface WeaponTable : ObjectTable {

}

- (id) initWeaponTable;
- (void) dealloc;

- (void) addWeapon : (Weapon*) weapon;

@end
