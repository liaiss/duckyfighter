//
//  DuckyFighterViewController.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 17/08/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "ObjectInfo.h"
#import "PlayerShip.h"
#import "PlayerScore.h"
#import "Level.h"
#import "DisplayRefreshThread.h"
#import "PlayerStatus.h"
#import "LoadingStatusBar.h"
#import "LevelLoadingThread.h"
#import "GameMenu.h"
#import "Hiscores.h"

@interface DuckyFighterViewController : UIViewController<UIAccelerometerDelegate> {
	UIWindow* m_Window;
	UIView* m_View;
	ObjectInfo* m_PlayerShipInfo;
	ObjectInfo* m_PlayerSatInfo;
	PlayerScore* m_PlayerScore;
	PlayerStatus* m_PlayerStatus;
	LoadingStatusBar* m_LoadingStatus;
    
	GameMenu* m_Menu;
	NSDictionary* m_GameDescription;
	
	PlayerShip* m_Player;
	Level* m_CurrentLevel;
	NSUInteger m_CurrentLevelIndex;
    NSUInteger m_CurrentLevelStep;
    NSUInteger m_CurrentLevelIndicator;
   
    NSUInteger m_CurrentAllowedChar;
    
	NSArray* m_LevelResourceList;
	
	DisplayRefreshThread* m_RefreshThread;
	LevelLoadingThread* m_LevelLoader;
	NSUInteger m_GameState;
	
	NSInteger m_NewX;
	NSInteger m_NewY;
    CGFloat m_CurrentAccelX;
    CGFloat m_CurrentAccelY;
    CGFloat m_DefaultAccelX;
    CGFloat m_DefaultAccelY;
    CGFloat m_AccelX;
    CGFloat m_AccelY;
	NSInteger m_AverageX;
	NSInteger m_AverageY;
	NSInteger m_Count;
	NSInteger m_StartPosX;
	NSInteger m_StartPosY;
	
    NSString* m_BackgroundImage;
    NSString* m_ClickSound;
    NSString* m_ValidateSound;
    
    NSString* m_TitleSound;
    NSString* m_GameOverFirstSoundName;
    NSString* m_GameOverSecondSoundName;
    NSString* m_LevelClearedFirstSoundName;
    NSString* m_LevelClearedSecondSoundName;
    NSString* m_WarningSoundName;
    
	NSString* m_IntroVideoFile;
	MPMoviePlayerController* m_IntroMovie;
	
    bool m_MovieStarted;
	bool m_FirstLevelLoaded;
	bool m_IsTitleSoundPlayed;
    bool m_IsMenuMusicPlaying;
	bool m_NeedDraw;
    
    bool m_OnPause;
    
    CGFloat m_CurrentAlpha;
    Sound* m_FirstGameOverSound;
    Sound* m_SecondGameOverSound;
    
    Sound* m_FirstLevelClearedSound;
    Sound* m_SecondLevelClearedSound;
    
    bool m_IsPlayingGameOverFirstSound;
    bool m_IsPlayingGameOverSecondSound;
    bool m_IsPlayingLevelClearedFirstSound;
    bool m_IsPlayingLevelClearedSecondSound;
    
    NSUInteger m_LevelEndDisplayTimeCount;
    
    NSUInteger m_SavedScore;
    NSInteger m_SavedLifeCount;
    NSUInteger m_SavedWeaponPower;
    NSInteger m_SavedCurrentWeapon;
    NSUInteger m_SavedMissilePower;
    NSInteger m_SavedCurrentMissile;
    NSInteger m_SavedShield;
    NSInteger m_SavedEnergy;
    NSInteger m_SavedX;
    NSInteger m_SavedY;
}

- (void) startGame;

- (void) update;

- (void) draw;

- (void) setView:(UIView*) view;

- (CGFloat) getAccelX;

- (CGFloat) getAccelY;

- (void) setDefaultAccelX: (CGFloat) accelX;

- (void) setDefaultAccelY: (CGFloat) accelY;

- (void) manageTouchControl;

- (void) performFinalization;

- (void) loadSavedGame;

- (void) saveGame;

@end


