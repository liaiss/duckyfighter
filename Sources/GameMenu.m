//
//  GameMenu.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "TextManager.h"
#import "LayerManager.h"
#import "SoundManager.h"
#import "GameMenu.h"
#import "ScreenInfo.h"
#import "DuckyFighterViewController.h"
#import "Hiscores.h"

#define MAIN_MENU_STATE 0
#define NEW_GAME_STATE 1
#define SETTINGS_STATE 2
#define HALL_OF_FAME_STATE 3
#define CALIBRATION_STATE 4
#define CREDIT_STATE 5

#define SELECTED_FONT_SIZE 36
#define UNSELECTED_FONT_SIZE 30



@implementation GameMenu

- (id) initGameMenu:(NSString*) screenImage:(NSString*) soundFile:(NSString*) musicFile:(NSString*) clickFile:(PlayerShip*) ship:(NSInteger) x:(NSInteger) y {
	
	if (![super init]) {
	    return nil;
	}
	
	m_ScreenImage = [[LayerManager layerManager] getLayerWithoutShadow:screenImage:YES];
	m_Ship = ship;
    [m_Ship retain];
	
	m_Selected = -1;
	
	m_StartX = x;
	m_StartY = y;
	
	m_Sound = [[SoundManager soundManager] getSound:soundFile:SOUND_EXTENSION:YES];
    m_SoundClick = [[SoundManager soundManager] getSound:clickFile:SOUND_EXTENSION:YES];
	m_Music = [[SoundManager soundManager] getSound:musicFile:MUSIC_EXTENSION:YES];
	
	m_IsSoundPlayed = NO;
    m_State = MAIN_MENU_STATE;
	m_Difficulty = NORMAL_LEVEL;
    
    m_SoundVolume = 50;
    m_MusicVolume = 50;
    
    m_UseAccelerometer = NO;
    m_AccelerometerSensitivity = 20;
    
    m_SoundHasBeenPlayed = NO;
    
	return self;
}

- (void) dealloc {
    [m_Ship release];
	[super dealloc];
}

- (NSInteger) handleMainMenu:(NSInteger) x:(NSInteger) y:(bool) validate {
	
	NSUInteger newX;
	NSUInteger newY;
	CGSize dimension;
	
	dimension.width = 300;
	dimension.height = 100;
	
	// Draw background
	[m_ScreenImage draw:0:0]; 
	
    newX = 90;
	newY = 180;
    
    [[TextManager textManager] drawText:@"Ducky Fighter":dimension:50 :newX: newY];
    
    dimension.width = 150;
	dimension.height = 35;
    
	// Redraw Menu screen but using the selected item with a larger font.
	newX = m_StartX;
	newY = m_StartY;
    
    [[TextManager textManager] setColor:0.0 :0.0 :0.0:1.0];
    // First display new game and check if it is selected.
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        if (validate) {
            if (!m_SoundHasBeenPlayed) {
                m_SoundHasBeenPlayed = YES;
                [m_Sound play:NO];
            }
            m_Selected = NEW_GAME_MENU_ITEM;
        }
        [[TextManager textManager] drawText:@"New game":dimension:SELECTED_FONT_SIZE :newX: newY];
    } else {
        [[TextManager textManager] drawText:@"New game":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    }
    
    newY -= dimension.height; 
    // Secondly display Continue game and check if it is selected.
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        if (validate) {
            if (!m_SoundHasBeenPlayed) {
                 m_SoundHasBeenPlayed = YES;
                [m_Sound play:NO];
            }
            m_Selected = CONTINUE_GAME_MENU_ITEM;
        }
        [[TextManager textManager] drawText:@"Continue":dimension:SELECTED_FONT_SIZE :newX: newY];
    } else {
        [[TextManager textManager] drawText:@"Continue":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    }
    
    newY -= dimension.height; 
    
    // Thirdly display settings and check if it is selected.
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        if (validate) {
            [m_Sound play:NO];
            m_State = SETTINGS_STATE;
            m_Selected = -1;
        }
        [[TextManager textManager] drawText:@"Settings":dimension:SELECTED_FONT_SIZE :newX: newY];
    } else {
        [[TextManager textManager] drawText:@"Settings":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    }
   
    newY -= dimension.height; 
    
    // Thirdly display hall of fame and check if it is selected.
    dimension.width = 200;
    newX -= 25;
    
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        m_Selected = -1;
        if (validate) {
            [m_Sound play:NO];
            m_State = HALL_OF_FAME_STATE;
            m_Selected = -1;
        }
        [[TextManager textManager] drawText:@"High score":dimension:SELECTED_FONT_SIZE :newX: newY];
    } else {
        [[TextManager textManager] drawText:@"High score":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    }
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    
	dimension.width = 240;
    dimension.height = 20; 
    
    [[TextManager textManager] drawText:@"(c) Liaiss Merzougue 2009 - 2011":dimension:16 :120: 0];
    
	return m_Selected;
}

