//
//  Level.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "Level.h"
#import "LevelStep.h"
#import "BonusGenerator.h"
#import "TextManager.h"
#import "ScreenInfo.h"
#import "SoundManager.h"
#import "LayerManager.h"

#define INFO_INIT_COUNT 10
#define MAX_DISPLAY_TIME_COUNT 50
#define MAX_WARNING_DISPLAY_TIME_COUNT 100
#define WARNING_BLINK_TIME 5

@implementation Level

- (id) initLevel:(NSUInteger) levelStepCount{
	
	if (![super init]) {
	    return nil;
	}
	
	m_LevelStepList = [[NSMutableArray alloc] initWithCapacity:levelStepCount];
    LevelStep* lstep = [[LevelStep alloc] initLevelStep];
	[m_LevelStepList addObject:lstep];
    [lstep release];
	
	m_EnemyInfoList  = [[NSMutableArray alloc] initWithCapacity:INFO_INIT_COUNT];
	m_BonusInfoList  = [[NSMutableArray alloc] initWithCapacity:INFO_INIT_COUNT];
	m_ObjectInfoList = [[NSMutableArray alloc] initWithCapacity:INFO_INIT_COUNT];
	m_WeaponInfoList = [[NSMutableArray alloc] initWithCapacity:INFO_INIT_COUNT];
	
	m_currentLevelStep = 0;
	m_Music = nil;
	m_RemainingTime = 0;
    
	return self;
}

- (void) dealloc {
    [m_LevelStepList removeAllObjects];
	[m_LevelStepList release];	
	[m_EnemyInfoList release];
	[m_BonusInfoList release];
	[m_ObjectInfoList release];
	[m_WeaponInfoList release];
	
	[super dealloc];
}

- (void) readBonusDefinition : (NSDictionary*) root: (NSString*) levelFile {
	
	NSArray* bonusTypeDefList; 
	NSDictionary *bonusTypeDef;
    ObjectInfo* info;
	
	// Now we read the bonus type definition list.
	bonusTypeDefList = (NSArray*) [root objectForKey:@"BonusTypeDefinitionList"];
	
	if (bonusTypeDefList == nil) {
	    NSLog(@"Could not read Bonus Type Definition List in %s file.", levelFile);	
		return;
	}
	
	NSUInteger count = [bonusTypeDefList count];
	for (int i = 0; i < count; ++i) {
		bonusTypeDef = (NSDictionary*) [bonusTypeDefList objectAtIndex:i];
		info = [[ObjectInfo alloc] initObjectInfo];
		
		// Read SpeedX
		NSNumber* speedX = (NSNumber*) [bonusTypeDef objectForKey:@"SpeedX"];
		[info setSpeedX:[speedX intValue]];
		
		// Read Impact
		NSNumber* impact = (NSNumber*) [bonusTypeDef objectForKey:@"Impact"];
		[info setImpact:[impact unsignedIntValue]];
		
		// Read Energy
		NSNumber* energy = (NSNumber*) [bonusTypeDef objectForKey:@"Energy"];
		[info setEnergy:[energy unsignedIntValue]];
		
		// Read TimeCountPerFrame
		NSNumber* timeCountPerFrame = (NSNumber*) [bonusTypeDef objectForKey:@"TimeCountPerFrame"];
		[info setTimeCountPerFrame:[timeCountPerFrame unsignedIntValue]];
		
		// Read TimeCountPerFrame
		NSNumber* type = (NSNumber*) [bonusTypeDef objectForKey:@"TypeID"];
		[info setObjectType:[type unsignedIntValue]];
		
		// Read LoopFrameStart
		NSNumber* loopFrameStart = (NSNumber*) [bonusTypeDef objectForKey:@"LoopFrameStart"];
		[info setLoopFrameStart:[loopFrameStart unsignedIntValue]];	
		
		// Read SoundFile
		NSString* sound = (NSString*) [bonusTypeDef objectForKey:@"Sound"];
		[info setSound:sound];
		
		// Read Resource name.
		NSArray* resourceData = (NSArray*) [bonusTypeDef objectForKey:@"ResourceData"];
		[info setResourcesUp:resourceData];
		
		[m_BonusInfoList addObject:info];
		[info release];
	}
}

