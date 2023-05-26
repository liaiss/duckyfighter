//
//  LoadingStatusBar.m
//  DuckyFighter
//
//  Created by Liaiss Merzougue on 16/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoadingStatusBar.h"
#import "TextManager.h"
#import "LayerManager.h"

#define LOADING_TEXT_X 140
#define LOADING_TEXT_Y 220
#define LOADING_TEXT_SIZE 40

#define CURSOR_X 80
#define MAX_CURSOR_X 400
#define CURSOR_Y 80

@implementation LoadingStatusBar

- (id) initLoadingStatusBar: (NSArray*) tabSprite:(NSString*) background:(NSString*) text {
	NSLog(@"Load status bar 1");
	if (![super init]) {
        NSLog(@"Load status bar 2");
	    return nil;
	}
	
	m_Cursor = [[GameSprite alloc] initSprite:tabSprite:1:0:YES];
	
	if (m_Cursor == nil) {
        NSLog(@"Load status bar 3");
	    return nil;
	}
	
	m_Text = text;
	[m_Text retain];
	
	m_ScreenImage = [[LayerManager layerManager] getLayer:background:YES];
	NSLog(@"Loading status bar********************");
	m_Progress = 0;
	
	return self;
}

- (void) dealloc {
	[m_Cursor release];
	[m_Text release];
	[super dealloc];
}

- (void) updateStatus {

#if 0
    CGSize dimension;
	NSUInteger startX = CURSOR_X;
	NSUInteger newX = 0;


	dimension.width = 200;
	dimension.height = 100;
	  
    // Draw background
	[m_ScreenImage draw:0:0]; 

	[[TextManager textManager] drawText:@"Loading level\nPlease wait" : dimension :LOADING_TEXT_SIZE:LOADING_TEXT_X:LOADING_TEXT_Y];
	newX = ((MAX_CURSOR_X - CURSOR_X) * m_Progress) / 100; 
	newX += CURSOR_X;

	dimension.width = 60;
	dimension.height = 60;

	
	while (startX < newX) {
		[[TextManager textManager] drawText:@"." : dimension :LOADING_TEXT_SIZE:startX:CURSOR_Y];
		startX += dimension.width;
	} 
	

	[m_Cursor draw: newX: CURSOR_Y];
    [m_Cursor next:YES]; 
 
#endif
       
}

- (void) setProgress: (NSUInteger) newProgress {
    
    if (newProgress > 100) {
	    newProgress = 100;
	}
    
    m_Progress = newProgress;
}

- (void) reset {
    m_Progress = 0;
}


@end
