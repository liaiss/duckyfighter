//
//  MultiStateStaticObject.h
//  DuckyFighter
//
//  Created by Liaiss Merzougue on 19/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface MultiStateStaticObject : NSObject<GameObjectProtocol> {
    NSMutableArray* m_ObjectState;
    
    NSUInteger m_CurrentState;
}

-(id) initMultiStateStaticObject:(NSArray*) objectsInfo;

@end