- (void) readObjectDefinition : (NSDictionary*) root: (NSString*) levelFile:(NSUInteger) difficultyLevel {
	
	NSArray* objectTypeDefList; 
	NSDictionary *objectTypeDef;
	ObjectInfo* info;
	
	// Now we read the object type definition list.
	objectTypeDefList = (NSArray*) [root objectForKey:@"ObjectTypeDefinitionList"];
	
	if (objectTypeDefList == nil) {
	    NSLog(@"Could not read Object Type Definition List in %s file.", levelFile);	
		return;
	}
	
	NSUInteger count = [objectTypeDefList count];
	for (int i = 0; i < count; ++i) {
		objectTypeDef = (NSDictionary*) [objectTypeDefList objectAtIndex:i];
		info = [[ObjectInfo alloc] initObjectInfo];
		
		// Read SpeedX
		NSNumber* speedX = (NSNumber*) [objectTypeDef objectForKey:@"SpeedX"];
		[info setSpeedX:[speedX intValue]];
		
		// Read Impact
		NSNumber* impact = (NSNumber*) [objectTypeDef objectForKey:@"Impact"];
		[info setImpact:([impact unsignedIntValue]*difficultyLevel)];
		
		// Read Energy
		NSNumber* energy = (NSNumber*) [objectTypeDef objectForKey:@"Energy"];
		[info setEnergy:([energy unsignedIntValue]*difficultyLevel)];
		
		// Read TimeCountPerFrame
		NSNumber* timeCountPerFrame = (NSNumber*) [objectTypeDef objectForKey:@"TimeCountPerFrame"];
		[info setTimeCountPerFrame:[timeCountPerFrame unsignedIntValue]];
		
		// Read LoopFrameStart
		NSNumber* loopFrameStart = (NSNumber*) [objectTypeDef objectForKey:@"LoopFrameStart"];
		[info setLoopFrameStart:[loopFrameStart unsignedIntValue]];		
		
		// Read ObjectType
		NSNumber* objectType = (NSNumber*) [objectTypeDef objectForKey:@"ObjectType"];
		[info setObjectType:[objectType unsignedIntValue]];
		
		// Read Resource name.
		NSArray* resourceData = (NSArray*) [objectTypeDef objectForKey:@"ResourceData"];
		[info setResourcesUp:resourceData];
		
		[m_ObjectInfoList addObject:info];
		[info release];
	}
}

