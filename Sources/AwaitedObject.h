//
//  AwaitedObject.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Eternity. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "GameObject.h"

@interface AwaitedObject : NSObject {
	
	NSUInteger m_L1Indicator;
    GameObject*      m_Object;
}

- (id) initAwaitedObject: (NSUInteger) l1Indicator:(GameObject*) obj;

- (void) dealloc;

- (NSUInteger) getL1Indicator;

- (GameObject*) getObject; 

@end
