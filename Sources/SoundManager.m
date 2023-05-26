//
//  SoundManager.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 09/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SoundManager.h"


@implementation SoundManager

- (id) initSoundManager: (NSUInteger) capacity {
    
	if (![super init]) {
		return nil; 
	}
	
	m_Device = alcOpenDevice(NULL); 
	
	if (!m_Device) {
		[self release];
		return nil; 
	}
	
	m_Context = alcCreateContext(m_Device, NULL);

	alcMakeContextCurrent(m_Context);
	
    m_dictionnary = [[NSMutableDictionary alloc] initWithCapacity: capacity];
	m_reservedDictionnary = [[NSMutableDictionary alloc] initWithCapacity: capacity];
	
    m_SoundVolume = 0.5f;
    m_MusicVolume = 0.5f;
    
	return self;
}

- (void) dealloc {
	[m_dictionnary removeAllObjects];
	[m_dictionnary release];
	[m_reservedDictionnary removeAllObjects];
	[m_reservedDictionnary release];
	
	alcDestroyContext(m_Context);
	alcCloseDevice(m_Device);

    [super dealloc];	
}

- (Sound*) getSound:(NSString*) resourceName: (NSString*) extension: (bool) isReserved {
	NSMutableDictionary* selectedDict;
	Sound* sound = nil;
	
	if (isReserved) {
		selectedDict = m_reservedDictionnary;
	} else {
		selectedDict = m_dictionnary;
	}
	
	if ((resourceName != nil) && ([resourceName length] != 0)) {
	    sound = (Sound*) [selectedDict objectForKey:resourceName];
	
	    if ( sound == nil) {
			//NSLog(@"Create sound : %@.%@", resourceName, extension);
		    sound = [[Sound alloc] initSound:resourceName:extension];	
		   // NSLog(@"Add sound in the dictionnary: %s", isReserved?"true":"false");  
	        [selectedDict setObject:sound forKey:resourceName];
			[sound release];
	    }
	}
	
	return sound;
	
}

- (void) clearSoundManager {	
	[m_dictionnary removeAllObjects];
}

- (void) clearReservedSoundManager {
	[m_reservedDictionnary removeAllObjects];
}

- (void) setSoundVolume: (CGFloat) volume {
    m_SoundVolume = volume;
}

- (void) setMusicVolume: (CGFloat) volume {
    m_MusicVolume = volume;
}

- (CGFloat) getVolume:(bool) isMusic {
    if (isMusic) {
        return m_MusicVolume;
    } else {
        return m_SoundVolume;
    }
}

+ (SoundManager*) soundManager {
	static SoundManager *instance = nil;
	
    if (instance == nil) {
        instance = [[self alloc] initSoundManager:10];
    }
	
    return instance;
}

@end
