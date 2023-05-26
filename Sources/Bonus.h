//
//  Bonus.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "StaticObject.h"

#define MAX_BONUS_COUNT 7

enum {
	BONUS_LIFE_UP = 0,
	BONUS_FIRE_POWER = 1,
	BONUS_MISSILE_POWER = 2,
	BONUS_CLEAN_SCREEN = 3,
	BONUS_INVINCIBLE = 4,
    BONUS_ENERGY = 5,
};

@interface Bonus : StaticObject {
    NSUInteger m_Type;
}

- (id) initBonus :(ObjectInfo*) info: (NSUInteger) type;

- (void) actionCollision : (GameObject*) obj : (PlayerScore*)  score;

@end
