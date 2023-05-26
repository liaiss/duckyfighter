//
//  OALSupport.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 09/01/10.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <OpenAL/al.h>
#import <OpenAL/alc.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/ExtendedAudioFile.h>

typedef ALvoid	AL_APIENTRY	(*alBufferDataStaticProcPtr) (const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq);
ALvoid  alBufferDataStaticProc(const ALint bid, ALenum format, ALvoid* data, ALsizei size, ALsizei freq);

void* getOpenALAudioData(CFURLRef inFileURL, ALsizei *outDataSize, ALenum *outDataFormat, ALsizei*	outSampleRate);


