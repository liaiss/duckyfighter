//
//  MultiStateMovingObject.h
//  DuckyFighter
//
//  Created by Liaiss Merzougue on 19/01/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MovingObject.h"

@interface MultiStateMovingObject : NSObject<GameObjectProtocol, MovingObjectProtocol> {
    NSMutableArray* m_ObjectState;
    
    NSUInteger m_CurrentState;
}

-(id) initMultiStateMovingObject:(NSArray*) objectsInfo;

@end
