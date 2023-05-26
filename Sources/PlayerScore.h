//
//  PlayerScore.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface PlayerScore : NSObject {
	
	NSUInteger m_Score; 
}

- (id) initScore : (NSUInteger) value;

- (void) dealloc;

- (void) update : (NSUInteger) value;

- (NSInteger) getScore;

- (void) setScore : (NSUInteger) value;


@end
