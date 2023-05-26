//
//  PlayerShip.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "MovingObject.h"
#import "PlayerSatellite.h"
#import "PlayerStatus.h"
#import "WeaponTable.h"
#import "Weapon.h"

@interface PlayerShip : MovingObject {
	
	NSUInteger m_EnergyMax;                   
	NSInteger m_LifeCount;
	NSInteger m_LifeCountMax;
	NSUInteger m_FirePower;                 
	NSUInteger m_MissilePower;              
	NSInteger m_ShieldActivation;             
	
	bool m_IsBlinking;
	bool m_IsDrawBlinking;
	
	WeaponTable* m_WeaponTab;        
	NSInteger m_CurrentWeapon;                
	
	WeaponTable* m_MissileTab;      
	NSInteger m_CurrentMissile;               
	
	PlayerSatellite* m_Satellite;        
	PlayerStatus* m_Stat;
	
    NSUInteger m_WeaponX;
    NSUInteger m_WeaponY;
    
	NSUInteger m_DelayBetweenFire;
	NSUInteger m_DelayBetweenMissile;
}

- (void) move : (NSInteger) x : (NSInteger) y;

- (id) initPlayerShip : (ObjectInfo*) infoShip: (ObjectInfo*) infoSat : (NSUInteger) lifeCount;

- (void) dealloc;

- (void) moveUp ;
- (void) moveDown ;
- (void) moveLeft;
- (void) moveRight;
- (void) moveWeapon;

- (void) draw;

- (bool) detectCollision : (GameObject*) obj : (PlayerScore*) sc;

- (void) fire;

- (void) launchMissile;

- (WeaponTable*) getWeapons;

- (NSInteger) getLifeCount;

- (void) setLifeCount : (NSInteger) lifeCount;
- (void) decLifeCount;
- (void) setEnergyMax : (NSUInteger) energyMax;
- (void) setFirePower : (NSUInteger) powerLevel;
- (void) setMissilePower : (NSUInteger) powerLevel;
- (void) setShield : (NSInteger) shieldValue;
- (void) setCurrentWeapon : (NSInteger) currentWeapon;
- (void) setCurrentMissile : (NSInteger) missile;
- (void) setEnergy : (NSInteger) energy;

- (NSUInteger) getShield;
- (NSUInteger) getEnergyMax;
- (NSUInteger) getFirePower;
- (NSUInteger) getMissilePower;

- (NSInteger) getCurrentWeapon;
- (NSInteger) getCurrentMissile;

- (PlayerSatellite*) getSatellite;

- (void) resetShip;


@end
