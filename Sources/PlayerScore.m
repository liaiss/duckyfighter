//
//  PlayerScore.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "PlayerScore.h"

@implementation PlayerScore

- (id) initScore : (NSUInteger) value {
	
	if (![super init]) {
		return nil; 
	}
	
	m_Score = value;
	
	return self;
}

- (void) dealloc {
	[super dealloc]; 
}

- (void) update : (NSUInteger) value {
	m_Score += value;
}	

- (NSInteger) getScore {
	return m_Score;
}

- (void) setScore : (NSUInteger) value {
    m_Score = value;
}


@end
