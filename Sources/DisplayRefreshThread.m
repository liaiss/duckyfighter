//
//  DisplayRefreshThread.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 21/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "DisplayRefreshThread.h"
#import "ScreenInfo.h"
#import "ScreenView.h"
#import "EAGLView.h"

@implementation DisplayRefreshThread

- (id) initRefreshThread:(UIView*) display {	

	if (![super init]) {
		return nil; 
	}
	
	m_Display = display;
	m_IsStop = NO;
	
	m_Thread = [[NSThread alloc] initWithTarget:self selector:@selector(displayRefresh) object:nil]; 
	
	if (m_Thread == nil) {
	    return nil; 
	}
	
	[m_Thread start]; 
	
	return self;
}

- (void) dealloc {
	[m_Thread release]; 
	[super dealloc];
}

- (void) displayRefresh {
	
    while (![m_Thread isCancelled]) {
		[m_Display performSelectorOnMainThread:@selector(setNeedsLayout) withObject:nil waitUntilDone:YES];
		
		// Do sleep of 40ms for 25 frame by second
		[NSThread sleepForTimeInterval:0.04];
	}
}	

- (void) stop {
    [m_Thread cancel];
}
	
@end
