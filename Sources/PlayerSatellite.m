//
//  PlayerSatellite.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "PlayerSatellite.h"
#import "Enemy.h"
#import "StaticObject.h"
#import "Util.h"
#import "Level.h"
#import "WeaponFactory.h"

@implementation PlayerSatellite

- (void) actionCollision: (GameObject*) obj: (PlayerScore*) sc {
	
	// We check if the satellite enter in collision with an enemy or an enemy weapons. 	
	if (([obj isKindOfClass:[Enemy class]]) || (([obj isKindOfClass:[Weapon class]]) && ([(Weapon*)obj getWeaponType] == WEAPON_ENEMY))) {
		
		[obj setEnergy: [obj getEnergy] - m_Impact];
		[sc update:[obj getImpact]];
	}
	
	// we check if the satellite enter in collision with static objects.
	if ([obj isKindOfClass:[StaticObject class]]) {
		// TODO: we analyse the postion and satellite must avoid collision by moving.
		return;
	}
}


- (id) initSatellite : (ObjectInfo*) info : (NSUInteger) attractionPerimeter {
	
	if (![super initMovingObject:info]) {
		return nil;
	}
	
	m_WeaponsTable = [[WeaponTable alloc] initWeaponTable];
	m_AttractionPerimeter = attractionPerimeter;
	
    m_WeaponX = [info getWeaponX];
    m_WeaponY = [info getWeaponY];
    
	return self;
	
} 

- (void) dealloc {
	[m_WeaponsTable release];
    [super dealloc];
} 

- (void) move:(NSInteger) x:(NSInteger) y {
	
    int DiffX, DiffY;
    unsigned int squareDistance;
    unsigned int squarePerimeter = m_AttractionPerimeter * m_AttractionPerimeter;
	
    DiffX = [Util positiveSubstract:m_XMin:x];
    DiffY = [Util positiveSubstract:m_YMin:y];
	
    squareDistance = (DiffX * DiffX) + (DiffY * DiffY);
	    
    if ((x > m_XMin) &&  (squareDistance >= squarePerimeter)) {
        [self moveRight];
    } else if ((x  < m_XMin) &&  (squareDistance >= squarePerimeter)) {
		[self moveLeft];
    }
	
    if ((y > m_YMin) &&  (squareDistance >= squarePerimeter))  {
        [self moveUp];
    } else if ((y < m_YMin) &&  (squareDistance >= squarePerimeter)) {
        [self moveDown];
    }
	
    [m_WeaponsTable move:x:y]; 
    
}

- (void) fire {   
    [WeaponFactory createWeapon:m_WeaponsTable :m_CurrentWeapon :WEAPON_PLAYER :1 :RIGHT_DIRECTION :m_XMax - m_WeaponX :m_YMin + m_WeaponY];
}

- (void) draw {
	[super draw]; 
	
	[m_WeaponsTable draw];
}

- (void) explode {
	[super explode];
    [m_WeaponsTable clear];
}


- (void) moveWeapon {
    [m_WeaponsTable move:0:0]; 
}

- (bool) detectCollision : (GameObject*) obj: (PlayerScore*) sc {
    return [m_WeaponsTable detectCollision:obj:sc]; 
}

- (void) setCurrentWeapon:(unsigned int) weaponValue {
    m_CurrentWeapon = weaponValue;
}

- (void) destroyWeapons{
	[m_WeaponsTable clear]; 
}

- (void) playSoundExplode {
    // No sound is played on explosion of satellite.
}

@end