- (void) readWeaponDefinition : (NSDictionary*) root: (NSString*) levelFile:(NSUInteger) difficultyLevel {
	
	NSArray* weaponTypeDefList; 
	NSDictionary *weaponTypeDef;
    ObjectInfo* info;
	
	// Now we read the weapon type definition list.
	weaponTypeDefList = (NSArray*) [root objectForKey:@"WeaponTypeDefinitionList"];
	
	if (weaponTypeDefList == nil) {
	    NSLog(@"Could not read Weapon Type Definition List in %s file.", levelFile);	
		return;
	}
	
	NSUInteger count = [weaponTypeDefList count];
	for (int i = 0; i < count; ++i) {
		weaponTypeDef = (NSDictionary*) [weaponTypeDefList objectAtIndex:i];
		info = [[ObjectInfo alloc] initObjectInfo];
		
		// Read SpeedX
		NSNumber* speedX = (NSNumber*) [weaponTypeDef objectForKey:@"SpeedX"];
		[info setSpeedX:[speedX intValue]];
		
		// Read SpeedY
		NSNumber* speedY = (NSNumber*) [weaponTypeDef objectForKey:@"SpeedY"];
		[info setSpeedY:[speedY intValue]];
		
		// Read Impact
		NSNumber* impact = (NSNumber*) [weaponTypeDef objectForKey:@"Impact"];
		[info setImpact:[impact unsignedIntValue]];
		
		// Read Energy
		NSNumber* energy = (NSNumber*) [weaponTypeDef objectForKey:@"Energy"];
		[info setEnergy:([energy unsignedIntValue]*difficultyLevel)];
		
		// Read SoundFile
		NSString* sound = (NSString*) [weaponTypeDef objectForKey:@"Sound"];
		[info setSound:sound];
		
        // Read IconFile
		NSString* icon = (NSString*) [weaponTypeDef objectForKey:@"Icon"];
		[info setIcon:icon];
        
		// Read MoveFile
		NSString* moveFile = (NSString*) [weaponTypeDef objectForKey:@"MoveFile"];
		[info setMoveFile:moveFile];
		
		// Read TimeCountPerFrame
		NSNumber* timeCountPerFrame = (NSNumber*) [weaponTypeDef objectForKey:@"TimeCountPerFrame"];
		[info setTimeCountPerFrame:[timeCountPerFrame unsignedIntValue]];
		
		// Read LoopFrameStart
		NSNumber* loopFrameStart = (NSNumber*) [weaponTypeDef objectForKey:@"LoopFrameStart"];
		[info setLoopFrameStart:[loopFrameStart unsignedIntValue]];
		
		// Read Resource name.
		NSDictionary* resourceData = (NSDictionary*) [weaponTypeDef objectForKey:@"ResourceData"];
		
		[info setResourcesLeft:(NSArray*) [resourceData objectForKey:@"ResourceLeft"]];
		[info setResourcesRight:(NSArray*) [resourceData objectForKey:@"ResourceRight"]];
		[info setResourcesUp:(NSArray*) [resourceData objectForKey:@"ResourceUp"]];
		[info setResourcesDown:(NSArray*) [resourceData objectForKey:@"ResourceDown"]];
		[info setResourcesFire:(NSArray*) [resourceData objectForKey:@"ResourceFire"]];
		[info setResourcesExplode:(NSArray*) [resourceData objectForKey:@"ResourceExplode"]];	
		
		[m_WeaponInfoList addObject:info];
		[info release];
	}
}

- (void) readEnemyDefinition : (NSDictionary*) root: (NSString*) levelFile:(NSUInteger) difficultyLevel {
	
	NSArray* enemyTypeDefList; 
	NSDictionary *enemyTypeDef;
	ObjectInfo* info;
	
	// Now we read the enemy type definition list.
	enemyTypeDefList = (NSArray*) [root objectForKey:@"EnemyTypeDefinitionList"];
	
	if (enemyTypeDefList == nil) {
	    NSLog(@"Could not read Enemy Type Definition List in %s file.", levelFile);	
		return;
	}
	
	NSUInteger count = [enemyTypeDefList count];
	for (int i = 0; i < count; ++i) {
		enemyTypeDef = (NSDictionary*) [enemyTypeDefList objectAtIndex:i];
		info = [[ObjectInfo alloc] initObjectInfo];
		
		// Read SpeedX
		NSNumber* speedX = (NSNumber*) [enemyTypeDef objectForKey:@"SpeedX"];
		[info setSpeedX:[speedX intValue]];
		
		// Read SpeedY
		NSNumber* speedY = (NSNumber*) [enemyTypeDef objectForKey:@"SpeedY"];
		[info setSpeedY:[speedY intValue]];
		
		// Read Impact
		NSNumber* impact = (NSNumber*) [enemyTypeDef objectForKey:@"Impact"];
		[info setImpact:([impact unsignedIntValue]*difficultyLevel)];
		
		// Read Energy
		NSNumber* energy = (NSNumber*) [enemyTypeDef objectForKey:@"Energy"];
		[info setEnergy:([energy unsignedIntValue]*difficultyLevel)];
		
		// Read TimeCountPerFrame
		NSNumber* timeCountPerFrame = (NSNumber*) [enemyTypeDef objectForKey:@"TimeCountPerFrame"];
		[info setTimeCountPerFrame:[timeCountPerFrame unsignedIntValue]];
		
		// Read LoopFrameStart
		NSNumber* loopFrameStart = (NSNumber*) [enemyTypeDef objectForKey:@"LoopFrameStart"];
		[info setLoopFrameStart:[loopFrameStart unsignedIntValue]];
		
		// Read SoundFile
		NSString* sound = (NSString*) [enemyTypeDef objectForKey:@"Sound"];
		[info setSound:sound];
		NSLog(@"Load Sound file: %@", sound);
		
		// Read MoveFile
		NSString* moveFile = (NSString*) [enemyTypeDef objectForKey:@"MoveFile"];
		[info setMoveFile:moveFile];
		NSLog(@"Load Move file: %@", moveFile);
		
		NSNumber* weapon = (NSNumber*) [enemyTypeDef objectForKey:@"Weapon"];
		[info setWeapon:[weapon unsignedIntValue]];
		
		NSNumber* weaponPower = (NSNumber*) [enemyTypeDef objectForKey:@"WeaponPower"];
		[info setWeaponPower:[weaponPower unsignedIntValue]];
		
        NSNumber* weaponDirection = (NSNumber*) [enemyTypeDef objectForKey:@"WeaponDirection"];
		[info setWeaponDirection:[weaponDirection unsignedIntValue]];
        
        NSNumber* weaponX = (NSNumber*) [enemyTypeDef objectForKey:@"WeaponX"];
        [info setWeaponX:[weaponX unsignedIntValue]];
        
        NSNumber* weaponY = (NSNumber*) [enemyTypeDef objectForKey:@"WeaponY"];
        [info setWeaponY:[weaponY unsignedIntValue]];
		
        // Read Resource name.
		NSDictionary* resourceData = (NSDictionary*) [enemyTypeDef objectForKey:@"ResourceData"];
		
		[info setResourcesLeft:(NSArray*) [resourceData objectForKey:@"ResourceLeft"]];
		[info setResourcesRight:(NSArray*) [resourceData objectForKey:@"ResourceRight"]];
		[info setResourcesUp:(NSArray*) [resourceData objectForKey:@"ResourceUp"]];
		[info setResourcesDown:(NSArray*) [resourceData objectForKey:@"ResourceDown"]];
		[info setResourcesFire:(NSArray*) [resourceData objectForKey:@"ResourceFire"]];	
		[info setResourcesExplode:(NSArray*) [resourceData objectForKey:@"ResourceExplode"]];	
        
		[m_EnemyInfoList addObject:info];
		[info release];
	}
}

