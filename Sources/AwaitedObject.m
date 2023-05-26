//
//  AwaitedObject.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "AwaitedObject.h"


@implementation AwaitedObject

- (id) initAwaitedObject: (NSUInteger) l1Indicator:(GameObject*) obj {
	
	if (![super init]) {
		return nil; 
	}
	
    m_L1Indicator = l1Indicator;
	m_Object = obj;
	[m_Object retain];
	return self;
}

- (void) dealloc {
	[m_Object release];
	[super dealloc]; 
}

- (NSUInteger) getL1Indicator {
	return m_L1Indicator;
}

- (GameObject*) getObject {
	return m_Object;
}


@end
