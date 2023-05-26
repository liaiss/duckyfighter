//
//  LevelStep.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "Scrolling.h"
#import "PlayerShip.h"
#import "PlayerScore.h"
#import "ObjectTable.h"
#import "StaticObject.h"
#import "GameObject.h"
#import "Bonus.h"
#import "Enemy.h"

@interface LevelStep : NSObject {
   
	NSMutableArray* m_ScrollingList;
	
	ObjectTable* m_DisplayedEnemyList;
	ObjectTable* m_DisplayedBonusList;
	ObjectTable* m_DisplayedObjectList;
	
	NSMutableArray* m_AwaitedEnemyList;
	NSMutableArray* m_AwaitedBonusList;
	NSMutableArray* m_AwaitedObjectList;
	
    NSUInteger m_CurrentL1Indicator;
}

- (id) initLevelStep;

- (void) dealloc;

- (void) update:(NSInteger) x:(NSInteger) y ;

- (void) updateScrolling;

- (void) draw;

- (bool) detectCollision:(PlayerShip*) player:(PlayerScore*) sc;

- (void) drawScrolling:(NSUInteger) Plan;

- (void) addEnemy:(Enemy*) enemy:(NSUInteger) l1Indicator;

- (void) addBonus:(Bonus*) bonus:(NSUInteger) l1Indicator;

- (void) addObject:(GameObject*) object:(NSUInteger) l1Indicator;

- (void) addScrolling:(Scrolling*) scrolling:(NSUInteger) plan;

- (void) removeDisplayedEnemy;
 
- (bool) isFinished;

- (Scrolling*) getScrolling:(NSUInteger) plan;

- (NSUInteger) getScrollingCount;

- (bool) makeTransition;

- (NSUInteger) getIndicator;

@end
