//
//  Sprite.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 20/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface GameSprite : NSObject {
    NSMutableArray* m_PicTab;
	
    NSUInteger m_CurrentFrame;
    NSUInteger m_NbTimerCnt;
    NSUInteger m_NbTimerMax;
	NSUInteger m_LoopFrameStart;
}

- (id) initSprite:(NSArray*) tab:(NSUInteger) timerCountPerFrame:(NSUInteger) loopFrameStart: (bool) isReserved;

- (void) dealloc;

- (NSUInteger) getFrame;

- (NSUInteger) getFrameCount;

- (void) draw : (NSInteger) x: (NSInteger) y;

- (bool) next : (bool) waitEnd;

- (void) reset;

- (NSUInteger) getWidth;

- (NSUInteger) getHeight;

@end
