//
//  Object.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "PlayerScore.h"
#import "ObjectInfo.h"

@protocol GameObjectProtocol

- (void) draw ; 

- (void) move : (NSInteger) x: (NSInteger) y;

- (NSInteger) getXMin;
- (NSInteger) getYMin;
- (NSInteger) getXMax;
- (NSInteger) getYMax;
- (NSInteger) getEnergy;
- (NSInteger) getSpeedX;
- (NSUInteger) getHeight;
- (NSUInteger) getWidth;
- (NSUInteger) getImpact;

- (void) setEnergy : (NSInteger) energy;
- (void) setSpeedX : (NSInteger) speedX;

- (void) setX : (NSInteger) x; 
- (void) setY : (NSInteger) y; 

- (void) setWidth : (NSInteger) width; 
- (void) setHeight : (NSInteger) height; 

@end


@interface GameObject : NSObject<GameObjectProtocol> {
 
	NSInteger m_XMin;	
	NSInteger m_XMax;	
	NSInteger m_YMin;	
	NSInteger m_YMax;
 
	NSUInteger m_Impact;
 
	NSInteger m_Energy;
  
	NSInteger m_SpeedX;
} 
  
- (id) initObject : (ObjectInfo*) info;

- (void) dealloc ;

- (void) actionCollision : (GameObject*) obj: (PlayerScore*)  sc;

- (bool) detectCollision : (GameObject*) obj : (PlayerScore*) sc;

- (bool) checkCollisionMask : (GameObject*) obj;

- (void) draw ; 
 
- (void) move : (NSInteger) x: (NSInteger) y;
 
- (NSInteger) getXMin;
- (NSInteger) getYMin;
- (NSInteger) getXMax;
- (NSInteger) getYMax;
- (NSInteger) getEnergy;
- (NSInteger) getSpeedX;
- (NSUInteger) getHeight;
- (NSUInteger) getWidth;
- (NSUInteger) getImpact;
 
- (void) setEnergy : (NSInteger) energy;
- (void) setSpeedX : (NSInteger) speedX;
 
- (void) setX : (NSInteger) x; 
- (void) setY : (NSInteger) y; 

- (void) setWidth : (NSInteger) width; 
- (void) setHeight : (NSInteger) height; 

@end
