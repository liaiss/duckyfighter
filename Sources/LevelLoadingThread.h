//
//  LevelLoadingThread.h
//  DuckyFighter
//
//  Created by Liaiss Merzougue on 17/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadingStatusBar.h"

@interface LevelLoadingThread : NSObject {
	NSThread* m_Thread;
	NSString* m_LevelName;
    NSUInteger m_CurrentLevelStep;
    NSUInteger m_CurrentLevelIndicator;
    
    NSInteger m_PlayerX;
    NSInteger m_PlayerY;
    
	LoadingStatusBar* m_ProgressBar;
    UIView* m_View;
    
    NSUInteger m_DifficultyLevel;
    
	bool m_IsStop;
}

- (id) initLevelLoadingThread:(LoadingStatusBar*) progressBar;

- (void) setLevelName: (NSString*) name;

- (void) setLevelStep: (NSUInteger) levelStep;

- (void) setLevelIndicator: (NSUInteger) levelIndicator;

- (void) setView: (UIView*) view;

- (void) setDifficultyLevel:(NSUInteger) level;

- (void) setPlayerPos:(NSInteger) x: (NSInteger) y;

- (bool) isStop;

- (void) start;

- (void) loadLevel;

- (void) freeThread;

@end
