//
//  PlayerShip.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "PlayerShip.h"
#import "ObjectInfo.h"
#import "WeaponTable.h"
#import "Weapon.h"
#import "Level.h"
#import "WeaponFactory.h"

#define SHIP_ATTRACTION 80
#define MISSILE_PLAYER 1
#define MAX_DELAY_BEETWEEN_FIRE 6
#define MAX_DELAY_BEETWEEN_MISSILE 10

@implementation PlayerShip


- (void) move : (NSInteger) x : (NSInteger) y {
    [super move:x:y];
}


- (id) initPlayerShip:(ObjectInfo*) infoShip:(ObjectInfo*) infoSat: (NSUInteger) lifeCount {
	
	if (![super initMovingObject: infoShip]) {
		return nil; 
	}
	
	m_Satellite = [[PlayerSatellite alloc] initSatellite:infoSat:SHIP_ATTRACTION];
	m_LifeCount = lifeCount;
	m_LifeCountMax = lifeCount;
	m_MissilePower = 1;
	m_CurrentMissile = MISSILE_PLAYER;
	m_FirePower = 1;
	m_EnergyMax = m_Energy;
	m_WeaponTab = [[WeaponTable alloc] initWeaponTable];
    
    m_WeaponX = [infoShip getWeaponX];
    m_WeaponY = [infoShip getWeaponY];
   
	m_IsBlinking = NO;
	m_IsDrawBlinking = NO;
	
	m_DelayBetweenMissile = 0;
	m_DelayBetweenFire = 0;
	
    m_WaitEndSprite = YES;
    
	return self;
}

- (void) dealloc {
	[m_Satellite release];
	[m_WeaponTab release];
	[super dealloc];
}

- (void) moveUp  {
	if ((m_State != MOVING_OBJECT_EXPLODE) && (m_State != MOVING_OBJECT_DISAPPEAR)) {
		[super moveUp];
        [m_Satellite move:m_XMin:m_YMin];
        //    [m_WeaponTab move:m_XMin:m_YMin];
    }
}

- (void) moveDown  {
	if ((m_State != MOVING_OBJECT_EXPLODE) && (m_State != MOVING_OBJECT_DISAPPEAR)) {
		[super moveDown];
        [m_Satellite move:m_XMin:m_YMin];
        //    [m_WeaponTab move:m_XMin:m_YMin];
    }
}

- (void) moveLeft {
	if ((m_State != MOVING_OBJECT_EXPLODE) && (m_State != MOVING_OBJECT_DISAPPEAR)) {
        [super moveLeft];
        [m_Satellite move:m_XMin:m_YMin];
        //    [m_WeaponTab move:m_XMin:m_YMin];
    }
}

- (void) moveRight {	
	if ((m_State != MOVING_OBJECT_EXPLODE) && (m_State != MOVING_OBJECT_DISAPPEAR)) {
		[super moveRight];
        [m_Satellite move:m_XMin:m_YMin];
        //    [m_WeaponTab move:m_XMin:m_YMin];
    }
}

- (void) draw {
    if (m_State == MOVING_OBJECT_EXPLODE) {
        [super draw];
    }
    else {
	    if ((m_IsBlinking && m_IsDrawBlinking) || (!m_IsBlinking)) {
	        [super draw];
	
		    if (m_State == MOVING_OBJECT_DISAPPEAR) {
		        [self decLifeCount]; 
	        }
		
            if (m_IsBlinking) {
			    m_IsDrawBlinking = NO;
			    --m_ShieldActivation;
			
			    if (m_ShieldActivation <= 0) {
			        m_IsBlinking = NO;
			    }
		    }
	    } else {
		    if (m_IsBlinking) {
			    m_IsDrawBlinking = YES;
			    --m_ShieldActivation;
			
			    if (m_ShieldActivation <= 0) {
			        m_IsBlinking = NO;
			    }
		    }
	    }
	
	    if (m_State != MOVING_OBJECT_DISAPPEAR) {
		    [m_Satellite draw];
		    [m_WeaponTab draw];
	    }
    }
}

- (void) moveWeapon {
	if ((m_State != MOVING_OBJECT_EXPLODE) && (m_State != MOVING_OBJECT_DISAPPEAR)) {
		[m_WeaponTab move:m_XMin:m_YMin];
		[m_Satellite moveWeapon];
	}
}

- (void) explode {
    if (m_State != MOVING_OBJECT_DISAPPEAR) {
        
        if (m_Explode == YES) {
	        [super explode];
	        [m_Satellite explode];
            [m_WeaponTab clear];
        }
    }
}

- (void) actionCollision : (GameObject*) obj : (PlayerScore*)  score {
    if ((m_State != MOVING_OBJECT_EXPLODE) && (m_State != MOVING_OBJECT_DISAPPEAR)) {
        
	    if (m_ShieldActivation <= 0) {
	       [super actionCollision:obj:score];
            
            if (m_Energy > 0 ) {
                m_ShieldActivation = 15;
                m_IsBlinking = YES;
            }
	    } 	
    }
}

