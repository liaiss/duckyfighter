//
//  Sound.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 09/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>

#import "OALSupport.h"
#import "Sound.h"
#import "SoundManager.h"


@implementation Sound

- (id) initSound: (NSString*) resourceName: (NSString*) extension {
	
	ALvoid * outData;
	ALenum  error = AL_NO_ERROR;
	ALenum  format;
	ALsizei size;
	ALsizei freq;
	
	if (![super init]) {
		return nil; 
	}
    
    m_IsAllocated = FALSE;
	
	if ((resourceName != nil) && ([resourceName length] != 0)) {
        
        m_IsMusic = [extension isEqualToString:MUSIC_EXTENSION];
        
        NSString * soundPath=[[NSBundle mainBundle] pathForResource:resourceName ofType:extension];
        if (soundPath != nil) {
            NSURL* fileURL = [NSURL fileURLWithPath:soundPath];
		
            if (fileURL) {
                outData = getOpenALAudioData((CFURLRef)fileURL, &size, &format, &freq);
		
                if ((error = alGetError()) == AL_NO_ERROR) {
        
                    alGenBuffers(1, &m_BufferID);
                    alBufferData(m_BufferID,format,outData,size,freq); 
                    alGenSources(1, &m_SourceID); 
		
                    alSourcei(m_SourceID, AL_BUFFER, m_BufferID);
                    alSourcef(m_SourceID, AL_PITCH, 1.0f);
		
                    m_IsAllocated = TRUE;
                   if (outData)
                   {
                       free(outData);
                       outData = NULL;
                   }
                }
            }
        }
    }
	
	return self;
}
- (void) dealloc {
    
    if (m_IsAllocated) {
        
        alDeleteSources(1, &m_SourceID);
        alDeleteBuffers(1, &m_BufferID);	    
    }
    
    [super dealloc];
}

- (void)play: (bool) repeat {
	
    if (repeat) {
        alSourcei(m_SourceID, AL_LOOPING, AL_TRUE);
    }
    
    alSourcef(m_SourceID, AL_GAIN, [[SoundManager soundManager] getVolume:m_IsMusic]);
    
    alSourcePlay(m_SourceID);
}

- (void) stop {
    alSourceStop(m_SourceID);
}

- (void) rewind {
	
	alSourceRewind (m_SourceID);
}

- (void) setVolume:(CGFloat) volume {
    alSourcef(m_SourceID, AL_GAIN, volume);
}

- (bool) isPlaying {
	
    ALenum state;
	
    alGetSourcei(m_SourceID, AL_SOURCE_STATE, &state);
	
    return (state == AL_PLAYING);
}

- (UInt32) audioSize:(AudioFileID)fileDescriptor {
	UInt64 outDataSize = 0;
	UInt32 thePropSize = sizeof(UInt64);
	OSStatus result = AudioFileGetProperty(fileDescriptor, kAudioFilePropertyAudioDataByteCount, &thePropSize, &outDataSize);
	
	if(result != 0) {
		NSLog(@"cannot find file size");
	}
	
	return (UInt32)outDataSize;
}


@end
