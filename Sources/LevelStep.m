//
//  LevelStep.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "LevelStep.h"
#import "AwaitedObject.h"
#import "BonusGenerator.h"

#define ARRAY_DEFAULT_CAPACITY 16

@implementation LevelStep

- (id) initLevelStep  {
	
	if (![super init]) {
		return nil;
	}
	
	m_ScrollingList = [[NSMutableArray alloc] initWithCapacity:ARRAY_DEFAULT_CAPACITY];
	
	m_DisplayedEnemyList = [[ObjectTable alloc] initObjectTable:ARRAY_DEFAULT_CAPACITY];
	m_DisplayedBonusList = [[ObjectTable alloc] initObjectTable:ARRAY_DEFAULT_CAPACITY];
	m_DisplayedObjectList = [[ObjectTable alloc] initObjectTable:ARRAY_DEFAULT_CAPACITY];
	
    m_AwaitedEnemyList = [[NSMutableArray alloc] initWithCapacity:ARRAY_DEFAULT_CAPACITY];
	m_AwaitedBonusList = [[NSMutableArray alloc] initWithCapacity:ARRAY_DEFAULT_CAPACITY];
	m_AwaitedObjectList = [[NSMutableArray alloc] initWithCapacity:ARRAY_DEFAULT_CAPACITY];
	
	m_CurrentL1Indicator  = 0;		
	
	return self; 	
}
 

- (void) dealloc {
	NSLog (@"Release level step");
	
	[m_ScrollingList release];
	
	[m_DisplayedEnemyList release];
	[m_DisplayedBonusList release];
	[m_DisplayedObjectList release];
    
	[m_AwaitedEnemyList removeAllObjects];
	[m_AwaitedEnemyList release];
	[m_AwaitedBonusList removeAllObjects];
    [m_AwaitedBonusList release];
    [m_AwaitedObjectList removeAllObjects];
	[m_AwaitedObjectList release];
	
    [super dealloc];
	
}

- (void) updateL1Enemy {

	for (NSUInteger i = 0; i < [m_AwaitedEnemyList count];) {
		
		if ([(AwaitedObject*) [m_AwaitedEnemyList objectAtIndex:i] getL1Indicator] == m_CurrentL1Indicator) {
			[m_DisplayedEnemyList add:[(AwaitedObject*) [m_AwaitedEnemyList objectAtIndex:i] getObject]];
			[m_AwaitedEnemyList removeObjectAtIndex:i];
	    } else {
			++i;
		} 
	}
}
			
- (void) updateL1Bonus {	
	
	for (NSUInteger i = 0; i < [m_AwaitedBonusList count];) {
		
		if ([(AwaitedObject*) [m_AwaitedBonusList objectAtIndex:i] getL1Indicator] == m_CurrentL1Indicator) {
			[m_DisplayedBonusList add:[(AwaitedObject*) [m_AwaitedBonusList objectAtIndex:i] getObject]];
			[m_AwaitedBonusList removeObjectAtIndex:i];
	    } else {
			++i;
		} 
	}
}		

- (void) updateL1Object {	
	
	for (NSUInteger i = 0; i < [m_AwaitedObjectList count];) {
		
		if ([(AwaitedObject*) [m_AwaitedObjectList objectAtIndex:i] getL1Indicator] == m_CurrentL1Indicator) {
			[m_DisplayedObjectList add:[(AwaitedObject*) [m_AwaitedObjectList objectAtIndex:i] getObject]];
			[m_AwaitedObjectList removeObjectAtIndex:i];
	    } else {
			++i;
		} 
	}
}		

- (void) update: (NSInteger) x : (NSInteger) y {
 
    // update objects move.
    [m_DisplayedEnemyList move:x:y];
    [m_DisplayedBonusList move:x:y];
    [m_DisplayedObjectList move:x:y];

    // If the enemy list is empty we fill it with the awaited enemy with the same l1indicator than currentL1Indicator
	[self updateL1Enemy];
	
    // same for bonus
	[self updateL1Bonus];
	
	// same for object
	[self updateL1Object];
	
    // update scrolling
    [self updateScrolling];
    
    ++m_CurrentL1Indicator;
}

- (void) updateScrolling {
    NSUInteger count = [m_ScrollingList count];
	
	for (NSUInteger i = 0; i < count; ++i) {
		[(Scrolling*)[m_ScrollingList objectAtIndex:i] update];
	}    
}

- (bool) makeTransition {
    NSUInteger count = [m_ScrollingList count];
	bool result = YES;
    
	for (NSUInteger i = 0; i < count; ++i) {
		result = result && ([(Scrolling*)[m_ScrollingList objectAtIndex:i] makeTransition]);
	}    
    
    return result;
}

- (void) draw {
	NSUInteger count = [m_ScrollingList count];
	
	if (count >= 2) {
	    --count;
	}
	
	for (NSUInteger i = 0; i < count; ++i) {
		[self drawScrolling:i];
	}
	
	
	[m_DisplayedObjectList draw];
	[m_DisplayedEnemyList draw];
	[m_DisplayedBonusList draw];
}

