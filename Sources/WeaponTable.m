//
//  WeaponTable.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 26/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "WeaponTable.h"

@implementation WeaponTable

- (id) initWeaponTable {
	
	if (![super initObjectTable:10]) {
		return nil; 
	} 
	
    return self;
}

- (void) dealloc {
    [super dealloc];
}

- (void) addWeapon : (Weapon*) weapon {
	[super add:weapon];
}

@end
