//
//  MultiStateStaticObject.m
//  DuckyFighter
//
//  Created by Liaiss Merzougue on 19/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MultiStateStaticObject.h"
#import "StaticObject.h"

@implementation MultiStateStaticObject

-(id) initMultiStateStaticObject:(NSArray*) objectsInfo {
    
    if (![super init]) {
		return nil; 
	}
    
    m_ObjectState = [[NSMutableArray alloc] initWithCapacity:[objectsInfo count]];
    m_CurrentState = 0;
    
    for (NSInteger i = 0; i < [objectsInfo count]; ++i) {
        StaticObject* object = [[StaticObject alloc] initStaticObject:[objectsInfo objectAtIndex:i]];
        [m_ObjectState addObject:object];
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
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object draw];
}

- (void) move : (NSInteger) x: (NSInteger) y {
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object move:x:y];
}

- (NSInteger) getXMin{
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getXMin];
}

- (NSInteger) getYMin{
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getYMin];
}

- (NSInteger) getXMax{
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getXMax];
}

- (NSInteger) getYMax{
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getYMax];
}

- (NSInteger) getEnergy{
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getEnergy];
}

- (NSInteger) getSpeedX{
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getSpeedX];
}

- (NSUInteger) getHeight{
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getHeight];
}

- (NSUInteger) getWidth{
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getWidth];
}

- (NSUInteger) getImpact{
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    return [object getImpact];
}

- (void) setEnergy : (NSInteger) energy{
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object setEnergy:energy];
}

- (void) setSpeedX : (NSInteger) speedX{
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object setSpeedX:speedX];
}

- (void) setX : (NSInteger) x {
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object setX:x];
}

- (void) setY : (NSInteger) y {
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object setY:y];
}

- (void) setWidth : (NSInteger) width {
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object setWidth:width];
}

- (void) setHeight : (NSInteger) height {
    StaticObject* object = [m_ObjectState objectAtIndex:m_CurrentState];
    
    [object setHeight:height];
}

@end