- (void) readScrolling:(NSDictionary*) root: (NSString*) levelFile {
	
	NSArray* scrollingList; 
	NSDictionary *scrollingElement;
	Scrolling* scrolling;
	scrollingList = (NSArray*) [root objectForKey:@"ScrollingList"];
	
	if (scrollingList == nil) {
	    NSLog(@"Could not read Game Element List in %s file.", levelFile);	
		return;
	}
	
	NSUInteger count = [scrollingList count];
	
	for (int i = 0; i < count; ++i) {
		scrollingElement = (NSDictionary*) [scrollingList objectAtIndex:i];
		
		// Read TypeID
		NSString* resourceName = (NSString*) [scrollingElement objectForKey:@"ResourceName"];
		
		// Read LevelStep
		NSNumber* levelStepID = (NSNumber*) [scrollingElement objectForKey:@"LevelStep"];
		
		while ([levelStepID intValue] >= [m_LevelStepList count]) {
			LevelStep* lstep = [[LevelStep alloc] initLevelStep];
			[m_LevelStepList addObject:lstep];
			[lstep release];
		}
		
		// Read Speed
		NSNumber* speed = (NSNumber*) [scrollingElement objectForKey:@"Speed"];
		
		// Read Z
		NSNumber* z = (NSNumber*) [scrollingElement objectForKey:@"Z"];
		
		LevelStep* levelStep = [m_LevelStepList objectAtIndex:[levelStepID intValue]];
		
		scrolling = [[Scrolling alloc] initScrolling:resourceName:[speed intValue]:NO:1];
		[levelStep addScrolling:scrolling:[z intValue]];
		[scrolling release];
	}
}

