//
//  SoundManager.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 09/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>

#import "Sound.h"

#define SOUND_EXTENSION @"wav"
#define MUSIC_EXTENSION @"mp3"

@interface SoundManager : NSObject {
	ALCcontext* m_Context;
	ALCdevice* m_Device; 
    NSMutableDictionary* m_dictionnary;
	NSMutableDictionary* m_reservedDictionnary;
    
    CGFloat m_MusicVolume;
    CGFloat m_SoundVolume;
}

- (void) dealloc;

- (Sound*) getSound:(NSString*) resourceName:(NSString*) extension: (bool) isReserved;

- (void) clearSoundManager;

- (void) clearReservedSoundManager;

- (void) setSoundVolume: (CGFloat) volume; 

- (void) setMusicVolume: (CGFloat) volume; 

- (CGFloat) getVolume:(bool) isMusic;

+ (SoundManager*) soundManager;



@end
