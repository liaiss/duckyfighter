//  
//  DuckyFighterViewController.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 17/08/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#import "DuckyFighterViewController.h"
#import "ScreenInfo.h"
#import "ScreenView.h"
#import "Util.h"
#import "TextManager.h"
#import "LayerManager.h"
#import "SoundManager.h"
#import "EAGLView.h"

#define ACCELEROMETER_ERR_PERCENT 3
#define FILTERING_FACTOR 0.3
#define NAME_LENGTH 3
#define SELECTED_FONT_SIZE 36
#define UNSELECTED_FONT_SIZE 30
#define MAX_DISPLAY_TIME_COUNT 50

#define ALLOWED_CHAR_COUNT 40

char playerName[NAME_LENGTH] = {'A', 'A', 'A'};
char AllowedChar[ALLOWED_CHAR_COUNT] = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 
                                        'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1',
                                        '2', '3', '4', '5', '6', '7', '8', '9', '.', '-' , '_', ' ' };

@implementation DuckyFighterViewController


enum {
	GAME_INTRO_STATE = 0,
	GAME_MENU_STATE = 1, 
	GAME_LOAD_PLAY_STATE = 2,
	GAME_PLAY_STATE = 3,
	GAME_END_PLAY_STATE = 4,
    GAME_ENTER_NAME_STATE = 5
};

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"View will appear");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	NSLog(@"seams to be memleak");
	// Release any cached data, images, etc that aren't in use.
}

- (void) viewDidLoad {
    NSLog(@"View did load");
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

- (void) performFinalization {
    NSLog(@"Save settings");
    [m_Menu saveSettings];
    
    NSLog(@"Save hiscore");
    [[Hiscores hiscores] saveHiScore];
    
    NSLog(@"Save game");
    [self saveGame];
    
   // Don't call [self dealloc] to use fast switch of ios4.
}

- (void)dealloc {
	[m_Player release];
	[m_PlayerShipInfo release];	
	[m_PlayerSatInfo release];	
	[m_RefreshThread stop];
	[m_RefreshThread release];
	[m_LevelResourceList release];
    
    [m_Menu release];
    [m_BackgroundImage release];
    [m_TitleSound release];
    [m_GameOverFirstSoundName release];
    [m_GameOverSecondSoundName release];
    [m_ClickSound release];
    [m_ValidateSound release];
    
	[[LayerManager layerManager] clearLayerManager];
	[[LayerManager layerManager] clearReservedLayerManager];
	[[SoundManager soundManager] clearSoundManager];
	[[SoundManager soundManager] clearReservedSoundManager];
	  
    [super dealloc];
}

- (void) freeGame {	
    [[Level level] freeLevel];
    m_CurrentLevelStep = 0;
    m_CurrentLevelIndicator = 0;
    m_CurrentLevelIndex = 0;
	[m_RefreshThread stop]; 
	[m_RefreshThread release];
}

- (void) initGame {
	m_CurrentLevel = nil;
	
	m_NewX = 0;
	m_NewY = 0;
	m_AverageX = 0;
	m_AverageY = 0;
	m_StartPosX = -1000;
	m_StartPosY = -1000;
	m_Count = 0;
    
    m_CurrentAccelX = 0.0;
    m_CurrentAccelY = 0.0;
	
    m_AccelX = 0.0;
    m_AccelY = 0.0;
    
    m_DefaultAccelX = 0.0;
    m_DefaultAccelY = 0.0;
    
	m_MovieStarted = NO;
	m_FirstLevelLoaded = NO;
	m_CurrentLevelIndex = 0;
    m_CurrentLevelStep = 0;
    m_CurrentLevelIndicator = 0;
    m_CurrentAllowedChar = 0;
    
    m_IsPlayingGameOverFirstSound = NO;
    m_IsPlayingGameOverSecondSound = NO;
    
	m_OnPause = NO;
    
	[[UIAccelerometer sharedAccelerometer] setDelegate:self];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:0.035];
    
	m_RefreshThread = [[DisplayRefreshThread alloc] initRefreshThread:m_View];

	NSLog(@"Game is initialized");
}

- (void) loadGame {
	
	NSBundle* bundle;
	NSString* resourcePath;
	
	bundle = [NSBundle mainBundle];
	resourcePath = [bundle pathForResource:@"GameDescription" ofType:@"plist"];
	m_GameDescription = [[NSDictionary alloc] initWithContentsOfFile:resourcePath];  
    
    // Read SoundFile
	m_TitleSound = (NSString*) [m_GameDescription objectForKey:@"TitleSound"];
    [m_TitleSound retain];
    
    m_GameOverFirstSoundName = (NSString*) [m_GameDescription objectForKey:@"GameOverFirstSound"];
    [m_GameOverFirstSoundName retain];

    m_GameOverSecondSoundName = (NSString*) [m_GameDescription objectForKey:@"GameOverSecondSound"];
    [m_GameOverSecondSoundName retain];
    
    m_LevelClearedFirstSoundName = (NSString*) [m_GameDescription objectForKey:@"LevelClearedFirstSound"];
    [m_LevelClearedFirstSoundName retain];
    
    m_LevelClearedSecondSoundName = (NSString*) [m_GameDescription objectForKey:@"LevelClearedFirstSound"];
    [m_LevelClearedSecondSoundName retain];
    
    m_WarningSoundName = (NSString*) [m_GameDescription objectForKey:@"WarningSound"];
    [m_WarningSoundName retain];

    
    // Read  background
	m_BackgroundImage = (NSString*) [m_GameDescription objectForKey:@"BackgroundImage"];
    [m_BackgroundImage retain];
    
    [[Hiscores hiscores] loadHiScore];
}

- (void) startGame {
   	[self initGame];
	
	m_GameState = GAME_INTRO_STATE;
	
	[self loadGame];
}