- (void) readLevelStep:(NSDictionary*) root : (NSString*) levelFile {
	
	NSArray* gameElementList; 
	NSDictionary *gameElement;
	NSInteger currentSpacing;
	
	// Now we read the GameElementList
	gameElementList = (NSArray*) [root objectForKey:@"GameElementList"];
	
	if (gameElementList == nil) {
	    NSLog(@"Could not read Game Element List in %s file.", levelFile);	
		return;
	}
	
	NSUInteger count = [gameElementList count];
	for (int i = 0; i < count; ++i) {
		gameElement = (NSDictionary*) [gameElementList objectAtIndex:i];
		
		// Read TypeID
		NSNumber* typeID = (NSNumber*) [gameElement objectForKey:@"TypeID"];
		
		// Read LevelStep
		NSNumber* levelStepID = (NSNumber*) [gameElement objectForKey:@"LevelStep"];
		
		while ([levelStepID intValue] >= [m_LevelStepList count]) {
			LevelStep* lstep = [[LevelStep alloc] initLevelStep];
			[m_LevelStepList addObject:lstep];
			[lstep release];
		}
		
		// Read LevelIndicator
		NSNumber* levelIndicator = (NSNumber*) [gameElement objectForKey:@"LevelIndicator"];
		
		// Read Element Class name one of the following : Object, Enemy, Weapon, Bonus.
		NSString* className = (NSString*) [gameElement objectForKey:@"Class"];
		
		// Read X
		NSNumber* x = (NSNumber*) [gameElement objectForKey:@"X"];
		
		// Read Y
		NSNumber* y = (NSNumber*) [gameElement objectForKey:@"Y"];
		
		// Read count
		NSNumber* count = (NSNumber*) [gameElement objectForKey:@"Count"];
		
		// Read count
		NSNumber* spacing = (NSNumber*) [gameElement objectForKey:@"Spacing"];
		
		currentSpacing = [levelIndicator intValue];
		
        // Read count
		NSString* specificMoveFile = (NSString*) [gameElement objectForKey:@"MoveFile"];
		
		currentSpacing = [levelIndicator intValue];
        
		LevelStep* levelStep = [m_LevelStepList objectAtIndex:[levelStepID intValue]];
		NSObject* object;
		
		for (int j = 0; j < [count intValue]; ++j) {
			
			if ([className isEqualToString:@"Enemy"]) {
				object = [[Level level] createEnemy:[typeID intValue]:[x intValue] :[y intValue]];
                
                if ((specificMoveFile != nil) && ([specificMoveFile length] > 0)) {
                    [(Enemy*)object loadMoveFile:specificMoveFile];
                }
                
			    [levelStep addEnemy:(Enemy*)object:currentSpacing];
				[object release];
		    } else if ([className isEqualToString:@"Object"]) {
				object = [[Level level] createObject:[typeID intValue]:[x intValue] :[y intValue]];
			    [levelStep addObject:(GameObject*) object:currentSpacing];
				[object release];
		    } else if ([className isEqualToString:@"Bonus"]) {
				object = [[Level level] createBonus:[typeID intValue]:[x intValue] :[y intValue]];
			    [levelStep addBonus:(Bonus*)object:currentSpacing];
				[object release];
		    }
			
			currentSpacing += [spacing intValue];
		}
	}
}

