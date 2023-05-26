//
//  ScreenView.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 22/08/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DuckyFighterViewController.h"

@interface ScreenView : UIView {
    DuckyFighterViewController* m_ViewController;	
}


- (void) setViewController:(DuckyFighterViewController*) viewController;
- (void) updateLevel; 
- (void) refresh; 
@end
