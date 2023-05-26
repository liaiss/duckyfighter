//
//  PlayerStatus.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "PlayerStatus.h"
#import "LayerManager.h"
#import "ScreenInfo.h"
#import "TextManager.h"
#import "Weapon.h"
#import "Level.h"

#define MAX_ENERGY_SLOT_COUNT 5
#define HAND_ERROR 10

@implementation PlayerStatus

- (id) initPlayerStatus : (NSString*) buttonsDisplay: (NSString*) energyFull:
						  (NSString*) energyLow:(NSString*) energyEmpty:(NSString*) lifeIcon:(NSUInteger) energyMax {
    
	if (![super init]) {
	    return nil;
	}
	
	m_EnergyMax = energyMax;
	m_Buttons = [[LayerManager layerManager] getLayerWithoutShadow:buttonsDisplay:YES];
	
	m_LifeIcon = [[LayerManager layerManager] getLayerWithoutShadow:lifeIcon:YES];
	m_EnergyFullIcon = [[LayerManager layerManager] getLayerWithoutShadow:energyFull:YES];
	m_EnergyLowIcon = [[LayerManager layerManager] getLayerWithoutShadow:energyLow:YES];
	m_EnergyEmptyIcon = [[LayerManager layerManager] getLayerWithoutShadow:energyEmpty:YES];	
	
    m_CurrentWeapon = 0;
    m_CurrentMissile = 1;
    
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (void) setMissile:(NSInteger) weapon {
    m_CurrentMissile = weapon;
}

- (void) setWeapon:(NSInteger) weapon {
    m_CurrentWeapon = weapon;
}

- (void) update : (PlayerScore*) score: (NSUInteger) lifeCount : (NSInteger) energy {
  
	NSString* scoreText = [[NSString alloc] initWithFormat:@"Score: %d", [score getScore]];
	NSString* lifeText = [[NSString alloc] initWithFormat:@"x%d", lifeCount];
    
    if (energy < 0) {
        energy = 0;
    }
        
	// draw status
	// First, determine how many slot we need to fill
	NSUInteger slotCount = (MAX_ENERGY_SLOT_COUNT * 2 * energy) / m_EnergyMax;
	NSInteger fullCount;
	NSInteger newX = 10;
	CGSize dimension;
	
	for (fullCount = 0; fullCount < (slotCount / 2); ++fullCount) {
		[m_EnergyFullIcon draw: newX: [[ScreenInfo screenInfo ] getHeight] - 40];
		newX += [m_EnergyFullIcon getWidth];
	}
	
	// draw the 50% slot
	if ((slotCount > (fullCount*2)) && (fullCount < MAX_ENERGY_SLOT_COUNT)) {
	    [m_EnergyLowIcon draw: newX:[[ScreenInfo screenInfo ] getHeight] - 40];
		newX += [m_EnergyLowIcon getWidth];
		fullCount++;
	}
		
	// draw empty slot
	for (; fullCount < MAX_ENERGY_SLOT_COUNT; ++fullCount) {
	    [m_EnergyEmptyIcon draw: newX:[[ScreenInfo screenInfo ] getHeight] - 40];
		newX += [m_EnergyLowIcon getWidth];
	}
	
	// draw Life count
	newX = [[ScreenInfo screenInfo] getWidth] - (2*[m_LifeIcon getWidth]);
	[m_LifeIcon draw:newX:[[ScreenInfo screenInfo ] getHeight] - 40];
	
	dimension.width = 50;
	dimension.height = 50;
	
	newX += [m_LifeIcon getWidth] - 10;
	[[TextManager textManager] drawText:lifeText:dimension:24:newX: [[ScreenInfo screenInfo] getHeight] - 65];
	
	// draw button
	[m_Buttons draw: 0 : 0]; 
	
	Layer* weapon = [[Level level] getWeaponIcon:m_CurrentWeapon];
    Layer* missile = [[Level level] getWeaponIcon:m_CurrentMissile];
    
    [weapon draw:59:17];
    [missile draw:[[ScreenInfo screenInfo] getWidth] - 84:17];
    
	dimension.width = 200;
	dimension.height = 50;
	
	// draw score
	[[TextManager textManager] drawText:scoreText:dimension:24 : ([[ScreenInfo screenInfo] getWidth] / 2 ) - (dimension.width/2): [[ScreenInfo screenInfo] getHeight] - 65];
   	
    dimension.width = 50;
	dimension.height = 20;
    
    // draw Pause
    [[TextManager textManager] setColor:0.0:0.0:0.0:0.5];
    [[TextManager textManager] drawText:@"||":dimension:26 : ([[ScreenInfo screenInfo] getWidth] / 2 ) - (dimension.width/2): [[ScreenInfo screenInfo] getHeight] - 60 ];
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
	[scoreText release];
	[lifeText release];
}



- (bool) isPaused:(NSInteger) x:(NSInteger) y {
    bool onPause = NO;
    CGSize dimension;
    
    dimension.width = 50;
	dimension.height = 20;
    
    if (((x >= (([[ScreenInfo screenInfo] getWidth] / 2 ) - (dimension.width/2) - HAND_ERROR)) &&
         (x <= (([[ScreenInfo screenInfo] getWidth] / 2 ) + (dimension.width/2) + HAND_ERROR))) && 
         (y >= ([[ScreenInfo screenInfo] getHeight] - 60 - HAND_ERROR)) &&
         (y <= ([[ScreenInfo screenInfo] getHeight] - 60 + dimension.height + HAND_ERROR)) 
        ) {
        onPause = YES;
    }
    
    return onPause;
}

@end