- (void) loadLevel:(NSString*) levelFile:(LoadingStatusBar*) progressBar:(NSUInteger) difficultyLevel {	
	NSDictionary *levelDescription;
    NSBundle *bundle;
	NSString* resourcePath;
	NSNumber* timing;
    
	bundle = [NSBundle mainBundle];
	resourcePath = [bundle pathForResource:levelFile ofType:@"plist"];
	levelDescription = [[NSDictionary alloc] initWithContentsOfFile:resourcePath]; 
	
	if (levelDescription == nil) {
	    NSLog(@"Could not read bundle %s at %s.", levelFile, resourcePath);	
		return;
	}
	
	[progressBar reset];
	
    [progressBar setProgress:5];
    
	// Read the level name.
	m_Name = (NSString*) [levelDescription objectForKey:@"LevelName"];
	[m_Name retain];

	m_MusicName = (NSString*) [levelDescription objectForKey:@"Music"];
	[m_MusicName retain];
    
    m_BossMusicName = (NSString*) [levelDescription objectForKey:@"BossMusic"];
	[m_BossMusicName retain];
    
	m_Music = [[SoundManager soundManager] getSound:m_MusicName:MUSIC_EXTENSION:NO];
    
    m_BossMusic = [[SoundManager soundManager] getSound:m_BossMusicName:MUSIC_EXTENSION:NO];
    
    timing = (NSNumber*) [levelDescription objectForKey:@"Timing"];
    m_Timing = [timing unsignedIntValue];
    
	NSLog(@"At 10 percent");
	[progressBar setProgress:10];
    
	//NSLog(@"At 11 percent");
    
	// Read Bonus Definitions
	[self readBonusDefinition:levelDescription:levelFile];
    
	NSLog(@"At 20 percent");
    [progressBar setProgress:20];
	
	// Read Object definitions
	[self readObjectDefinition:levelDescription:levelFile:difficultyLevel];
	    
	NSLog(@"At 30 percent");
	[progressBar setProgress:30];
	
	// Read Weapons definitions
	[self readWeaponDefinition:levelDescription:levelFile:difficultyLevel];
	
	NSLog(@"At 40 percent");
	[progressBar setProgress:40];
	
	// Read Enemy definitions
	[self readEnemyDefinition:levelDescription:levelFile:difficultyLevel];
	
	NSLog(@"At 50 percent");
	[progressBar setProgress:50];
	
	m_currentLevelStep = 0;
	
	// Read Scrolling
	[self readScrolling:levelDescription:levelFile];
		
    NSLog(@"At 70 percent");
	[progressBar setProgress:70];

	m_currentLevelStep = 0;
	
    [self readLevelStep:levelDescription:levelFile];
	    
	NSLog(@"At 90 percent");
	[progressBar setProgress:90];

	
	m_LevelStartDisplayTimeCount = 0;
	m_WarningDisplayTimeCount = 0;
    m_WarningSound = nil;
    
	NSLog(@"At 100 percent");
	[progressBar setProgress:100];
	
     m_isFree = NO;
    
	[levelDescription release];
}


- (LevelStep*) getCurrentLevelStep {
    return [m_LevelStepList objectAtIndex:m_currentLevelStep];
}

- (LevelStep*) getLevelStep:(NSUInteger) levelStep {
    return [m_LevelStepList objectAtIndex:levelStep];
}

- (NSInteger) nextLevelStep {
      
    if (![(LevelStep*)[m_LevelStepList objectAtIndex:m_currentLevelStep] isFinished]) {
        return 1;
	}
	
    ++m_currentLevelStep;
	
    if ( m_currentLevelStep >= [m_LevelStepList count] ) {	    
		return 0;
    } /*else {
        NSUInteger scrollingCount = [[self getCurrentLevelStep] getScrollingCount];
		
        for (unsigned int plan = 0; plan < scrollingCount; ++plan) {
            Scrolling* oldScrolling =  [[self getLevelStep:(m_currentLevelStep - 1)] getScrolling:plan];
            Scrolling* currentScrolling = [[self getCurrentLevelStep] getScrolling:plan];

		}
    } */
    
    return 1;
}

- (bool) updateLevel: (PlayerShip*) ship: (PlayerScore*) score {
	
	if (m_LevelStartDisplayTimeCount < MAX_DISPLAY_TIME_COUNT) {
        ++m_LevelStartDisplayTimeCount;
		return NO;
	}
	
	// Get the current LevelStep
	if (m_currentLevelStep < [m_LevelStepList count]) {
	 
        if (m_currentLevelStep == ([m_LevelStepList count] - 1)) {
            if (m_WarningDisplayTimeCount == 0) {
                [self playBossMusic];
            }
            
            if (m_WarningDisplayTimeCount < (MAX_WARNING_DISPLAY_TIME_COUNT)) {
                ++m_WarningDisplayTimeCount;
                return NO;
            }
        }
        
        LevelStep* current = [m_LevelStepList objectAtIndex:m_currentLevelStep];
		
		[current detectCollision:ship:score];
	    [current update:[ship getXMin]:[ship getYMin]];
        
		return NO;
	}

	return YES;
}


