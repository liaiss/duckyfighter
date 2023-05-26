//
//  ScreenView.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 22/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "ScreenView.h"
#import "Util.h"

@implementation ScreenView

- (void) refresh {
	[m_ViewController update];
	[m_ViewController draw];

}

- (void) updateLevel {
   [m_ViewController update];
}

- (BOOL)isOpaque { 
    return YES; 
}

- (void) setViewController:(DuckyFighterViewController*) viewController {
    m_ViewController = viewController;
}

@end
