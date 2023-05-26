//
//  LoadingStatusBar.h
//  DuckyFighter
//
//  Created by Liaiss Merzougue on 16/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameSprite.h"
#import "Layer.h"

@interface LoadingStatusBar : NSObject {
    GameSprite* m_Cursor;
	Layer* m_ScreenImage;
	
	NSString* m_Text;
	NSUInteger m_Progress;
}

- (id) initLoadingStatusBar: (NSArray*) tabSprite: (NSString*) background: (NSString*) text;

- (void) updateStatus;

- (void) setProgress: (NSUInteger) newProgress;

- (void) reset;

@end
