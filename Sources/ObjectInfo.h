//
//  ObjectInfo.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 26/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

enum {
    WEAPON_DIRECTION_UP = 0,
    WEAPON_DIRECTION_DOWN = 1,
    WEAPON_DIRECTION_LEFT = 2,
    WEAPON_DIRECTION_RIGHT = 3
};

@interface ObjectInfo : NSObject {
    NSInteger m_XPos;	
	NSInteger m_YPos;	
	NSInteger m_Height;	
	NSInteger m_Width;
	
	NSUInteger m_Impact;
	NSInteger m_Energy;
	
	NSInteger m_SpeedX;
	NSInteger m_SpeedY;
	
	NSUInteger m_TimeCountPerFrame;
	NSUInteger m_LoopFrameStart;
	NSUInteger m_Weapon;
	NSUInteger m_WeaponPower;
	NSUInteger m_WeaponX;
    NSUInteger m_WeaponY;
    NSUInteger m_WeaponDirection;
    
	NSMutableArray* m_ResourcesUp;
	NSMutableArray* m_ResourcesDown;
	NSMutableArray* m_ResourcesLeft;
	NSMutableArray* m_ResourcesRight;
	NSMutableArray* m_ResourcesFire;
	NSMutableArray* m_ResourcesMissile;
	NSMutableArray* m_ResourcesExplode;
	
	NSUInteger m_ObjectType;
	
	NSString* m_MoveFile;
	NSString* m_SoundFile;
	NSString* m_IconFile;
    
	bool m_ReservedResource;
}

- (id) initObjectInfo;

- (void) dealloc;

- (NSInteger) getXPos;
- (NSInteger) getYPos;

- (NSInteger) getWidth;
- (NSInteger) getHeight;

- (NSUInteger) getImpact;
- (NSInteger) getEnergy;

- (NSInteger) getSpeedX;
- (NSInteger) getSpeedY;

- (NSUInteger) getObjectType;
- (NSUInteger) getWeapon;
- (NSUInteger) getWeaponPower;
- (NSUInteger) getWeaponX;
- (NSUInteger) getWeaponY;
- (NSInteger) getWeaponDirection;

- (NSMutableArray*) getResourcesUp;
- (NSMutableArray*) getResourcesDown;
- (NSMutableArray*) getResourcesLeft;
- (NSMutableArray*) getResourcesRight;
- (NSMutableArray*) getResourcesFire;
- (NSMutableArray*) getResourcesMissile;
- (NSMutableArray*) getResourcesExplode;

- (NSUInteger) getTimeCountPerFrame;
- (NSUInteger) getLoopFrameStart;

- (NSString*) getMoveFile;
- (NSString*) getIcon;
- (NSString*) getSound;

- (void) setXPos : (NSInteger) xpos;
- (void) setYPos : (NSInteger) ypos;

- (void) setWidth: (NSInteger) width;
- (void) setHeight: (NSInteger) height;

- (void) setImpact : (NSUInteger) impact;
- (void) setEnergy : (NSInteger) energy;

- (void) setSpeedX : (NSInteger) speedX;
- (void) setSpeedY : (NSInteger) speedY;

- (void) setWeapon : (NSUInteger) weapon;
- (void) setWeaponPower : (NSUInteger) weaponPower;
- (void) setWeaponX : (NSUInteger) weaponX;
- (void) setWeaponY : (NSUInteger) weaponY;
- (void) setWeaponDirection : (NSUInteger) direction ;

- (void) setObjectType : (NSUInteger) type;

- (void) addResourceUp:(NSString*) resourceName;
- (void) setResourcesUp:(NSArray*) resourcesName;

- (void) addResourceDown:(NSString*) resourceName;
- (void) setResourcesDown:(NSArray*) resourcesName;

- (void) addResourceLeft:(NSString*) resourceName;
- (void) setResourcesLeft:(NSArray*) resourcesName;

- (void) addResourceRight:(NSString*) resourceName;
- (void) setResourcesRight:(NSArray*) resourcesName;

- (void) addResourceFire:(NSString*) resourceName;
- (void) setResourcesFire:(NSArray*) resourcesName;

- (void) addResourceMissile:(NSString*) resourceName;
- (void) setResourcesMissile:(NSArray*) resourcesName;

- (void) addResourceExplode:(NSString*) resourceName;
- (void) setResourcesExplode:(NSArray*) resourcesName;

- (void) setTimeCountPerFrame: (NSUInteger) timeCountPerFrame;
- (void) setLoopFrameStart: (NSUInteger) loopFrameStart;

- (void) setMoveFile:(NSString*) moveFile;
- (void) setSound:(NSString*) sound;
- (void) setIcon:(NSString*) icon;

- (bool) isReservedResource;
- (void) setReservedResource:(bool) reserved;

@end
