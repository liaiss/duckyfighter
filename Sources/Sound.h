//
//  Sound.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 09/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface Sound : NSObject {	
	NSUInteger m_BufferID;
	NSUInteger m_SourceID;
    
    bool m_IsMusic;
    bool m_IsAllocated;
}

- (id)initSound: (NSString*) resourceName: (NSString*) extension;

- (void)play: (bool) repeat;

- (void)stop;

- (void)setVolume:(CGFloat) volume;

- (void)rewind;

- (bool)isPlaying;

@end
