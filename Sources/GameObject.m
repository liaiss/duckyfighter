//
//  Object.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "GameObject.h"
#import "PlayerScore.h"


@implementation GameObject


- (id) initObject : (ObjectInfo*) info {
    
	if (![super init]) {
		return nil; 
	}
	
	m_XMin = [info getXPos];
	m_XMax = [info getXPos] + [info getWidth];
	m_YMin = [info getYPos];
	m_YMax = [info getYPos] + [info getHeight];
	m_Impact = [info getImpact];
	m_Energy = [info getEnergy];
	m_SpeedX = [info getSpeedX];
	
	return self;
}

- (void) dealloc { 
	[super dealloc]; 
} 

- (void) actionCollision : (GameObject*) obj: (PlayerScore*)  sc {
	if ((obj->m_Energy > 0) && (m_Energy > 0)) {
	    m_Energy -= obj->m_Impact;
	    obj->m_Energy -= m_Impact;
	}
}

- (bool) detectCollision : (GameObject*) obj : (PlayerScore*) sc {

	if (obj->m_YMax < m_YMin) {
		return NO;
    }
	
    if (obj->m_YMin > m_YMax) {
        return NO;
    }
    
	if (obj->m_XMin > m_XMax) {
		return NO;
	}
	
    if (obj->m_XMax < m_XMin) {
		return NO;    
    }
	
	if (![self checkCollisionMask:obj]) {
	    return NO;
	}
	
    [self actionCollision : obj : sc];
	
	return YES;
}

- (bool) checkCollisionMask: (GameObject*) obj {
    return YES;
}

- (void) draw {

}

- (void) move : (NSInteger) x: (NSInteger) y {
    m_XMin -= m_SpeedX;
	m_XMax -= m_SpeedX;
}

- (NSInteger) getXMin {
	return m_XMin;
}

- (NSInteger) getYMin {
	return m_YMin;
}

- (NSInteger) getXMax {
	return m_XMax;
}

- (NSInteger) getYMax {
	return m_YMax;
}

- (NSInteger) getEnergy {
	return m_Energy;
}

- (NSInteger) getSpeedX {
	return m_SpeedX;
}

- (NSUInteger) getImpact {
	return m_Impact;
}

- (NSUInteger) getHeight {
	return m_YMax - m_YMin;
}

- (NSUInteger) getWidth {
	return m_XMax - m_XMin;
}

- (void) setEnergy : (NSInteger) energy {
	m_Energy = energy;
}

- (void) setSpeedX : (NSInteger) speedX {
	m_SpeedX = speedX;
}

- (void) setX : (NSInteger) x {
	m_XMax = x + (m_XMax - m_XMin); 
    m_XMin = x;
}

- (void) setY : (NSInteger) y {
	m_YMax = y + (m_YMax - m_YMin); 
    m_YMin = y;
}
 
- (void) setWidth : (NSInteger) width {
	m_XMax = m_XMin + width;
}

- (void) setHeight : (NSInteger) height {
	m_YMax = m_YMin + height;
}

@end