- (bool) draw {
	CGSize dimension;
	
	dimension.width = 200;
	dimension.height = 50;
	
	if (m_currentLevelStep < [m_LevelStepList count]) {
	    LevelStep* current = [m_LevelStepList objectAtIndex:m_currentLevelStep];
		
	    [current draw];
		
        if (m_currentLevelStep == ([m_LevelStepList count] - 1)) {
            if (m_WarningDisplayTimeCount < MAX_DISPLAY_TIME_COUNT) {
                [current updateScrolling];
                if (((m_WarningDisplayTimeCount % WARNING_BLINK_TIME) == 0) ||
                    ((m_WarningDisplayTimeCount % WARNING_BLINK_TIME) == 1)) {
                    //TODO: play warning sound.
                    [[TextManager textManager] setColor:0.7 :0.2 :0.2 :1.0];
                    [[TextManager textManager] setStroke:YES];
                    [[TextManager textManager] drawText:@"WARNING !!!":dimension :26 :([[ScreenInfo screenInfo] getWidth] / 2) - (dimension.width / 2):[[ScreenInfo screenInfo] getHeight] / 2];
                    [[TextManager textManager] setColor:0.0 :0.0 :0.0 :1.0];
                    [[TextManager textManager] setStroke:NO];
                }
            }
        }
        
		if (m_LevelStartDisplayTimeCount < MAX_DISPLAY_TIME_COUNT) {
            [current updateScrolling];
            [[TextManager textManager] setColor:0.7 :0.2 :0.2 :1.0];
            [[TextManager textManager] setStroke:YES];
			[[TextManager textManager] drawText:m_Name :dimension :26 :([[ScreenInfo screenInfo] getWidth] / 2) - (dimension.width / 2):[[ScreenInfo screenInfo] getHeight] / 2];
		    [[TextManager textManager] setColor:0.0 :0.0 :0.0 :1.0];
            [[TextManager textManager] setStroke:NO];
        }
		
	    if ([current isFinished]) {
            if ([current makeTransition]) {
                m_currentLevelStep++;
            }
		    
	    }
		
		return NO;
	} 
    
    LevelStep* current = [m_LevelStepList objectAtIndex:m_currentLevelStep - 1];
		
    [current draw];
    [current updateScrolling];
        
    return YES;
    
}

- (void) drawForegroundScrolling {
	if (m_currentLevelStep < [m_LevelStepList count]) {
	    LevelStep* current = [m_LevelStepList objectAtIndex:m_currentLevelStep];
		NSUInteger count = [current getScrollingCount];
		
		if (count >= 2) {
		    [current drawScrolling:[current getScrollingCount] - 1];
		}
	} /*else if (m_LevelEndDisplayTimeCount < MAX_DISPLAY_TIME_COUNT) {
	    LevelStep* current = [m_LevelStepList objectAtIndex:m_currentLevelStep-1];
		
		NSUInteger count = [current getScrollingCount];
		
		if (count >= 2) {
		    [current drawScrolling:[current getScrollingCount] - 1];
		}
	} */
}

- (void) setWarningSound: (NSString*) sound {
    m_WarningSound = sound; 
}

- (void) setCurrentLevelStep: (NSUInteger) levelStep {
    m_currentLevelStep = levelStep;
}

- (NSUInteger) getRemainingTime {
    return m_RemainingTime;
}

- (void) freeLevel {
    NSLog(@"FreeLevel");
    
    if (!m_isFree) {
        // Stop the music.
        [self stopMusic];
	    // Free all Level Step.
	    [m_LevelStepList removeAllObjects];
        // Recreate level step for the next cycle.
	    LevelStep* lstep =[[LevelStep alloc] initLevelStep];
	    [m_LevelStepList addObject: lstep];
        [lstep release];
	    m_currentLevelStep = 0;
        m_WarningDisplayTimeCount = 0;

	    // Free all Enemy
	    [m_EnemyInfoList removeAllObjects];

	    // Free all Bonus
	    [m_BonusInfoList removeAllObjects];

	    // Free all Object
	    [m_ObjectInfoList removeAllObjects];

	    // Free all Weapon
	    [m_WeaponInfoList removeAllObjects];

	     // Free Sound and Image Layer.
        [[LayerManager layerManager] clearLayerManager];
	    [[SoundManager soundManager] clearSoundManager];

        // Free retained string.
	    [m_Name release];
	    [m_MusicName release];
        [m_BossMusicName release];
 
        m_isFree = YES;
	}
}