- (bool) detectCollision : (GameObject*) obj : (PlayerScore*) sc {
	bool res = NO;
	
    if ((m_State != MOVING_OBJECT_EXPLODE) && (m_State != MOVING_OBJECT_DISAPPEAR)) {
	    res =[super detectCollision:obj:sc];	
	    res = res || [m_WeaponTab detectCollision:obj:sc];
	}
    
	return res;
}

- (void) fire {
	if ((m_State != MOVING_OBJECT_EXPLODE) && (m_State != MOVING_OBJECT_DISAPPEAR)) {
        [super fire];
		if (m_DelayBetweenFire == 0) {
            [WeaponFactory createWeapon:m_WeaponTab :m_CurrentWeapon :WEAPON_PLAYER :m_FirePower :RIGHT_DIRECTION :m_XMax - m_WeaponX :m_YMin + m_WeaponY];	    
            [m_Satellite fire];
            ++m_DelayBetweenFire;
            m_DelayBetweenFire %= MAX_DELAY_BEETWEEN_FIRE;
        } else {
            ++m_DelayBetweenFire;
            m_DelayBetweenFire %= MAX_DELAY_BEETWEEN_FIRE;
        }
	}
}
	

- (void) launchMissile {
	
	
	if ((m_State != MOVING_OBJECT_EXPLODE) && (m_State != MOVING_OBJECT_DISAPPEAR)) {
        [super launchMissile];
		[WeaponFactory createWeapon:m_WeaponTab :m_CurrentMissile :WEAPON_PLAYER :m_MissilePower :DOWN_DIRECTION :m_XMin :m_YMin];
        
        /*if (m_DelayBetweenMissile == 0) {
         // Move create weapon here to reduce weapon frequency
         
         ++m_DelayBetweenMissile;
         m_DelayBetweenMissile %= MAX_DELAY_BEETWEEN_MISSILE;
         } else {
         ++m_DelayBetweenMissile;
         m_DelayBetweenMissile %= MAX_DELAY_BEETWEEN_MISSILE;
         }*/
        
	}
	
}


- (WeaponTable*) getWeapons  { 
    return m_WeaponTab;
}

- (NSInteger) getLifeCount {
	return m_LifeCount;
}

- (void) setLifeCount : (NSInteger) lifeCount {
	m_LifeCount = lifeCount;
}

- (void) setEnergyMax : (NSUInteger) energyMax {
	m_EnergyMax = energyMax;
}

- (void) setFirePower : (NSUInteger) powerLevel {
	m_FirePower = powerLevel;
}

- (void) setMissilePower : (NSUInteger) powerLevel {
	m_MissilePower = powerLevel;
}

- (void) setShield : (NSInteger) shieldValue {
	m_ShieldActivation = shieldValue;
	
	if (shieldValue != 0) {
	    m_IsBlinking = YES;
	    m_IsDrawBlinking = NO;
	}
}

- (void) setCurrentWeapon : (NSInteger) weapon {
	m_CurrentWeapon = weapon;
	[m_Satellite setCurrentWeapon:m_CurrentWeapon];
}

- (void) setCurrentMissile : (NSInteger) missile {
	m_CurrentMissile = missile;
}

- (void) setEnergy : (NSInteger) energy {
	[super setEnergy : energy];
}

- (NSUInteger) getShield {
	return m_ShieldActivation;
}

- (NSUInteger) getEnergyMax {
	return m_EnergyMax;
}

- (NSUInteger) getFirePower {
	return m_FirePower;
}

- (NSUInteger) getMissilePower {
	return m_MissilePower;
}


- (NSInteger) getCurrentWeapon {
	return m_CurrentWeapon;
}

- (NSInteger) getCurrentMissile {
    return m_CurrentMissile;
}

- (PlayerSatellite*) getSatellite {
	return m_Satellite;
}

- (void) decLifeCount {
	m_State = MOVING_OBJECT_NOTHING;
    [m_Satellite resetExplode];
    [self resetExplode];
	m_Energy = m_EnergyMax;
    m_FirePower = 1;
    m_MissilePower = 1;
	--m_LifeCount;
	m_IsBlinking = YES;
	m_IsDrawBlinking = NO;
	m_ShieldActivation = 100;
}


- (void) resetShip {
    [m_WeaponTab clear];
    [m_Satellite destroyWeapons];
	m_Energy = m_EnergyMax;
	m_LifeCount = m_LifeCountMax;
	m_MissilePower = 1;
	m_CurrentMissile = MISSILE_PLAYER;
	m_FirePower = 1;
	m_IsBlinking = NO;
	m_IsDrawBlinking = NO;
	m_State = MOVING_OBJECT_NOTHING;
	m_DelayBetweenMissile = 0;
	m_DelayBetweenFire = 0;
}


@end
