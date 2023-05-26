//
//  Scrolling.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#include "Layer.h"

@interface Scrolling : NSObject {

    Layer* m_CurrentView;
	Layer* m_NextView; 
	
	NSInteger m_Index;
	NSInteger m_Speed;
	NSInteger m_Limit;
	NSInteger m_TransitionSpeed;
	NSInteger m_CurrentCoordinate;
	
	bool m_Transition;
}

- (id) initScrolling:(NSString*) imageName:(NSInteger) speed:(bool) transition:(NSInteger) transitionSpeed;

- (void) dealloc;

- (void) setSpeed: (NSInteger) value;

- (void) setTransition: (bool) value;

- (NSInteger) getSpeed;

- (bool) getTransition;

- (Layer*) getCurrentView;

- (void) setCurrentView: (Layer*) view;

- (bool) makeTransition;

- (void) update;

- (void) draw;	

@end
