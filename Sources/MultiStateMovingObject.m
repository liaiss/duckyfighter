//
//  MultiStateMovingObject.m
//  DuckyFighter
//
//  Created by Liaiss Merzougue on 19/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MultiStateMovingObject.h"

@implementation MultiStateMovingObject

-(id) initMultiStateMovingObject:(NSArray*) objectsInfo {
    
    if (![super init]) {
		return nil; 
	}
    
    m_ObjectState = [[NSMutableArray alloc] initWithCapacity:[objectsInfo count]];
    m_CurrentState = 0;
    
    for (NSInteger i = 0; i < [objectsInfo count]; ++i) {
        MovingObject* object = [[MovingObject alloc] initMovingObject:[objectsInfo objectAtIndex:i]];
        [m_ObjectState addObject:object];
        // TODO: divide the energy the object count.
        [object release];
    }
    
    return self;
}

- (void) dealloc {
    [super dealloc];
    [m_ObjectState removeAllObjects];
    [m_ObjectState release];
}

- (void) draw {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object draw];        
}

- (void) move : (NSInteger) x: (NSInteger) y{
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object move:x:y];    
}

- (NSInteger) getXMin{
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getXMin];
}

- (NSInteger) getYMin{
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getYMin];
}

- (NSInteger) getXMax{
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getXMax];
}

- (NSInteger) getYMax{
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getYMax];
}

- (NSInteger) getEnergy{
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getEnergy];
}

- (NSInteger) getSpeedX{
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getSpeedX];
}

- (NSUInteger) getHeight{
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getHeight];
}

- (NSUInteger) getWidth{
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getWidth];
}

- (NSUInteger) getImpact{
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getImpact];
}

- (void) setEnergy : (NSInteger) energy{
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object setEnergy:energy];
}

- (void) setSpeedX : (NSInteger) speedX{
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object setSpeedX:speedX];
}

- (void) setX : (NSInteger) x {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object setX:x];
}

- (void) setY : (NSInteger) y {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object setY:y];
}

- (void) setWidth : (NSInteger) width {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object setWidth:width];
}
 
- (void) setHeight : (NSInteger) height {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object setHeight:height];
}

- (void) moveUp {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object moveUp];
}

- (void) moveDown {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object moveDown];
}

- (void) moveLeft {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object moveLeft];
}

- (void) moveRight {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object moveRight];
}

- (void) fire {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object fire];
}

- (void) launchMissile {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object launchMissile];
}

- (void) playSoundExplode {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object playSoundExplode];
}

- (void) explode {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object explode];
}

- (bool) isExplode {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object isExplode];
}

- (void) resetExplode {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object resetExplode];
}

- (void) setSpeedY : (NSInteger) speedY {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object setSpeedY:speedY];
}

- (NSInteger) getSpeedY {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getSpeedY];
}

- (NSInteger) getState {
    MovingObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getState];
}

@end
