//
//  PlayerStatus.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "PlayerScore.h"
#import "Layer.h"

@interface PlayerStatus : NSObject {
    NSUInteger m_EnergyMax;
	Layer* m_Buttons;
	Layer* m_LifeIcon;
	Layer* m_EnergyFullIcon;
	Layer* m_EnergyLowIcon;
	Layer* m_EnergyEmptyIcon;

    NSInteger m_CurrentWeapon;
    NSInteger m_CurrentMissile;
}


- (id) initPlayerStatus : (NSString*) buttonsDisplay: (NSString*) energyFull:
						  (NSString*) energyLow: (NSString*) energyEmpty:
(NSString*) lifeIcon:(NSUInteger) energyMax;

- (void) dealloc;

- (void) update : (PlayerScore*) score: (NSUInteger) lifeCount : (NSInteger) energy;

- (void) setMissile:(NSInteger) weapon;

- (void) setWeapon:(NSInteger) weapon;

- (bool) isPaused:(NSInteger) x:(NSInteger) y;

@end