- (void) loadMenuInfo {
	
	NSDictionary* menuInfo;

	NSString* sound;
    NSString* clickSound;
	NSString* music;
	NSNumber* startX;
	NSNumber* startY;
	
	// Now we read the bonus type definition list.
	menuInfo = (NSDictionary*) [m_GameDescription objectForKey:@"MenuInfo"];
    
	if (menuInfo == nil) {
	    NSLog(@"Could not read Menu information in GameDescription.plist file.");	
		return;
	}
	
	// Read SoundFile
	sound = (NSString*) [menuInfo objectForKey:@"Sound"];
    
    // Read SoundFile
	clickSound = (NSString*) [menuInfo objectForKey:@"ClickSound"];
    
	// Read SoundFile
	music = (NSString*) [menuInfo objectForKey:@"Music"];
	
	// Read StartX
	startX = (NSNumber*) [menuInfo objectForKey:@"StartX"];
	
	// Read StartY
	startY = (NSNumber*) [menuInfo objectForKey:@"StartY"];
	
	m_Menu = [[GameMenu alloc] initGameMenu:m_BackgroundImage:sound:music:clickSound:m_Player:[startX intValue]:[startY intValue]];
	[m_Menu setViewController:self];
    
	m_LoadingStatus = [[LoadingStatusBar alloc] initLoadingStatusBar:[m_PlayerShipInfo getResourcesRight]:m_BackgroundImage:@"Loading"];
    
    m_ClickSound = clickSound;
    [m_ClickSound retain];
    
    m_ValidateSound = sound;
    [m_ValidateSound retain];
}

- (void) loadSatInfo:(NSInteger) x:(NSInteger) y {
	NSDictionary* satInfo;
	
	NSNumber* speedX;
	NSNumber* speedY;
    NSNumber* weaponX;
	NSNumber* weaponY;
	NSNumber* impact;
	NSNumber* energy;
	NSNumber* timeCountPerFrame;
	NSNumber* isReserved;
	NSDictionary* resourceData;
	
	satInfo = (NSDictionary*) [m_GameDescription objectForKey:@"SatInfo"];
	
	if (satInfo == nil) {
	    NSLog(@"Could not read Player Sat ship information in GameDescription.plist file.");	
		return;
	}
	
	m_PlayerSatInfo = [[ObjectInfo alloc] initObjectInfo];
	[m_PlayerSatInfo setXPos:x];
	[m_PlayerSatInfo setYPos:y];
	
	// Read SpeedX
	speedX = (NSNumber*) [satInfo objectForKey:@"SpeedX"];
	[m_PlayerSatInfo setSpeedX:[speedX intValue]];
	
	// Read SpeedY
	speedY = (NSNumber*) [satInfo objectForKey:@"SpeedY"];
	[m_PlayerSatInfo setSpeedY:[speedY intValue]];
	
	// Read Impact
	impact = (NSNumber*) [satInfo objectForKey:@"Impact"];
	[m_PlayerSatInfo setImpact:[impact unsignedIntValue]];
	
	// Read Energy
	energy = (NSNumber*) [satInfo objectForKey:@"Energy"];
	[m_PlayerSatInfo setEnergy:[energy unsignedIntValue]];
	
    // Read weaponX
	weaponX = (NSNumber*) [satInfo objectForKey:@"WeaponX"];
	[m_PlayerSatInfo setWeaponX:[weaponX unsignedIntValue]];
    
    // Read weaponX
	weaponY = (NSNumber*) [satInfo objectForKey:@"WeaponY"];
	[m_PlayerSatInfo setWeaponY:[weaponY unsignedIntValue]];
    
	// Read TimeCountPerFrame
	timeCountPerFrame = (NSNumber*) [satInfo objectForKey:@"TimeCountPerFrame"];
	[m_PlayerSatInfo setTimeCountPerFrame:[timeCountPerFrame unsignedIntValue]];
	
	isReserved = (NSNumber*) [satInfo objectForKey:@"ReservedResource"];
	[m_PlayerSatInfo setReservedResource:[isReserved boolValue]];
	
	// Read Resource .
	resourceData = (NSDictionary*) [satInfo objectForKey:@"ResourceData"];
	
	[m_PlayerSatInfo setResourcesLeft:(NSArray*) [resourceData objectForKey:@"ResourceLeft"]];
	[m_PlayerSatInfo setResourcesRight:(NSArray*) [resourceData objectForKey:@"ResourceRight"]];
	[m_PlayerSatInfo setResourcesUp:(NSArray*) [resourceData objectForKey:@"ResourceUp"]];
	[m_PlayerSatInfo setResourcesDown:(NSArray*) [resourceData objectForKey:@"ResourceDown"]];
	[m_PlayerSatInfo setResourcesFire:(NSArray*) [resourceData objectForKey:@"ResourceFire"]];
}

