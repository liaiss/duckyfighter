//
//  DuckyFighterAppDelegate.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 17/08/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "ObjectInfo.h"
#import "Level.h"
#import "PlayerShip.h"
#import "DisplayRefreshThread.h"
#import "PlayerScore.h"
#import "Scrolling.h"
#import "EAGLView.h"
#import "ScreenView.h"


@class DuckyFighterViewController;

@interface DuckyFighterAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	EAGLView *glView;
    DuckyFighterViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet EAGLView *glView;
@property (nonatomic, retain) IBOutlet DuckyFighterViewController *viewController;

- (void) dealloc;

@end