- (void) playMusic {
	[m_Music play:YES];
}

- (void) playBossMusic {
	[m_Music stop];
    [m_BossMusic play:YES];
}

- (void) stopMusic { 
    [m_Music stop];
    [m_BossMusic stop];
}

+ (Level*) level {
    static Level *instance = nil;
	
    if (instance == nil) {
        instance = [[Level alloc] initLevel:10];
    }
	
    return instance;
}


- (Weapon*) createWeapon:(NSUInteger) type:(NSUInteger) weaponClass:(NSInteger) x:(NSInteger) y {
	ObjectInfo* info = [m_WeaponInfoList objectAtIndex:type];
	Weapon* weapon;
	
    weapon = [[Weapon alloc] initWeapon:info :weaponClass];
	
	[weapon setX:x];
	[weapon setY:y];
	
	return weapon;
}

- (Layer*) getWeaponIcon:(NSUInteger) type {
	ObjectInfo* info = [m_WeaponInfoList objectAtIndex:type];
	Layer* layer = nil;
	
    layer = [[LayerManager layerManager] getLayerWithoutShadow:[info getIcon]:NO];
    
	return layer;
}

- (Enemy*) createEnemy:(NSUInteger) type:(NSInteger) x:(NSInteger) y {
	ObjectInfo* info = [m_EnemyInfoList objectAtIndex:type];
	
	[info setXPos:x];
	[info setYPos:y];
	
    return [[Enemy alloc] initEnemy:info];
}

- (StaticObject*) createObject:(NSUInteger) type:(NSInteger) x:(NSInteger) y {
	ObjectInfo* info = [m_ObjectInfoList objectAtIndex:type];
	
    StaticObject* object;
	
	switch ([info getObjectType]) {
			
		case STATIC_OBJECT_DEFAULT_TYPE: object = [[StaticObject alloc] initStaticObject:info];
			break;
	    case STATIC_OBJECT_BONUS_GENERATOR_TYPE: object = [[BonusGenerator alloc] initBonusGenerator:info];
			break;
		default: return nil;
	} 
	
	[object setX:x];
	[object setY:y];
	
	return object;
}

- (Bonus*) createBonus:(NSUInteger) type:(NSInteger) x:(NSInteger) y {
	ObjectInfo* info = [m_BonusInfoList objectAtIndex:type];
	
	[info setXPos:x];
	[info setYPos:y];
	
   return [[Bonus alloc] initBonus:info:type];
}

- (void) removeDisplayedEnemy {
	[[m_LevelStepList objectAtIndex:m_currentLevelStep] removeDisplayedEnemy];
}

- (NSUInteger) getIndicator {
    NSUInteger indicator = 0;
    
    if (m_currentLevelStep < [m_LevelStepList count]) {
        LevelStep* levelStep = [m_LevelStepList objectAtIndex:m_currentLevelStep];
        indicator = [levelStep getIndicator]; 
    } 
    
    return indicator;
}

- (void) stepTo:(NSUInteger)levelStep:(NSUInteger) indicator:(NSInteger) x: (NSInteger) y {
  /*  if (levelStep < [m_LevelStepList count]) {
        if ((levelStep != 0) || (indicator != 0)) {
            m_currentLevelStep = levelStep;
        
            m_LevelStartDisplayTimeCount = MAX_DISPLAY_TIME_COUNT;
        
            LevelStep* lStep = (LevelStep*) [m_LevelStepList objectAtIndex:m_currentLevelStep];
        
            NSUInteger ind = [lStep getIndicator]; 
        
            // Before update reduce sound volume and music volume.
            CGFloat musicVolume = [[SoundManager soundManager] getVolume:YES];
            CGFloat soundVolume = [[SoundManager soundManager] getVolume:NO];
            
            [[SoundManager soundManager] setMusicVolume:0.0];
            [[SoundManager soundManager] setSoundVolume:0.0];
            
            while (ind < indicator) {
                [lStep update: x: y];
                ind = [lStep getIndicator]; 
            }
            
            [[SoundManager soundManager] setMusicVolume:musicVolume];
            [[SoundManager soundManager] setSoundVolume:soundVolume];
        }
    }    */ 
}

@end
