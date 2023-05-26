//
//  Scrolling.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "Scrolling.h"
#import "Util.h"
#import "LayerManager.h"

@implementation Scrolling


- (id) initScrolling:(NSString*) imageName:(NSInteger) speed:(bool) transition: 
					 (NSInteger) transitionSpeed {

	if (![super init]) {
	    return nil;
	}
	
    NSLog(@"Load scrolling: %@ \n", imageName);
	if ([imageName isEqualToString:@"empty"]) {
		m_CurrentView = nil;
	} else {
		m_CurrentView = [[LayerManager layerManager] getLayerWithoutShadow:imageName:NO];
	}
	
	m_Speed = speed;
	m_Transition = transition;
	m_TransitionSpeed = transitionSpeed;
    m_CurrentCoordinate = 0;
	
	return self;
}

- (void) dealloc {
	[super dealloc];
}

- (void) setSpeed: (NSInteger) value {
    m_Speed = value;
}

- (void) setTransition: (bool) value {
    m_Transition = value;
}

- (NSInteger) getSpeed {
    return m_Speed;
}

- (bool) getTransition {
    return m_Transition;
}

- (Layer*) getCurrentView {
    return m_CurrentView;
}

- (void) setCurrentView: (Layer*) view {
    m_CurrentView = view;
}

- (bool) makeTransition {
   /* if ((m_CurrentCoordinate == 0) || (m_Speed == 0)) { 
        return YES;
    } else {
        m_CurrentCoordinate -= m_Speed;
        if (m_CurrentCoordinate < 0) {
            m_CurrentCoordinate = 0; 
        }
        return NO;
    }*/
    return YES;
}

- (void) update {
    m_CurrentCoordinate -= m_Speed;
	
    if (m_CurrentCoordinate <= (-1 *[m_CurrentView getWidth])) {
        m_CurrentCoordinate = 0;
    }
}

- (void) draw {

	if (m_CurrentView != nil) {

	  
		//NSLog(@"Draw scrolling");
		
	    [m_CurrentView draw:m_CurrentCoordinate:0];
	    [m_CurrentView draw:m_CurrentCoordinate + [m_CurrentView getWidth]:0];
	}
}

@end