- (NSInteger) handleSettings:(NSInteger) x:(NSInteger) y:(bool) validate {
	
	NSUInteger newX;
	NSUInteger newY;
	CGSize dimension;
	NSString* soundVolumeText = [[NSString alloc] initWithFormat:@" %d ", ((NSInteger) m_SoundVolume)];
    NSString* musicVolumeText = [[NSString alloc] initWithFormat:@" %d ", ((NSInteger) m_MusicVolume)];
	dimension.width = 150;
	dimension.height = 40;
	
    // Draw background
	[m_ScreenImage draw:0:0]; 
    
    newY = 280;
    newX = 0;
    
    [[TextManager textManager] setColor:0.0 :0.0 :0.0:1.0];
    // Draw back text at the top left
    [[TextManager textManager] drawText:@"< Back":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        if (x < newX + dimension.width) {
            if (!validate) {
                m_State = MAIN_MENU_STATE;
                [m_Sound play:NO];
                m_Selected = -1;
            }
        }
    }
    
    newX = 270;
    dimension.width = 220;
    // Draw Calibrate text at the top Write.
    [[TextManager textManager] drawText:@"Control Setup >":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        if (x > newX) {
            m_State = CALIBRATION_STATE;
            [m_Sound play:NO];
            m_Selected = -1;
        }
    }
    
	// Redraw Menu screen but using the selected item with a larger font.
	newX = m_StartX;
    dimension.width = 150;
	newY = 250;
    
	[[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
    
    // First display level difficulty new game and check if it is selected.
    [[TextManager textManager] drawText:@"Difficulty":dimension:SELECTED_FONT_SIZE :newX: newY];
    
    newY -= dimension.height; 
    
    // First display level difficulty and check if it is selected.
    newX = 65;
    dimension.width = 115;
    
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        if (!validate) {
            if ((x >= newX) && (x <= (newX + dimension.width))) {
                m_Difficulty = EASY_LEVEL;
            } else if ((x >= (newX + dimension.width)) &&
                       ( x <= (newX + (2 * dimension.width)))) {
                m_Difficulty = NORMAL_LEVEL;
            } else if ((x >= (newX + (2 * dimension.width))) &&
                       ( x <= (newX + (3 * dimension.width)))) {
                m_Difficulty = HARD_LEVEL;
            }
            
            [m_SoundClick play:NO];
        }
    }
    
    [[TextManager textManager] setColor:0.0 :0.0 :0.0:1.0];
    
    switch (m_Difficulty) {
        case EASY_LEVEL: 
            [[TextManager textManager] drawText:@"Easy":dimension:SELECTED_FONT_SIZE :newX: newY];
            [[TextManager textManager] drawText:@"Normal":dimension:UNSELECTED_FONT_SIZE :newX + dimension.width: newY];
            [[TextManager textManager] drawText:@"Hard":dimension:UNSELECTED_FONT_SIZE :newX + (2 * dimension.width): newY];
            break;
        case NORMAL_LEVEL:
            [[TextManager textManager] drawText:@"Easy":dimension:UNSELECTED_FONT_SIZE :newX: newY];
            [[TextManager textManager] drawText:@"Normal":dimension:SELECTED_FONT_SIZE :newX + dimension.width: newY];
            [[TextManager textManager] drawText:@"Hard":dimension:UNSELECTED_FONT_SIZE :newX + (2 * dimension.width): newY];
            break;
        case HARD_LEVEL:
            [[TextManager textManager] drawText:@"Easy":dimension:UNSELECTED_FONT_SIZE :newX: newY];
            [[TextManager textManager] drawText:@"Normal":dimension:UNSELECTED_FONT_SIZE :newX + dimension.width: newY];
            [[TextManager textManager] drawText:@"Hard":dimension:SELECTED_FONT_SIZE :newX + (2 * dimension.width): newY];
    }
    
    dimension.width = 200;
    newX = m_StartX - 25;
    newY -= (dimension.height + dimension.height/2);
	
    [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
    
    // Now display sound volume
    [[TextManager textManager] drawText:@"Sound Volume":dimension:SELECTED_FONT_SIZE :newX: newY];
    
    newX = 40;
    dimension.width = 115;
    newY -= dimension.height; 
    
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        if (!validate) {
            if ((x >= newX) && (x <= (newX + dimension.width))) {
                --m_SoundVolume;
                [m_SoundClick play:NO];
                if (m_SoundVolume < 0) {
                    m_SoundVolume = 0;
                } 
                [[SoundManager soundManager] setSoundVolume:((CGFloat)(m_SoundVolume*2)/100.0)];
            } else if ((x >= (newX + (2 * dimension.width))) &&
                       ( x <= (newX + (3 * dimension.width)))) {
                ++m_SoundVolume;
                [m_SoundClick play:NO];
                if (m_SoundVolume > 100) {
                    m_SoundVolume = 100;
                } 
                [[SoundManager soundManager] setSoundVolume:((CGFloat)(m_SoundVolume*2)/100.0)];
            } 
        }
    } 
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    [[TextManager textManager] drawText:@"  -  ":dimension:SELECTED_FONT_SIZE :newX: newY];
    [[TextManager textManager] drawText:soundVolumeText:dimension:SELECTED_FONT_SIZE :newX + dimension.width + 30: newY];
    [[TextManager textManager] drawText:@"  +  ":dimension:SELECTED_FONT_SIZE :newX + (2*dimension.width) + 50: newY];
    
    dimension.width = 200;
    newX = m_StartX - 25;
    newY -= (dimension.height + 10);
    
    [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
    
    // Now display sound volume
    [[TextManager textManager] drawText:@"Music Volume":dimension:SELECTED_FONT_SIZE :newX: newY];
    
    newX = 40;
    dimension.width = 115;
    newY -= dimension.height; 
    
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        if (!validate) {
            if ((x >= newX) && (x <= (newX + dimension.width))) {
                --m_MusicVolume;
                [m_SoundClick play:NO];
                if (m_MusicVolume < 0) {
                    m_MusicVolume = 0;
                } 
                [[SoundManager soundManager] setMusicVolume:((CGFloat)(m_MusicVolume*2)/100.0)];
                [m_Music setVolume:((CGFloat)m_MusicVolume/100.0)];
            } else if ((x >= (newX + (2 * dimension.width))) &&
                       ( x <= (newX + (3 * dimension.width)))) {
                ++m_MusicVolume;
                [m_SoundClick play:NO];
                if (m_MusicVolume > 100) {
                    m_MusicVolume = 100;
                } 
                [[SoundManager soundManager] setMusicVolume:((CGFloat)(m_MusicVolume*2)/100.0)];
                [m_Music setVolume:((CGFloat)m_MusicVolume/100.0)];
            } 
        }
     } 
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    [[TextManager textManager] drawText:@"  -  ":dimension:SELECTED_FONT_SIZE :newX: newY];
    [[TextManager textManager] drawText:musicVolumeText:dimension:SELECTED_FONT_SIZE :newX + dimension.width + 30: newY];
    [[TextManager textManager] drawText:@"  +  ":dimension:SELECTED_FONT_SIZE :newX + (2*dimension.width) + 50: newY];
    
    [soundVolumeText release];
    [musicVolumeText release];
    
	return -1;
}

- (NSInteger) handleHallOfFame:(NSInteger) x:(NSInteger) y:(bool) validate {
	
	NSUInteger newX;
	NSUInteger newY;
	CGSize dimension;
	
	dimension.width = 150;
	dimension.height = 40;
	
	// Draw background
	[m_ScreenImage draw:0:0]; 
	
    newY = 280;
    newX = 0;
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    // Draw back text at the top left
    [[TextManager textManager] drawText:@"< Back":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        if (x < newX + dimension.width) {
            m_State = MAIN_MENU_STATE;
            [m_Sound play:NO];
            m_Selected = -1;
        }
    }
    
    newX = 320;
    // Draw Calibrate text at the top Write.
    [[TextManager textManager] drawText:@"Credits >":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        if (x > newX) {
            m_State = CREDIT_STATE;
            [m_Sound play:NO];
            m_Selected = -1;
        }
    }
    
    newX = 110;
	newY = 230;
    
    [[Hiscores hiscores] draw:newX : newY];
    
	return m_Selected;
}

- (NSInteger) handleCredit:(NSInteger) x:(NSInteger) y:(bool) validate {
	
	NSUInteger newX;
	NSUInteger newY;
	CGSize dimension;
	
	dimension.width = 150;
	dimension.height = 40;
	
	// Draw background
	[m_ScreenImage draw:0:0]; 
	
    newY = 280;
    newX = 0;
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    // Draw back text at the top left
    [[TextManager textManager] drawText:@"< Back":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        if (x < newX + dimension.width) {
            m_State = HALL_OF_FAME_STATE;
            [m_Sound play:NO];
            m_Selected = -1;
        }
    }
    
    newX = m_StartX;
	newY = 230;
    
    [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
    [[TextManager textManager] drawText:@"Graphics":dimension:SELECTED_FONT_SIZE :newX: newY];
    
    newY -= dimension.height;
    dimension.width = 200;
    newX = m_StartX - 30;
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    [[TextManager textManager] drawText:@"Liaiss Merzougue":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    
    newY -= dimension.height; 
    dimension.width = 150;
    newX = m_StartX;
    
    [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
    [[TextManager textManager] drawText:@"Code":dimension:SELECTED_FONT_SIZE :newX: newY];
    
    newY -= dimension.height; 
    dimension.width = 200;
    newX = m_StartX - 30;
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    [[TextManager textManager] drawText:@"Liaiss Merzougue":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    
    newY -= dimension.height; 
    dimension.width = 150;
    newX = m_StartX;
    
    [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
    [[TextManager textManager] drawText:@"Music":dimension:SELECTED_FONT_SIZE :newX: newY];
    
    newY -= dimension.height; 
    dimension.width = 200;
    newX = m_StartX - 30;
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    [[TextManager textManager] drawText:@"Florent Rizzo":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    
    newY -= dimension.height; 
    dimension.width = 210;
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    [[TextManager textManager] drawText:@"Bertrand Sautter":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    
	return m_Selected;
}


- (NSInteger) handleCalibrate:(NSInteger) x:(NSInteger) y:(bool) validate {
	
	NSUInteger newX;
	NSUInteger newY;
	CGSize dimension;
    NSString* sensitivityText = [[NSString alloc] initWithFormat:@" %d ", ((NSInteger) m_AccelerometerSensitivity)];
    
	dimension.width = 150;
	dimension.height = 40;
	
    // Draw background
	[m_ScreenImage draw:0:0]; 
    
    newY = 280;
    newX = 0;
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    // Draw back text at the top left
    [[TextManager textManager] drawText:@"< Back":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        if (x < newX + dimension.width) {
            if (!validate) {
                m_State = SETTINGS_STATE;
                [m_Sound play:NO];
                m_Selected = -1;
            }
        }
    }

	// Redraw Menu screen but using the selected item with a larger font.
	newX = ([[ScreenInfo screenInfo] getWidth] / 2) - 125;
	dimension.width = 250;
    newY = 250;
    
    [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
    
    // Now display sound volume
    [[TextManager textManager] drawText:@"Control Type":dimension:SELECTED_FONT_SIZE :newX: newY];
    
    newX = 120;
    dimension.width = 115;
    newY -= dimension.height; 
    
    if ((y >= newY) && (y <= (newY + dimension.height))) {
        if (!validate) {
            if ((x >= newX) && (x <= (newX + dimension.width))) {
                [m_SoundClick play:NO];
                m_UseAccelerometer = YES;   
            } else if ((x >= (newX + (dimension.width))) &&
                       ( x <= (newX + (2 * dimension.width)))) {
                m_UseAccelerometer = NO;   
                [m_SoundClick play:NO];
            } 
        }
    }    
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    if (m_UseAccelerometer) {
        [[TextManager textManager] drawText:@"Tilt ":dimension:SELECTED_FONT_SIZE :newX: newY];
        [[TextManager textManager] drawText:@"Touch":dimension:UNSELECTED_FONT_SIZE :newX + dimension.width: newY];
    } else {
        [[TextManager textManager] drawText:@"Tilt ":dimension:UNSELECTED_FONT_SIZE :newX: newY];
        [[TextManager textManager] drawText:@"Touch":dimension:SELECTED_FONT_SIZE :newX + dimension.width: newY];   
    }

    if (m_UseAccelerometer) {
        newY -= dimension.height; 
        dimension.width = 200;
        newX = m_StartX - 25;
    
        [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
    
        // Now display sensitivity
        [[TextManager textManager] drawText:@"Sensitivity":dimension:SELECTED_FONT_SIZE :newX: newY];
    
        newX = 40;
        dimension.width = 115;
        newY -= dimension.height; 
    
        if ((y >= newY) && (y <= (newY + dimension.height))) {
            if (!validate) {
                if ((x >= newX) && (x <= (newX + dimension.width))) {
                    --m_AccelerometerSensitivity;
                    [m_SoundClick play:NO];
                    if (m_AccelerometerSensitivity < 1) {
                        m_AccelerometerSensitivity = 1;
                    } 
                } else if ((x >= (newX + (2 * dimension.width))) &&
                           (x <= (newX + (3 * dimension.width)))) {
                    ++m_AccelerometerSensitivity;
                
                    [m_SoundClick play:NO];
                    if (m_AccelerometerSensitivity > 100) {
                        m_AccelerometerSensitivity = 100;
                    } 
                } 
            }
        } 
    
        [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
        [[TextManager textManager] drawText:@" - ":dimension:SELECTED_FONT_SIZE :newX: newY];
        [[TextManager textManager] drawText:sensitivityText:dimension:SELECTED_FONT_SIZE :newX + dimension.width + 30: newY];
        [[TextManager textManager] drawText:@" + ":dimension:SELECTED_FONT_SIZE :newX + (2*dimension.width) + 50: newY];
    
        dimension.width = [[ScreenInfo screenInfo] getWidth];
        newY -= dimension.height * 3; 
        newX = 0;
        dimension.height = 80;
    
        [[TextManager textManager] drawText:@"Set your iPhone in neutral orientation":dimension:UNSELECTED_FONT_SIZE :newX: newY];
      
        dimension.height = 40;
        dimension.width = [[ScreenInfo screenInfo] getWidth];
        newY -= (dimension.height + 20); 
    
        [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];

        [[TextManager textManager] drawText:@"OK":dimension:UNSELECTED_FONT_SIZE :newX: newY];
    
        if ((y >= newY) && (y <= (newY + dimension.height))) {
            if (!validate) {
                if ((x >= newX) && (x <= (newX + dimension.width))) {
                    // On click Get the initial acceleration and add factor
                    [m_Sound play:NO];
                    DuckyFighterViewController* controller = (DuckyFighterViewController*) m_Controller;
               
                    m_DefaultX = [controller getAccelX];
                    m_DefaultY = [controller getAccelY];
                    
                    [controller setDefaultAccelX:m_DefaultX];
                    [controller setDefaultAccelY:m_DefaultY];
                
                    // Reset ship coordinate.
                    [m_Ship setX:[[ScreenInfo screenInfo] getWidth]/2 - [m_Ship getWidth]/2];
                    [m_Ship setY:[[ScreenInfo screenInfo] getHeight]/2 - [m_Ship getHeight]/2];
                } 
            }
        }
    
        // need to manage ship move.
    
        [m_Ship draw];
    
    }
    
    [sensitivityText release];
    
	return -1;
}    

- (NSInteger) updateMenu:(NSInteger)x :(NSInteger)y :(_Bool)validate {
    switch (m_State) {
        case MAIN_MENU_STATE: return [self handleMainMenu:x:y:validate];
        case SETTINGS_STATE: return [self handleSettings:x:y:validate]; 
        case HALL_OF_FAME_STATE: return [self handleHallOfFame:x:y:validate]; 
        case CALIBRATION_STATE: return [self handleCalibrate:x:y:validate];
        case CREDIT_STATE: return [self handleCredit:x:y:validate];
    }
    
    return m_Selected;
}


- (NSInteger) getSelected {
	return m_Selected;
}

- (void) resetSelected {
	m_Selected = -1;
    m_SoundHasBeenPlayed = NO;
}

- (CGFloat) getSoundVolume {
    return m_SoundVolume;
}

- (CGFloat) getMusicVolume{
    return m_MusicVolume;
}

- (NSUInteger) getDifficulty{
    return m_Difficulty;
}

- (NSInteger) getAccelerometerSensitivity{
    return m_AccelerometerSensitivity;
}

- (bool) isUseAccelerometer {
    return m_UseAccelerometer;
}

- (void) playMusic {
	[m_Music play:YES];
}

- (void) stopMusic{
    [m_Music stop];
}

- (void) setViewController: (UIViewController*) controller {
    m_Controller = controller;
}

- (void) loadSettings {

    NSData *data;
    NSString *error;
    NSPropertyListFormat format;
    NSNumber* controlType;
    NSNumber* sensitivity;
    NSNumber* defaultX;
    NSNumber* defaultY;
    NSNumber* difficulty;
    NSNumber* soundVolume;
    NSNumber* musicVolume;
    NSDictionary* propertyList;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
    data = [[NSData alloc] initWithContentsOfFile:appFile];
   
    if (!data) {
        NSLog(@"Data file not returned.");
    } else {
    
        propertyList = (NSDictionary*) [NSPropertyListSerialization propertyListFromData:data  mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
    
        if (!propertyList){
            NSLog(@"Plist not returned, error: %@", error);
        }
    
        // Get field read from settings.plist file
    
        controlType = (NSNumber*) [propertyList objectForKey:@"ControlType"];
        m_UseAccelerometer = [controlType boolValue];
    
        sensitivity = (NSNumber*) [propertyList objectForKey:@"Sensitivity"];
        m_AccelerometerSensitivity = [sensitivity unsignedIntValue];

        defaultX = (NSNumber*) [propertyList objectForKey:@"DefaultX"];
        m_DefaultX = [defaultX floatValue];
    
        defaultY = (NSNumber*) [propertyList objectForKey:@"DefaultY"];
        m_DefaultY = [defaultY floatValue];
    
        [(DuckyFighterViewController*) m_Controller setDefaultAccelX:m_DefaultX];
        [(DuckyFighterViewController*) m_Controller setDefaultAccelY:m_DefaultY];
    
        difficulty = (NSNumber*) [propertyList objectForKey:@"Difficulty"];
        m_Difficulty = [difficulty unsignedIntValue];
    
        soundVolume = (NSNumber*) [propertyList objectForKey:@"SoundVolume"];
        m_SoundVolume = [soundVolume unsignedIntValue];
        [[SoundManager soundManager] setSoundVolume:((CGFloat)(m_SoundVolume*2)/100.0)];
    
        musicVolume = (NSNumber*) [propertyList objectForKey:@"MusicVolume"];
        m_MusicVolume = [musicVolume unsignedIntValue];
        [[SoundManager soundManager] setMusicVolume:((CGFloat)(m_MusicVolume*2)/100.0)];
    
        [data release];
    }
}

- (void) saveSettings {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *error;
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
    NSMutableDictionary* propertyList = (NSMutableDictionary*) [[NSMutableDictionary alloc] initWithCapacity:7];
    
    if (!propertyList){
        NSLog(@"Plist not returned, error.");
    } else {
        // Get field read from settings.plist file
        NSNumber* useAccel = [NSNumber numberWithBool:m_UseAccelerometer]; 
        [propertyList setValue:useAccel forKey:@"ControlType"];
        //[useAccel release];
    
        NSNumber* sensitivity = [NSNumber numberWithUnsignedInt:m_AccelerometerSensitivity]; 
        [propertyList setValue:sensitivity forKey:@"Sensitivity"];
        //[sensitivity release];
      
        NSNumber* defaultX = [NSNumber numberWithFloat:m_DefaultX];
        [propertyList setValue:defaultX forKey:@"DefaultX"];
        //[defaultX release];
    
        NSNumber* defaultY = [NSNumber numberWithFloat:m_DefaultY];
        [propertyList setValue:defaultY forKey:@"DefaultY"];
        //[defaultY release];
    
        NSNumber* difficulty = [NSNumber numberWithUnsignedInt:m_Difficulty];
        [propertyList setValue:difficulty forKey:@"Difficulty"];
        //[difficulty release];
    
        NSNumber* soundVolume= [NSNumber numberWithUnsignedInt:m_SoundVolume];
        [propertyList setValue:soundVolume forKey:@"SoundVolume"];
        //[soundVolume release];
    
        NSNumber* musicVolume= [NSNumber numberWithUnsignedInt:m_MusicVolume];
        [propertyList setValue:musicVolume forKey:@"MusicVolume"];
        //[musicVolume release];
    
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
