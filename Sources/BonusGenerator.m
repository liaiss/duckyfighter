//
//  BonusGenerator.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 28/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "BonusGenerator.h"
#import "Bonus.h"
#import "Level.h"
#import "stdlib.h"

@implementation BonusGenerator

- (id) initBonusGenerator : (ObjectInfo*) info {
	
	if (![super initStaticObject:info]) {
	    return nil;
	}

	m_BonusTable = nil;
	m_IsBonusGenerated = NO;
	
	srandom (time(0));
	
	return self;
}

- (void) actionCollision: (GameObject*) obj: (PlayerScore*) sc {
    // if collision with player 
	// add a randomize bonus to the level step displayed bonus table.
	if (!m_IsBonusGenerated) {
	    NSUInteger type = random() % MAX_BONUS_COUNT;
	    Bonus* bonus = [[Level level] createBonus:type:(m_XMax + m_XMin)/2 : (m_YMax + m_YMin) / 2];
	
		[bonus setSpeedX:m_SpeedX];
		
	    [m_BonusTable add:bonus];
		
		[bonus release];
		
	    m_IsBonusGenerated = YES;
	}
}

- (void) setLevelStepDisplayedBonusTable : (ObjectTable*) bonusTable {
	m_BonusTable = bonusTable;
}

@end
