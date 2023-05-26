//
//  Level.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "LevelStep.h"
#import "LoadingStatusBar.h"

@interface Level : NSObject {
	NSMutableArray* m_LevelStepList;
	NSUInteger m_currentLevelStep;
	
	NSMutableArray* m_EnemyInfoList;
	NSMutableArray* m_BonusInfoList;
	NSMutableArray* m_ObjectInfoList;
	NSMutableArray* m_WeaponInfoList;
	
	NSString* m_Name;
	NSString* m_MusicName;
    NSString* m_BossMusicName;
    NSUInteger m_Timing;
    
	Sound* m_Music;
    Sound* m_BossMusic;
	
	NSUInteger m_LevelStartDisplayTimeCount;
    NSUInteger m_WarningDisplayTimeCount;

    NSString* m_WarningSound;

    NSUInteger m_RemainingTime;
    
    CGFloat m_CurrentAlpha;
    
    bool m_isFree;
}

- (id) initLevel:(NSUInteger) levelStepCount;

- (void) dealloc;

- (void) loadLevel:(NSString*) levelFile:(LoadingStatusBar*) progressBar:(NSUInteger) difficultyLevel;

- (void) freeLevel;

- (LevelStep*) getCurrentLevelStep;

- (NSInteger) nextLevelStep;

- (void) setCurrentLevelStep: (NSUInteger) levelStep;

- (bool) updateLevel:(PlayerShip*) ship: (PlayerScore*) score ;

- (Layer*) getWeaponIcon:(NSUInteger) type;

- (Weapon*) createWeapon:(NSUInteger) type: (NSUInteger) weaponClass:(NSInteger) x:(NSInteger) y;

- (Enemy*) createEnemy:(NSUInteger) type:(NSInteger) x:(NSInteger) y;

- (StaticObject*) createObject:(NSUInteger) type:(NSInteger) x:(NSInteger) y;

- (Bonus*) createBonus:(NSUInteger) type:(NSInteger) x:(NSInteger) y;

- (void) setWarningSound: (NSString*) sound;

- (void) removeDisplayedEnemy;

- (void) playMusic;

- (void) playBossMusic;

- (void) stopMusic;

- (bool) draw;

- (void) drawForegroundScrolling;

- (NSUInteger) getRemainingTime;

- (void) stepTo:(NSUInteger)levelStep:(NSUInteger) indicator:(NSInteger) x: (NSInteger) y ;

- (NSUInteger) getIndicator;

+ (Level*) level;

@end
