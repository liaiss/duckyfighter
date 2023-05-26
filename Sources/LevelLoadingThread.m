//
//  LevelLoadingThread.m
//  DuckyFighter
//
//  Created by Liaiss Merzougue on 17/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LevelLoadingThread.h"

#import "Level.h"
#import "EAGLView.h"

@implementation LevelLoadingThread


- (id) initLevelLoadingThread:(LoadingStatusBar*) progressBar {	
	
	if (![super init]) {
		return nil; 
	}
	
	NSLog(@"Loading the level loading thread****************");
    m_Thread = nil;
	m_ProgressBar = progressBar;
	m_View = nil;
    m_CurrentLevelStep = 0;
    m_CurrentLevelIndicator = 0;
	return self;
}

- (void) dealloc {
	[m_LevelName release];
	[m_Thread release]; 
	[super dealloc];
}

- (void) loadLevel {
	NSLog(@"Loading level***********");
	NSAutoreleasePool	 *autoreleasepool = [[NSAutoreleasePool alloc] init];
    [(EAGLView*)m_View  setContext];
    
    [[Level level] loadLevel:m_LevelName:m_ProgressBar:m_DifficultyLevel];
    
  //  [[Level level] stepTo:m_CurrentLevelStep:m_CurrentLevelIndicator:m_PlayerX:m_PlayerY]; 
    m_IsStop = YES;
    
    m_CurrentLevelStep = 0;
    m_CurrentLevelIndicator = 0;
    m_PlayerX = 0;
    m_PlayerY = 0;
    
    [autoreleasepool release];
}	

- (bool) isStop {
	return m_IsStop;
}

- (void) setLevelName:(NSString *)name {
    m_LevelName = name;
	[m_LevelName retain];
}

- (void) setLevelStep: (NSUInteger) levelStep {
    m_CurrentLevelStep = levelStep;
}

- (void) setLevelIndicator: (NSUInteger) levelIndicator {
    m_CurrentLevelIndicator = levelIndicator;
}

- (void) setDifficultyLevel:(NSUInteger) level {
    m_DifficultyLevel = level;
}

- (void) setPlayerPos:(NSInteger) x: (NSInteger) y {
    m_PlayerX = x;
    m_PlayerY = y;
}

- (void) setView: (UIView*) view {
    m_View = view;
}

- (void) freeThread {
    [m_Thread release];
    m_Thread = nil;
}

- (void) start {
    m_IsStop = NO;
    
    m_Thread = [[NSThread alloc] initWithTarget:self selector:@selector(loadLevel) object:nil]; 

    if (m_Thread != nil) {
	    [m_Thread start];
    }
}

@end
