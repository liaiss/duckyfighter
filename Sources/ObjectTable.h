//
//  ObjectTable.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 26/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "GameObject.h"

@interface ObjectTable : NSObject {
	
    NSMutableArray* m_ObjectTable;
	NSRecursiveLock* m_Lock;
}

- (id) initObjectTable : (NSInteger) capacity;

- (void) dealloc;

- (void) add: (GameObject*) object;

- (void) remove: (NSUInteger) index;

- (bool) detectCollision : (GameObject*) object : (PlayerScore*) score;      

- (void) move : (NSInteger) x : (NSInteger) y;

- (void) draw;

- (NSUInteger) getSize;

- (GameObject*) get : (NSUInteger) index;      

- (void) clear; 


@end