- (void) loadPlayerInfo {
	
	NSDictionary* playerInfo;
	
	NSNumber* x;
	NSNumber* y;
	NSNumber* speedX;
	NSNumber* speedY;
    NSNumber* weaponX;
	NSNumber* weaponY;
	NSNumber* impact;
	NSNumber* energy;
	NSNumber* lifeCount;
	NSNumber* timeCountPerFrame;
	NSString* sound;
	NSNumber* isReserved;
	NSDictionary* resourceData;
	
	// Now we read the bonus type definition list.
	playerInfo = (NSDictionary*) [m_GameDescription objectForKey:@"PlayerInfo"];
    
	if (playerInfo == nil) {
	    NSLog(@"Could not read Player ship information in GameDescription.plist file.");	
		return;
	}
	
	m_PlayerShipInfo = [[ObjectInfo alloc] initObjectInfo];
	// Read  X
	x = (NSNumber*) [playerInfo objectForKey:@"X"];
	[m_PlayerShipInfo setXPos:[x intValue]];
	
	// Read Y
	y = (NSNumber*) [playerInfo objectForKey:@"Y"];
	[m_PlayerShipInfo setYPos:[y intValue]];
	
	// Read SpeedX
	speedX = (NSNumber*) [playerInfo objectForKey:@"SpeedX"];
	[m_PlayerShipInfo setSpeedX:[speedX intValue]];
	
	// Read SpeedY
	speedY = (NSNumber*) [playerInfo objectForKey:@"SpeedY"];
	[m_PlayerShipInfo setSpeedY:[speedY intValue]];
	
	// Read Impact
	impact = (NSNumber*) [playerInfo objectForKey:@"Impact"];
	[m_PlayerShipInfo setImpact:[impact unsignedIntValue]];
	
	// Read Energy
	energy = (NSNumber*) [playerInfo objectForKey:@"Energy"];
	[m_PlayerShipInfo setEnergy:[energy unsignedIntValue]];
	
    // Read weaponX
	weaponX = (NSNumber*) [playerInfo objectForKey:@"WeaponX"];
	[m_PlayerShipInfo setWeaponX:[weaponX unsignedIntValue]];
    
    // Read weaponX
	weaponY = (NSNumber*) [playerInfo objectForKey:@"WeaponY"];
	[m_PlayerShipInfo setWeaponY:[weaponY unsignedIntValue]];
    
	// Read Energy
	lifeCount = (NSNumber*) [playerInfo objectForKey:@"LifeCount"];
	
	// Read TimeCountPerFrame
	timeCountPerFrame = (NSNumber*) [playerInfo objectForKey:@"TimeCountPerFrame"];
	[m_PlayerShipInfo setTimeCountPerFrame:[timeCountPerFrame unsignedIntValue]];
	
	// Read SoundFile
	sound = (NSString*) [playerInfo objectForKey:@"Sound"];
	[m_PlayerShipInfo setSound:sound];
	
	isReserved = (NSNumber*) [playerInfo objectForKey:@"ReservedResource"];
	[m_PlayerShipInfo setReservedResource:[isReserved boolValue]];
	
	// Read Resource .
	resourceData = (NSDictionary*) [playerInfo objectForKey:@"ResourceData"];
	
	[m_PlayerShipInfo setResourcesLeft:(NSArray*) [resourceData objectForKey:@"ResourceLeft"]];
	[m_PlayerShipInfo setResourcesRight:(NSArray*) [resourceData objectForKey:@"ResourceRight"]];
	[m_PlayerShipInfo setResourcesUp:(NSArray*) [resourceData objectForKey:@"ResourceUp"]];
	[m_PlayerShipInfo setResourcesDown:(NSArray*) [resourceData objectForKey:@"ResourceDown"]];
	[m_PlayerShipInfo setResourcesFire:(NSArray*) [resourceData objectForKey:@"ResourceFire"]];
	[m_PlayerShipInfo setResourcesMissile:(NSArray*) [resourceData objectForKey:@"ResourceMissile"]];
    [m_PlayerShipInfo setResourcesExplode:(NSArray*) [resourceData objectForKey:@"ResourceDestroy"]];
	NSUInteger lfcount = [lifeCount unsignedIntValue];
	
	[self loadSatInfo:[x intValue]: [y intValue]];
	
	m_Player = [[PlayerShip alloc] initPlayerShip:m_PlayerShipInfo:m_PlayerSatInfo:lfcount];
}

- (void) loadVideo {
	// Now we read the intro video type definition list.
	m_IntroVideoFile = (NSString*) [m_GameDescription objectForKey:@"IntroVideo"];
	[m_IntroVideoFile retain];
}

- (void) loadStatusBar {
	NSString* buttons;
	NSString* energyFullIcon;
	NSString* energyLowIcon;
	NSString* energyEmptyIcon;
	NSString* lifeIcon;
	
	// Now we read the bonus type definition list.
	buttons = (NSString*) [m_GameDescription objectForKey:@"ButtonsIcon"];
	
	// Now we read the bonus type definition list.
	lifeIcon = (NSString*) [m_GameDescription objectForKey:@"LifeIcon"];
	
	// Now we read the bonus type definition list.
	energyFullIcon = (NSString*) [m_GameDescription objectForKey:@"EnergyFullIcon"];
	
	// Now we read the bonus type definition list.
	energyLowIcon = (NSString*) [m_GameDescription objectForKey:@"EnergyLowIcon"];
	
	// Now we read the bonus type definition list.
	energyEmptyIcon = (NSString*) [m_GameDescription objectForKey:@"EnergyEmptyIcon"];
	
	m_PlayerScore = [[PlayerScore alloc] initScore:0];
	m_PlayerStatus = [[PlayerStatus alloc] initPlayerStatus:buttons:energyFullIcon:energyLowIcon:
											energyEmptyIcon:lifeIcon:[m_Player getEnergyMax]];
}

- (void) loadTextManager {
	
	NSString* fontName = (NSString*) [m_GameDescription objectForKey:@"FontName"];
	[[TextManager textManager] setFont:fontName];
}

- (void) loadLevelList {

	m_LevelResourceList = (NSArray*) [m_GameDescription objectForKey:@"LevelList"];
	[m_LevelResourceList retain];
	// The Game Description is useless now.
	[m_GameDescription release];
}

- (void) loadGameData {
    [self loadTextManager];
    [self loadPlayerInfo];
    [self loadMenuInfo];
    [self loadStatusBar];
    [self loadLevelList];
    m_LevelLoader = [[LevelLoadingThread alloc] initLevelLoadingThread:m_LoadingStatus];
    [m_LevelLoader setView:(EAGLView*)m_View];
    
    [m_Menu loadSettings];
    m_GameState = GAME_MENU_STATE;
	m_MovieStarted = NO;
    m_IsTitleSoundPlayed = NO;
    m_IsMenuMusicPlaying = NO;
}

// When the movie is done,release the controller. 
-(void)movieFinishedCallback {
	[[NSNotificationCenter defaultCenter] removeObserver:self 
													name:MPMoviePlayerPlaybackDidFinishNotification 
												  object:nil]; 
	
	// Release the movie instance created in playMovieAtURL
	[m_IntroMovie release];
	[m_IntroVideoFile release];
    
    [self loadGameData];
	
	NSLog(@"Playback is finished");
}

- (void) introHandle {
	
	/*if (!m_MovieStarted) {
		[self loadVideo];
		
		NSString * path =[[NSBundle mainBundle] pathForResource:m_IntroVideoFile ofType:@"m4v"];
		NSURL* url = [NSURL fileURLWithPath:path];
		
		m_IntroMovie =[[MPMoviePlayerController alloc] initWithContentURL:url]; 
		m_IntroMovie.scalingMode=MPMovieScalingModeAspectFill; 
		m_IntroMovie.movieControlMode=MPMovieControlModeDefault;
		
		// Register for the playback finished notification. 
		
		[[NSNotificationCenter defaultCenter] addObserver:self 
												 selector:@selector(movieFinishedCallback) 
													 name:MPMoviePlayerPlaybackDidFinishNotification 
												   object:nil]; 
		
		// Movie playback is asynchronous, so this method returns immediately. 
		[m_IntroMovie play];
		
       
        
		m_MovieStarted = YES; 
	} */
    [self loadVideo];
    [self loadGameData];
}

