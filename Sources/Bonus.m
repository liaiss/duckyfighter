//
//  Bonus.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "Bonus.h"
#import "PlayerShip.h"
#import "Level.h"

@implementation Bonus

- (id) initBonus :(ObjectInfo*) info: (NSUInteger) type {

	if (![super initStaticObject:info]) {
	    return nil;
	}
	
	m_Type = [info getObjectType];
	
    return self;
}

- (void) actionCollision : (GameObject*) obj : (PlayerScore*)  score {
	
    if ([obj isKindOfClass:[PlayerShip class]] ) {    
		
		switch (m_Type) {
			case BONUS_LIFE_UP: [(PlayerShip*) obj setLifeCount:[(PlayerShip*) obj getLifeCount] + 1];
				NSLog(@"Life Up : %d", [(PlayerShip*) obj getLifeCount]);
				break;
			case BONUS_FIRE_POWER:  [(PlayerShip*) obj setFirePower:[(PlayerShip*) obj getFirePower] + 1];
				NSLog(@"Fire Power Up : %d", [(PlayerShip*) obj getFirePower]);
				break;
			case BONUS_MISSILE_POWER:  [(PlayerShip*) obj setMissilePower:[(PlayerShip*) obj getMissilePower] + 1];
				NSLog(@"Missile Power Up : %d", [(PlayerShip*) obj getMissilePower]);
				break;
			case BONUS_CLEAN_SCREEN: [[Level level] removeDisplayedEnemy];
				NSLog(@"Clean screen ");
				break;
			case BONUS_INVINCIBLE: [(PlayerShip*) obj setShield:m_Type*50];
				NSLog(@"Shield : %d ", [(PlayerShip*) obj getShield]);
				break;
            case BONUS_ENERGY: [(PlayerShip*) obj setEnergy:[(PlayerShip*) obj getEnergyMax]];
				NSLog(@"Energy : %d ", [(PlayerShip*) obj getEnergy]);
				break;
			default: if (m_Type < 100) {
                        // Manage Weapon
                        [(PlayerShip*) obj setCurrentWeapon:(m_Type/10) - 1];
                     } else {
                        // Manage score
                        [score update:m_Type];
                        NSLog(@"score : %d ", [score getScore]);
                     }

                
                
		}
		
		[m_Sound play:NO];
		
		m_Energy = 0;
	}
}


@end
