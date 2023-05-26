//
//  GameMenu.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "Layer.h"
#import "Sound.h"
#import "PlayerShip.h"

#define EASY_LEVEL 1
#define NORMAL_LEVEL 2
#define HARD_LEVEL 3

enum {   
	NEW_GAME_MENU_ITEM = 0,
    CONTINUE_GAME_MENU_ITEM = 1,
    SETTINGS_MENU_ITEM = 2, 
    HIGH_SCORE_MENU_ITEM = 3,
    CREDITS_MENU_ITEM = 4,
	LEVEL_SELECTION_MENU_ITEM = 5,
    CALIBRATION_MENU_ITEM = 6,
    SOUND_VOLUME_ITEM = 7,
    MUSIC_VOLUME_ITEM = 8
};

@interface GameMenu : NSObject {
	Layer* m_ScreenImage;
	PlayerShip* m_Ship;
    
	NSInteger m_Selected;
	NSInteger m_State;
    
	NSInteger m_StartX;
	NSInteger m_StartY;
    
	Sound* m_Sound;
    Sound* m_SoundClick;
	Sound* m_Music;
    
	bool m_IsSoundPlayed;
    
    NSInteger m_SoundVolume;
    NSInteger m_MusicVolume;
    NSUInteger m_Difficulty;
    
    CGFloat m_AccelX;
    CGFloat m_AccelY;
    
    CGFloat m_DefaultX;
    CGFloat m_DefaultY;
    
    bool m_UseAccelerometer;
    bool m_SoundHasBeenPlayed;
    
    NSInteger m_AccelerometerSensitivity;
    
    NSDictionary * m_PropertyList;
    
    UIViewController* m_Controller;

}

- (id) initGameMenu:(NSString*) screenImage:(NSString*) soundFile:(NSString*) musicFile:(NSString*) clickFile:(PlayerShip*) ship:(NSInteger) x:(NSInteger) y;

- (NSInteger) updateMenu:(NSInteger) x:(NSInteger) y:(bool) validate;

- (NSInteger) getSelected;

- (void) resetSelected;

- (CGFloat) getSoundVolume;
- (CGFloat) getMusicVolume;

- (NSUInteger) getDifficulty;

- (NSInteger) getAccelerometerSensitivity;

- (bool) isUseAccelerometer;

- (void) playMusic;

- (void) stopMusic;

- (void) setViewController: (UIViewController*) controller;

- (void) loadSettings;

- (void) saveSettings;

@end