-(void) menuHandle {
	NSInteger x = [(EAGLView*) m_View getX];
	NSInteger y = [(EAGLView*) m_View getY];
	BOOL touchValidate = [(EAGLView*) m_View isTouchValidate];
	
    
	switch ([m_Menu updateMenu:x :y :touchValidate]) {
		case NEW_GAME_MENU_ITEM: 
            if ([(EAGLView*) m_View fadeOut]) {
                [(EAGLView*) m_View resetFade];
                m_GameState = GAME_LOAD_PLAY_STATE;
                m_LevelEndDisplayTimeCount = 0;
                [m_View setMultipleTouchEnabled:[m_Menu isUseAccelerometer]];
                [m_LevelLoader setDifficultyLevel:[m_Menu getDifficulty]];
                [m_LevelLoader setLevelName:[m_LevelResourceList objectAtIndex:m_CurrentLevelIndex]]; 
                m_CurrentLevelStep = 0;
                m_CurrentLevelIndicator = 0;
                [m_LevelLoader setLevelStep:m_CurrentLevelStep];
                [m_LevelLoader setLevelIndicator:m_CurrentLevelIndicator];
                [m_LevelLoader setPlayerPos:[m_Player getXMin]:[m_Player getYMin]];
                // In case of new game reset ship information and score.
                [m_Player resetShip];
                [m_PlayerScore setScore:0];
                [m_LevelLoader loadLevel];
              //  [m_LevelLoader start];
            }
			break;
        case CONTINUE_GAME_MENU_ITEM: 
            if ([(EAGLView*) m_View fadeOut]) {
                [(EAGLView*) m_View resetFade];
                m_LevelEndDisplayTimeCount = 0;
                m_GameState = GAME_LOAD_PLAY_STATE;
                [self loadSavedGame];
                [m_View setMultipleTouchEnabled:[m_Menu isUseAccelerometer]];
                [m_LevelLoader setDifficultyLevel:[m_Menu getDifficulty]];
                [m_LevelLoader setLevelName:[m_LevelResourceList objectAtIndex:m_CurrentLevelIndex]]; 
                [m_LevelLoader setLevelStep:m_CurrentLevelStep];
                [m_LevelLoader setLevelIndicator:m_CurrentLevelIndicator];
                [m_LevelLoader setPlayerPos:[m_Player getXMin]:[m_Player getYMin]];
                [m_LevelLoader loadLevel];
                //[m_LevelLoader start];
            }
			break;
		case SETTINGS_MENU_ITEM:
			break;
		case CREDITS_MENU_ITEM:
			break;
		default: 
			break;
	}
    
    Sound* titleSound = [[SoundManager soundManager] getSound:m_TitleSound:SOUND_EXTENSION:NO];
    
    if (!m_IsTitleSoundPlayed) {
        
        [titleSound play:NO];
        
        m_IsTitleSoundPlayed = YES;
    } else {

        if ((!m_IsMenuMusicPlaying) && (![titleSound isPlaying])) {
     
           [m_Menu playMusic];
            m_IsMenuMusicPlaying = YES;
        } 
    }
    
}

- (void) loadHandle {

   // if ([(EAGLView*)m_View fadeIn]) {
        
        [m_LoadingStatus  updateStatus];
        
        if ([m_LevelLoader isStop]) {
               [(EAGLView*) m_View setContext];
               [NSThread sleepForTimeInterval:2.0];
            //if ([(EAGLView*) m_View fadeOut]) { 
            //    [(EAGLView*) m_View resetFade];
                [m_LevelLoader freeThread];
                [m_Menu stopMusic];
                [[Level level] setWarningSound:m_WarningSoundName];
                [[Level level] playMusic];
                
                // Reset ship coordinate.
                [m_Player setX:[[ScreenInfo screenInfo] getWidth]/2 - [m_Player getWidth]/2];
                [m_Player setY:[[ScreenInfo screenInfo] getHeight]/2 - [m_Player getHeight]/2];
                [(EAGLView*) m_View resetButton];
                
                m_SavedScore = [m_PlayerScore getScore];
                m_SavedLifeCount = [m_Player getLifeCount];
                m_SavedWeaponPower = [m_Player getFirePower];
                m_SavedCurrentWeapon = [m_Player getCurrentWeapon];
                m_SavedMissilePower = [m_Player getMissilePower];
                m_SavedCurrentMissile = [m_Player getCurrentMissile];
                m_SavedShield = [m_Player getShield];
                m_SavedEnergy = [m_Player getEnergy];
                m_SavedX = [m_Player getXMin];
                m_SavedY = [m_Player getYMin];
                
                m_OnPause = NO;
                m_GameState = GAME_PLAY_STATE;
           //}
	    }
   // }
}

- (bool) manageLevelCleared {
    CGSize dimension;
    bool isFinished = NO;
    
    dimension.width = 200;
	dimension.height = 50;
    
    if (!m_IsPlayingLevelClearedFirstSound)
    {    
        m_CurrentAlpha = 1.0f;

        m_FirstLevelClearedSound = [[SoundManager soundManager] getSound:m_LevelClearedFirstSoundName:SOUND_EXTENSION:NO];
        
        [m_FirstLevelClearedSound play:NO];
        
        m_IsPlayingLevelClearedFirstSound = YES;
        
    } else {
        
        if ((!m_IsPlayingLevelClearedSecondSound) && (![m_FirstLevelClearedSound isPlaying])) {
            
            m_SecondLevelClearedSound = [[SoundManager soundManager] getSound:m_LevelClearedSecondSoundName:SOUND_EXTENSION:NO];
            
            [m_SecondLevelClearedSound play:NO]; 
            
            m_IsPlayingLevelClearedSecondSound = YES;
        } else if ((m_IsPlayingLevelClearedSecondSound) && (![m_SecondLevelClearedSound isPlaying])) {
            
            [[TextManager textManager] setColor:0.7f :0.2f :0.2f : m_CurrentAlpha];
            m_CurrentAlpha -= 0.1f;
        }
    }
    
    // Display all the time the game over but start reduce alpha blending when two sound is finished.
    
    if (m_LevelEndDisplayTimeCount < MAX_DISPLAY_TIME_COUNT) {
        ++m_LevelEndDisplayTimeCount;
	} else {
        
        if (m_CurrentAlpha < 0.0)
        {               
            isFinished = YES;
        } else {
            m_CurrentAlpha -= 0.1f;
            [[TextManager textManager] setColor:0.7f :0.2f :0.2f : m_CurrentAlpha];
        }
        
    }
    
    [[TextManager textManager] setStroke:YES];
    [[TextManager textManager] drawText:@"LEVEL CLEARED" :dimension :30 :([[ScreenInfo screenInfo] getWidth] / 2) - (dimension.width / 2) :[[ScreenInfo screenInfo] getHeight] / 2];
    [[TextManager textManager] setStroke:NO];
    
    return isFinished;
}