- (bool) detectCollision : (PlayerShip*) player : (PlayerScore*) sc {
    bool result;
    NSUInteger count;
	
    // get the player satellite. 
    PlayerSatellite* sat = [player getSatellite];
    
    // Check if the ship is in collision with weapon enemy.
    result = [m_DisplayedEnemyList detectCollision:player:sc];    
	
	//  Check if the satellite is in collision with weapon enemy.
    [m_DisplayedEnemyList detectCollision:sat:sc];  
    
    // we check if the player have encounter a bonus item.
	[m_DisplayedBonusList detectCollision:player:sc];
	
	// we check if the player have encounter a solid object.
	result = result || [m_DisplayedObjectList detectCollision:player:sc];

    // For each enemy, we check if it is in collision with player or its satellite weapon. 
	count = [m_DisplayedEnemyList getSize];
    for (NSUInteger j = 0; j < count; ++j) {
        [player detectCollision:[m_DisplayedEnemyList get:j]:sc]; 
        [sat detectCollision:[m_DisplayedEnemyList get:j]:sc];
    }
    
    // Return if the player have been touched.
    return result;	
}

- (void) drawScrolling: (NSUInteger) plan {
	[(Scrolling*)[m_ScrollingList objectAtIndex:plan] draw]; 
}

- (void) addEnemy : (Enemy*) enemy : (NSUInteger) l1Indicator {
	
    // if l1Indicator is same we display enemy
    if (l1Indicator == m_CurrentL1Indicator) {  
        [m_DisplayedEnemyList add:enemy];
    } else {
		// else we add to awaited object list.
		AwaitedObject* object = [[AwaitedObject alloc] initAwaitedObject:l1Indicator:enemy];
        [m_AwaitedEnemyList addObject:object];
		[object release];
    } 
}                                                                  


- (void) addBonus:(Bonus*) bonus:(NSUInteger) l1Indicator {
	int speedX = [bonus getSpeedX];
	    
    // We change the object speed according to foreground scrolling.
    if ([m_ScrollingList count] == 1) {
	    speedX = [(Scrolling*)[m_ScrollingList objectAtIndex:0] getSpeed];
	} else if ([m_ScrollingList count] > 0) {
	    speedX = [(Scrolling*)[m_ScrollingList objectAtIndex:([m_ScrollingList count] - 2)] getSpeed];
    }
	
    // If speed is zero we set speed to 1
    [bonus setSpeedX:(speedX?speedX:1)]; 

	// if l1Indicator is same we display bonus
    if (l1Indicator == m_CurrentL1Indicator) {  
       [m_DisplayedBonusList add:bonus];
	} else {
        // else we add to awaited object list.
		AwaitedObject* object = [[AwaitedObject alloc] initAwaitedObject:l1Indicator:bonus];
       [m_AwaitedBonusList addObject:object];
	   [object release];
	} 
  
}
- (void) addObject:(GameObject*) object:(NSUInteger) l1Indicator {
	
	int speedX = [object getSpeedX];
	
	if ([object isKindOfClass:[BonusGenerator class]]) {
	    [(BonusGenerator*) object setLevelStepDisplayedBonusTable: m_DisplayedBonusList];
	}
	
    // We change the object speed according to foreground scrolling.
    if ([m_ScrollingList count] == 1) {
		 speedX = [(Scrolling*)[m_ScrollingList objectAtIndex:0] getSpeed];
	} else if ([m_ScrollingList count] > 0) {
		 speedX = [(Scrolling*)[m_ScrollingList objectAtIndex:([m_ScrollingList count] - 2)] getSpeed];
    }
	
    // If speed is zero we set speed to 1
    [object setSpeedX:(speedX?speedX:1)]; 
	
	// if l1Indicator is same we display object
    if (l1Indicator == m_CurrentL1Indicator) {  
		[m_DisplayedObjectList add:object];
	} else {
		AwaitedObject* obj = [[AwaitedObject alloc] initAwaitedObject:l1Indicator:object];
        // else we add to awaited object list.
		[m_AwaitedObjectList addObject:obj];
		[obj release];
	} 
}

- (void) addScrolling:(Scrolling*) scrolling:(NSUInteger) plan {
	if (plan > [m_ScrollingList count]) {
		[m_ScrollingList addObject:scrolling];
	} else {
		[m_ScrollingList insertObject:scrolling atIndex:plan];
	}
}
- (void) removeDisplayedEnemy {
	// TODO: manage the hande to erase enemy by setting its energy to zero and disappear it.
	NSUInteger count = [m_DisplayedEnemyList getSize];
	for (NSUInteger i = 0; i < count; ++i) {
	    MovingObject* object = (MovingObject*) [m_DisplayedEnemyList get:i];
	    [object setEnergy:0];
		[object explode];
	}
}

- (bool) isFinished {
    return ([m_DisplayedEnemyList  getSize] == 0) && ([m_AwaitedEnemyList  count] == 0) &&
		   ([m_DisplayedObjectList getSize] == 0) && ([m_AwaitedObjectList count] == 0) &&
		   ([m_DisplayedBonusList  getSize] == 0);
}


- (Scrolling*) getScrolling: (NSUInteger) plan {
	return (Scrolling*)[m_ScrollingList objectAtIndex:plan];
}

- (NSUInteger) getScrollingCount {
    return [m_ScrollingList count];
}

- (NSUInteger) getIndicator {
    return m_CurrentL1Indicator;
}

@end