-(void) gameHandle {
    if ((!m_OnPause) && ([m_PlayerStatus isPaused:[(EAGLView*) m_View getX]:[(EAGLView*)m_View getY]] && [(EAGLView*) m_View isTouchValidate])) {
        m_OnPause = YES;
    } 
    
    if (!m_OnPause) {
        
        if ([(EAGLView*) m_View isAButtonPressed]) {
            [m_Player fire];
        }
        
        if (([(EAGLView*) m_View isBButtonPressed] && [m_Menu isUseAccelerometer]) ||
            ([(EAGLView*) m_View isShaked] && (![m_Menu isUseAccelerometer]))){
            [m_Player launchMissile];
        }
        
        [self manageTouchControl];
        
        [m_Player moveWeapon];
    
        [[Level level] updateLevel:m_Player:m_PlayerScore];
    } else {
        if (![(EAGLView*) m_View isTouchValidate]) {
            m_OnPause = NO;
        }
    }
}

- (void) enterNameHandle {
    CGSize dimension;
    
    NSInteger newX = 0;
	NSInteger newY = [[ScreenInfo screenInfo] getHeight];
    NSInteger x = [(EAGLView*) m_View getX];
    NSInteger y = [(EAGLView*) m_View getY];
    bool validate = [(EAGLView*) m_View isTouchValidate];
    
    dimension.width = 300;
	dimension.height = 50;
    
    
    if ([m_PlayerScore getScore] > [[Hiscores hiscores] getLowScore]) {
       // if ([(EAGLView*) m_View fadeIn]) {
            
            Layer* background = [[LayerManager layerManager] getLayerWithoutShadow:m_BackgroundImage: YES];
            Sound* validateSound = [[SoundManager soundManager] getSound:m_ValidateSound:SOUND_EXTENSION:YES];
            Sound* clickSound = [[SoundManager soundManager] getSound:m_ClickSound:SOUND_EXTENSION:YES];
            
            [background draw:0:0];
            
            newX = ([[ScreenInfo screenInfo] getWidth] / 2) - (dimension.width / 2);
            newY -= 2 * dimension.height;
            
            [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
            [[TextManager textManager] drawText:@"Congratulation!":dimension:SELECTED_FONT_SIZE :newX: newY];
            
            newX = ([[ScreenInfo screenInfo] getWidth] / 2) - (dimension.width / 2);
            newY -= dimension.height;
            
            [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
            [[TextManager textManager] drawText:@"You got an High score.":dimension:UNSELECTED_FONT_SIZE :newX: newY];
            
            dimension.height = 40;
            newX = ([[ScreenInfo screenInfo] getWidth] / 2) - (dimension.width / 2);
            newY -= dimension.height * 2;
            
            [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
            [[TextManager textManager] drawText:@"Enter your name":dimension:SELECTED_FONT_SIZE :newX: newY];
            
            newY -= dimension.height; 
            dimension.width = 50;
            newX = ([[ScreenInfo screenInfo] getWidth] / 2) - ((dimension.width * 3) / 2);
            
            for (NSInteger i = 0; i < NAME_LENGTH; ++i) {
                NSString* characters = [[NSString alloc] initWithFormat:@"%c", playerName[i]];
                
                if ((y >= newY) && (y <= (newY + dimension.height)) && 
                    (x >= newX) && (x <= (newX + dimension.width))) {
                    [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
                    [[TextManager textManager] drawText:characters:dimension:SELECTED_FONT_SIZE :newX: newY];
                    if (!validate) {
                        m_CurrentAllowedChar++;
                        m_CurrentAllowedChar %= ALLOWED_CHAR_COUNT;
                        playerName[i] = AllowedChar[m_CurrentAllowedChar];
                        [clickSound play:NO];
                    }
                } else {
                    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
                    [[TextManager textManager] drawText:characters:dimension:UNSELECTED_FONT_SIZE :newX: newY];
                }
                
                [characters release];
                newX += dimension.width;
            }
            
            dimension.width = 40;
            dimension.height = 40;
            newX = ([[ScreenInfo screenInfo] getWidth] / 2) - (dimension.width / 2);
            newY = 10;
            
            [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
            
            if ((y >= newY) && (y <= (newY + dimension.height)) && 
                (x >= newX) && (x <= (newX + dimension.width))) {
                if (validate) {
                    if ([(EAGLView*) m_View fadeOut]) {
                        [validateSound play:NO];
                        // TODO: manage name properly with a loop.
                        NSString* name = [[NSString alloc] initWithFormat:@"%c%c%c", playerName[0], playerName[1], playerName[2]];
                        [[Hiscores hiscores] addScore:name:[m_PlayerScore getScore]];
                        [name release];
                        [(EAGLView*) m_View resetFade];
                        m_GameState = GAME_END_PLAY_STATE;
                    }
                }
                [[TextManager textManager] drawText:@"OK":dimension:SELECTED_FONT_SIZE :newX: newY];
            } else {
                [[TextManager textManager] drawText:@"OK":dimension:UNSELECTED_FONT_SIZE :newX: newY];
            }
        //}
    } else {
        m_GameState = GAME_END_PLAY_STATE;   
    }
}

- (void) displayEndOfLiteVersion {
    CGSize dimension;
    
    NSInteger newX = 0;
	NSInteger newY = [[ScreenInfo screenInfo] getHeight];
    NSInteger x = [(EAGLView*) m_View getX];
    NSInteger y = [(EAGLView*) m_View getY];
    bool validate = [(EAGLView*) m_View isTouchValidate];
    
    dimension.width = 350;
	dimension.height = 50;
    
    // if ([(EAGLView*) m_View fadeIn]) {
    
    Layer* background = [[LayerManager layerManager] getLayerWithoutShadow:m_BackgroundImage: YES];
    Sound* validateSound = [[SoundManager soundManager] getSound:m_ValidateSound:SOUND_EXTENSION:YES];
    
    [background draw:0:0];
    
    newX = ([[ScreenInfo screenInfo] getWidth] / 2) - (dimension.width / 2);
    newY -= 2 * dimension.height;
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    [[TextManager textManager] drawText:@"Thank you for playing to":dimension:SELECTED_FONT_SIZE :newX: newY];
    
    newX = ([[ScreenInfo screenInfo] getWidth] / 2) - (dimension.width / 2);
    newY -= dimension.height;
    
    [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
    [[TextManager textManager] drawText:@"Ducky Fighter Lite.":dimension:SELECTED_FONT_SIZE :newX: newY];
    
    dimension.height = 40;
    newX = ([[ScreenInfo screenInfo] getWidth] / 2) - (dimension.width / 2);
    newY -= dimension.height * 2;
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    
    if ((y >= newY) && (y <= (newY + dimension.height)) && 
        (x >= newX) && (x <= (newX + dimension.width))) {
        if (validate) {
            if ([(EAGLView*) m_View fadeOut]) {
                [validateSound play:NO];
                
                NSLog(@"FreeGame");
                [self freeGame];
                
                NSLog(@"Reset button");
                [(EAGLView*)m_View resetButton];
                
                NSLog(@"init Game");
                [self initGame];
                
                NSLog(@"Reset Menu");
                [m_Menu resetSelected];
                
                NSLog(@"Reset Player");
                [m_Player resetShip];
                
                NSLog(@"Reset Score");
                [m_PlayerScore setScore:0];
                
                NSLog(@"Start Menu music");
                [m_Menu playMusic];
                
                //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=79DC22TQ38.com.handmadegames.DuckyFighter"]];
                
                m_GameState = GAME_MENU_STATE;
            }
        }
        [[TextManager textManager] drawText:@"Get the full version.":dimension:SELECTED_FONT_SIZE :newX: newY];
    } else {
        [[TextManager textManager] drawText:@"Get the full version.":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    }
    //}
} 


-(void) endHandle {
#ifdef __LITE_VERSION__    
    [self displayEndOfLiteVersion];
#else    
    NSLog(@"FreeGame");
    [self freeGame];
    
    NSLog(@"Reset button");
    [(EAGLView*)m_View resetButton];
    
    NSLog(@"init Game");
    [self initGame];
    
    NSLog(@"Reset Menu");
    [m_Menu resetSelected];
    
    NSLog(@"Reset Player");
    [m_Player resetShip];
    
    NSLog(@"Reset Score");
    [m_PlayerScore setScore:0];
    
    NSLog(@"Start Menu music");
    [m_Menu playMusic];    
    
	// We skip intro sequence for the next time.
	m_GameState = GAME_MENU_STATE;
#endif /* __LITE_VERSION__ */
}

-(void) mainLoop {
	switch (m_GameState) {
		case GAME_INTRO_STATE: [self introHandle];
			break;
		case GAME_MENU_STATE: [self menuHandle];
			break;
		case GAME_LOAD_PLAY_STATE: [self loadHandle];
			break;
		case GAME_PLAY_STATE: 
            [self gameHandle];
			break;
		case GAME_END_PLAY_STATE: [self endHandle];
			break;
        case GAME_ENTER_NAME_STATE: [self enterNameHandle];
            break;
		default : // TODO: Error management
			break;
	}
}

- (void) manageGameOver {
    CGSize dimension;
    
    dimension.width = 200;
	dimension.height = 50;
    
    if (!m_IsPlayingGameOverFirstSound)
    {    
        m_CurrentAlpha = 1.0f;
    
        m_FirstGameOverSound = [[SoundManager soundManager] getSound:m_GameOverFirstSoundName:SOUND_EXTENSION:NO];
    
        [m_FirstGameOverSound play:NO];
        
        m_IsPlayingGameOverFirstSound = YES;
        
    } else {
       if ((!m_IsPlayingGameOverSecondSound) && (![m_FirstGameOverSound isPlaying])) {
          
           m_SecondGameOverSound = [[SoundManager soundManager] getSound:m_GameOverSecondSoundName:SOUND_EXTENSION:NO];
          
           [m_SecondGameOverSound play:NO]; 
           
           m_IsPlayingGameOverSecondSound = YES;
       } else if ((m_IsPlayingGameOverSecondSound) && (![m_SecondGameOverSound isPlaying])) {
           // when is Finished
           [[TextManager textManager] setColor:0.7f :0.2f :0.2f : m_CurrentAlpha];
           m_CurrentAlpha -= 0.1f;
       }
    }
        
  // Display all the time the game over but start reduce alpha blending when two sound is finished.
    [[TextManager textManager] setStroke:YES];
    [[TextManager textManager] drawText:@"GAME OVER" :dimension :30 :([[ScreenInfo screenInfo] getWidth] / 2) - (dimension.width / 2) :[[ScreenInfo screenInfo] getHeight] / 2];
    [[TextManager textManager] setStroke:NO];
    
    if (m_CurrentAlpha < 0.0)
    {   
        if ([(EAGLView*) m_View fadeOut]) {
            
            m_IsPlayingGameOverFirstSound = NO;
            m_IsPlayingGameOverSecondSound = NO;
            m_CurrentAlpha = 1.0;
            [[TextManager textManager] setColor:0.0f :0.0f :0.0f : m_CurrentAlpha];
            [(EAGLView*) m_View resetFade];
            m_GameState = GAME_ENTER_NAME_STATE;
        }
    }
}

- (void) drawGameHandle {
	CGSize dimension;
	
	dimension.width = 200;
	dimension.height = 50;
    
    if (![[Level level] draw]) {
        
        if (m_GameState == GAME_PLAY_STATE) {
	
            if ([m_Player getLifeCount] < 0) {
                  [[TextManager textManager] setColor:0.7f :0.2f :0.2f : m_CurrentAlpha];
                  [self manageGameOver];
                  return;
            }

            [m_Player draw];
        }
        
        [[Level level] drawForegroundScrolling];
        [m_PlayerStatus setWeapon:[m_Player getCurrentWeapon]];
        [m_PlayerStatus update:m_PlayerScore :[m_Player getLifeCount] :[m_Player getEnergy]];
    } else {
        // Level is finished managed level cleared display
        [[TextManager textManager] setColor:0.7f :0.2f :0.2f : m_CurrentAlpha];

        if ([self manageLevelCleared]) {
            if ([(EAGLView*) m_View fadeOut])
            {
                m_LevelEndDisplayTimeCount = 0;
                m_CurrentAlpha = 1.0;
                [[TextManager textManager] setColor:0.0f :0.0f :0.0f : m_CurrentAlpha];
                m_IsPlayingLevelClearedFirstSound = NO;
                m_IsPlayingLevelClearedSecondSound = NO;
                [(EAGLView*) m_View resetFade];
                m_CurrentLevelIndex++;
                
                // Level is finished, get the next one
                if (m_CurrentLevelIndex < [m_LevelResourceList count]) {
                    [[Level level]freeLevel];
                    [m_LevelLoader setLevelName:[m_LevelResourceList objectAtIndex:m_CurrentLevelIndex]];
                    [m_LevelLoader start];
                    m_GameState = GAME_LOAD_PLAY_STATE;
                } else {
                    // If no more level is available 
                    // go to the end game state.
                    m_GameState = GAME_ENTER_NAME_STATE;
                }
                [(EAGLView*) m_View resetFade];
            }
        }        
    }

 	
    if (m_OnPause) {
        dimension.width = 120;
        dimension.height = 80;
        [[TextManager textManager] setColor:0.0:0.0:0.0:0.5];
        [[TextManager textManager] drawText:@"||" :dimension :110 :([[ScreenInfo screenInfo]  getWidth] / 2) - (dimension.width  / 2) :
                                                                   ([[ScreenInfo screenInfo] getHeight] / 2) - (dimension.height / 2)];
        [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    }
    
}


-(void) draw {
	switch (m_GameState) {
		case GAME_INTRO_STATE:
			break;
		case GAME_MENU_STATE: 
			break;
		case GAME_PLAY_STATE: [self drawGameHandle];
			break;
		case GAME_END_PLAY_STATE: 
			break;
		default : // TODO: Error management
			break;
	}
}


- (void) update {
	[self mainLoop];
}


- (void) setView:(UIView*) view {
    m_View = view;
}

- (CGFloat) getAccelX {
    return m_CurrentAccelX;
}

- (CGFloat) getAccelY {
    return m_CurrentAccelY;
}

- (void) setDefaultAccelX: (CGFloat) accelX {
    m_DefaultAccelX = accelX;
}

- (void) setDefaultAccelY: (CGFloat) accelY{
    m_DefaultAccelY = accelY;
}

- (void) manageTouchControl {
    NSInteger x, y;
    NSInteger currentX, currentY;
    NSInteger newX, newY;
    NSInteger speedX, speedY;
    
    if (![m_Menu isUseAccelerometer]) {
        currentX = ([m_Player getXMax] + [m_Player getXMin])/ 2;
        currentY = ([m_Player getYMax] + [m_Player getYMin])/ 2;

        x = [(EAGLView*) m_View getMovedX];
        y = [(EAGLView*) m_View getMovedY];
        
        if (currentX > x) {
            if (currentX > ([m_Player getWidth] / 2)) { 
                [m_Player moveLeft];
                speedX = [m_Player getSpeedX];
                newX = currentX - ((( (currentX - x) / speedX) + ((currentX - x)%speedX?1:0)) *speedX);
                [(EAGLView*) m_View setMovedX:newX];
            }
        } else if (currentX < x) {
            if (currentX < [[ScreenInfo screenInfo] getWidth] - ([m_Player getWidth]/2)) { 
                [m_Player moveRight];
                speedX = [m_Player getSpeedX];
                newX = currentX + ((( (x - currentX) / speedX) + ((x - currentX)%speedX?1:0)) *speedX);
                [(EAGLView*) m_View setMovedX:newX];
            }
        }
		
        if (currentY < y) {
            if (currentY < [[ScreenInfo screenInfo] getHeight] - ([m_Player getHeight]/2)) { 
                [m_Player moveUp];
                speedY = [m_Player getSpeedY];
                newY = currentY + ((( (y - currentY) / speedY) + ((y - currentY)%speedY?1:0)) *speedY);
                [(EAGLView*) m_View setMovedY:newY];
            }
        } else if (currentY > y) {
            if (currentY > ([m_Player getHeight]/2)) { 
                [m_Player moveDown];
                speedY = [m_Player getSpeedY];
                newY = currentY - ((( (currentY - y) / speedY) + ((currentY - y)%speedY?1:0)) *speedY);
                [(EAGLView*) m_View setMovedY:newY];
            }
        }
    }
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	NSInteger x, y;
    CGFloat currentAccelX;
    CGFloat currentAccelY;
    CGFloat coeffX = 1.0; // m_DefaultAccelX > 0.0?1.0:-1.0;
    CGFloat coeffY = 1.0; // m_DefaultAccelY > 0.0?1.0:-1.0;
    
    if ([m_Menu isUseAccelerometer] && !m_OnPause) {
        m_CurrentAccelX = acceleration.x;
        m_CurrentAccelY = acceleration.y;
        
        currentAccelX = m_CurrentAccelX - m_DefaultAccelX;
        currentAccelY = m_CurrentAccelY - m_DefaultAccelY;
        
        m_AccelX = currentAccelX - ( (currentAccelX * FILTERING_FACTOR) + (m_AccelX * (1.0 - FILTERING_FACTOR)) );
        m_AccelY = currentAccelY - ( (currentAccelY * FILTERING_FACTOR) + (m_AccelY * (1.0 - FILTERING_FACTOR)) );
        
        // NSLog(@"Display accel: %f, %f", m_AccelX, m_AccelY);
		
        x = ([m_Player getXMax] + [m_Player getXMin])/ 2;
        y = ([m_Player getYMax] + [m_Player getYMin])/ 2;
		
        if ((m_AccelY * coeffY) > 0.0 + (1.0/(2.0 * [m_Menu getAccelerometerSensitivity]))) {
            if (x > ([m_Player getWidth] / 2)) { 
                [m_Player moveLeft];
            }
        }
		
        if ((m_AccelY * coeffY) < 0.0 - (1.0/(2.0 * [m_Menu getAccelerometerSensitivity]))) {
            if (x < [[ScreenInfo screenInfo] getWidth] - ([m_Player getWidth]/2)) { 
                [m_Player moveRight];
            }
        }
		
        if ((m_AccelX * coeffX) > 0.0 + (1.0/(2.0 * [m_Menu getAccelerometerSensitivity]))) {
            if (y < [[ScreenInfo screenInfo] getHeight] - ([m_Player getHeight]/2)) { 
                [m_Player moveUp];
            }
        }
		
        if ((m_AccelX * coeffX) < 0.0 - (1.0/(2.0 * [m_Menu getAccelerometerSensitivity]))) {
            if (y > ([m_Player getHeight]/2)) { 
                [m_Player moveDown];
            }
        }
    }
}

- (void) loadSavedGame {
    
    NSData *data;
    NSString *error;
    NSPropertyListFormat format;
    NSNumber* currentLevel;
    NSNumber* currentIndicator;
    NSNumber* currentLevelStep;
    NSDictionary* propertyList;
    NSNumber* score;
    NSNumber* lifeCount;
    NSNumber* energy;
    NSNumber* playerX;
    NSNumber* playerY;
    NSNumber* currentWeapon;
    NSNumber* currentMissile;
    NSNumber* weaponPower;
    NSNumber* missilePower;
    NSNumber* shield;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"savedGame.plist"];
    data = [[NSData alloc] initWithContentsOfFile:appFile];
    
    if (!data) {
        NSLog(@"Data file not returned.");
    } else {
        
        propertyList = (NSDictionary*) [NSPropertyListSerialization propertyListFromData:data  mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
        
        if (!propertyList){
            NSLog(@"Plist not returned, error: %@", error);
        }
        
        // Get field read from settings.plist file
        
        currentLevel = (NSNumber*) [propertyList objectForKey:@"CurrentLevel"];
        m_CurrentLevelIndex = [currentLevel unsignedIntValue];
        
        currentLevelStep = (NSNumber*) [propertyList objectForKey:@"CurrentLevelStep"];
        m_CurrentLevelStep = [currentLevelStep unsignedIntValue];
        
        currentIndicator = (NSNumber*) [propertyList objectForKey:@"CurrentIndicator"];
        m_CurrentLevelIndicator =[currentIndicator unsignedIntValue];
        
        score = (NSNumber*) [propertyList objectForKey:@"Score"];
        [m_PlayerScore setScore:[score unsignedIntValue]];
        
        lifeCount = (NSNumber*) [propertyList objectForKey:@"LifeCount"];
        [m_Player setLifeCount:[lifeCount unsignedIntValue]];
        
        energy = (NSNumber*) [propertyList objectForKey:@"Energy"];
        [m_Player setEnergy:[energy intValue]];

        playerX = (NSNumber*) [propertyList objectForKey:@"PlayerX"];
        [m_Player setX:[playerX intValue]]; 
        
        playerY = (NSNumber*) [propertyList objectForKey:@"PlayerY"];
        [m_Player setY:[playerY intValue]]; 
        
        currentWeapon = (NSNumber*) [propertyList objectForKey:@"CurrentWeapon"];
        [m_Player setCurrentWeapon:[currentWeapon intValue]]; 

        currentMissile = (NSNumber*) [propertyList objectForKey:@"CurrentMissile"];
        [m_Player setCurrentMissile:[currentMissile intValue]]; 
        
        weaponPower = (NSNumber*) [propertyList objectForKey:@"WeaponPower"];
        [m_Player setFirePower:[weaponPower unsignedIntValue]]; 
        
        missilePower = (NSNumber*) [propertyList objectForKey:@"MissilePower"];
        [m_Player setMissilePower:[missilePower unsignedIntValue]]; 

        shield = (NSNumber*) [propertyList objectForKey:@"Shield"];
        [m_Player setShield:[shield unsignedIntValue]]; 
        
        [data release];
    }
}

- (void) saveGame {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"savedGame.plist"];
    NSString *error;
    NSMutableDictionary* propertyList = (NSMutableDictionary*) [[NSMutableDictionary alloc] initWithCapacity:7];
    
    if (!propertyList){
        NSLog(@"Plist not returned, error.");
    } else {
        // Get field read from settings.plist file
         NSNumber* currentLevel= [NSNumber numberWithUnsignedInt:m_CurrentLevelIndex];
        [propertyList setValue:currentLevel forKey:@"CurrentLevel"];
        //[currentLevel release];
        
        // Get current Level step and current indicator.
        NSNumber* currentLevelStep = [NSNumber numberWithUnsignedInt:m_CurrentLevelStep];
        [propertyList setValue:currentLevelStep forKey:@"CurrentLevelStep"];
        //[currentLevelStep release];
        
        NSNumber* currentIndicator =  [NSNumber numberWithUnsignedInt:[[Level level] getIndicator]]; 
        [propertyList setValue:currentIndicator forKey:@"CurrentIndicator"];
        //[currentIndicator release];
        
        
        NSNumber* score =  [NSNumber numberWithUnsignedInt:m_SavedScore];
        [propertyList setValue:score forKey:@"Score"];
        
        NSNumber* lifeCount =  [NSNumber numberWithUnsignedInt:m_SavedLifeCount];
        [propertyList setValue:lifeCount forKey:@"LifeCount"];
        
        NSNumber* energy =  [NSNumber numberWithUnsignedInt:m_SavedEnergy];
        [propertyList setValue:energy forKey:@"Energy"];
        
        NSNumber* playerX =  [NSNumber numberWithInt:m_SavedX];
        [propertyList setValue:playerX forKey:@"PlayerX"];
        
        NSNumber* playerY =  [NSNumber numberWithInt:m_SavedY];
        [propertyList setValue:playerY forKey:@"PlayerY"];
        
        NSNumber* currentWeapon =  [NSNumber numberWithInt:m_SavedCurrentWeapon];
        [propertyList setValue:currentWeapon forKey:@"CurrentWeapon"];
        
        NSNumber* currentMissile =  [NSNumber numberWithInt:m_SavedCurrentMissile];
        [propertyList setValue:currentMissile forKey:@"CurrentMissile"];
        
        NSNumber* weaponPower =  [NSNumber numberWithUnsignedInt:m_SavedWeaponPower];
        [propertyList setValue:weaponPower forKey:@"WeaponPower"];
        
        NSNumber* missilePower =  [NSNumber numberWithUnsignedInt:m_SavedMissilePower];
        [propertyList setValue:missilePower forKey:@"MissilePower"];
        
        NSNumber* shield =  [NSNumber numberWithUnsignedInt:m_SavedShield];
        [propertyList setValue:shield forKey:@"Shield"];

        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:propertyList
                                                                       format:NSPropertyListXMLFormat_v1_0
                                                             errorDescription:&error];
        
        if(plistData) {
            [plistData writeToFile:appFile atomically:YES];
        } else {
            NSLog(@"%@", error);
            [error release];
        }
        
        [propertyList release];
    }
}



@end
