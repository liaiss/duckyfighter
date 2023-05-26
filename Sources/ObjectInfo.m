//
//  ObjectInfo.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 26/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "ObjectInfo.h"

#define RESOURCE_INIT_CAPACITY 5

@implementation ObjectInfo 

- (id) initObjectInfo {

	if (![super init]) {
		return nil; 
	}
	
	m_XPos = 0;
	m_Width = 0;
	m_YPos = 0;
	m_Height = 0;
	m_Impact = 0;
	m_Energy = 0;
	m_SpeedX = 0;
	m_SpeedY = 0;
	m_ObjectType = 0;
	m_WeaponDirection = 2;
	m_ResourcesUp = [[NSMutableArray alloc] initWithCapacity:RESOURCE_INIT_CAPACITY];
	m_ResourcesDown = [[NSMutableArray alloc] initWithCapacity:RESOURCE_INIT_CAPACITY];
	m_ResourcesLeft = [[NSMutableArray alloc] initWithCapacity:RESOURCE_INIT_CAPACITY];
	m_ResourcesRight = [[NSMutableArray alloc] initWithCapacity:RESOURCE_INIT_CAPACITY];
	m_ResourcesFire = [[NSMutableArray alloc] initWithCapacity:RESOURCE_INIT_CAPACITY];
	m_ResourcesMissile = [[NSMutableArray alloc] initWithCapacity:RESOURCE_INIT_CAPACITY];
	m_ResourcesExplode = [[NSMutableArray alloc] initWithCapacity:RESOURCE_INIT_CAPACITY];
	
	m_Weapon = 0;
	m_WeaponPower = 1;
	
	m_TimeCountPerFrame = 0;
	m_LoopFrameStart = 0;
	
	m_MoveFile = nil;
	m_SoundFile = nil;
	m_IconFile = nil;
    
	m_ReservedResource = NO;
	
	return self;
	
}

- (void) dealloc {
	[m_ResourcesUp removeAllObjects];
	[m_ResourcesUp release];
	[m_ResourcesDown removeAllObjects];
	[m_ResourcesDown release];
	[m_ResourcesLeft removeAllObjects];
	[m_ResourcesLeft release];
	[m_ResourcesRight removeAllObjects];
	[m_ResourcesRight release];
	[m_ResourcesFire removeAllObjects];
	[m_ResourcesFire release];
	[m_ResourcesMissile removeAllObjects];
	[m_ResourcesMissile release];
	[m_ResourcesExplode removeAllObjects];
	[m_ResourcesExplode release];
	
	if (m_MoveFile != nil) {
	    [m_MoveFile release];
	}
	
	if (m_SoundFile != nil) {
	    [m_SoundFile release];
	}
    
    if (m_IconFile != nil) {
	    [m_IconFile release];
	}
	
	[super dealloc];
	
	NSLog(@"Release object info");
}

- (NSInteger) getXPos {
	return m_XPos;
}

- (NSInteger) getYPos {
	return m_YPos;
}

- (NSInteger) getWidth {
	return m_Width;
}

- (NSInteger) getHeight {
	return m_Height;
}

- (NSUInteger) getImpact {
    return m_Impact;
}

- (NSInteger) getEnergy {
	return m_Energy;
}

- (NSInteger) getSpeedX {
    return m_SpeedX;
}

- (NSInteger) getSpeedY {
	return m_SpeedY;
}

- (NSUInteger) getWeapon {
    return m_Weapon;
}

- (NSUInteger) getWeaponPower {
    return m_WeaponPower;
}

- (NSUInteger) getWeaponX {
    return m_WeaponX;
}

- (NSUInteger) getWeaponY {
    return m_WeaponY;
}

- (NSInteger) getWeaponDirection {
    return m_WeaponDirection;
}

- (NSUInteger) getObjectType {
    return m_ObjectType;
}

- (bool) isReservedResource {
    return m_ReservedResource;
}

- (void) setXPos : (NSInteger) xpos {
    m_XPos = xpos;
}

- (void) setYPos : (NSInteger) ypos {
    m_YPos = ypos;
}

- (void) setWidth: (NSInteger) width {
    m_Width = width;
}

- (void) setHeight: (NSInteger) height {
	m_Height = height;
}

- (void) setImpact : (NSUInteger) impact {
    m_Impact = impact;
}

- (void) setEnergy : (NSInteger) energy {
    m_Energy = energy;
}

- (void) setSpeedX : (NSInteger) speedX {
    m_SpeedX = speedX;
}

- (void) setSpeedY : (NSInteger) speedY {
	m_SpeedY = speedY;
}

- (void) setObjectType : (NSUInteger) type {
    m_ObjectType = type;
}

- (void) setWeapon : (NSUInteger) weapon {
    m_Weapon = weapon;
}

- (void) setWeaponPower : (NSUInteger) weaponPower {
    m_WeaponPower = weaponPower;
}

- (void) setWeaponX : (NSUInteger) weaponX {
    m_WeaponX = weaponX;
}

- (void) setWeaponY : (NSUInteger) weaponY {
    m_WeaponY = weaponY;
}

- (void) setWeaponDirection : (NSUInteger) direction {
    m_WeaponDirection = direction;
}

- (void) setReservedResource:(bool) reserved {
    m_ReservedResource = reserved;
}

- (NSMutableArray*) getResourcesUp {
    return m_ResourcesUp;
}

- (void) addResourceUp:(NSString*) resourceName {
    [m_ResourcesUp addObject:resourceName];
}

- (void) setResourcesUp:(NSArray*) resourcesName {
	[m_ResourcesUp addObjectsFromArray:resourcesName];
}

- (NSMutableArray*) getResourcesDown{
	return m_ResourcesDown;
}

- (void) addResourceDown:(NSString*) resourceName{
	[m_ResourcesDown addObject:resourceName];
}

- (void) setResourcesDown:(NSArray*) resourcesName {
	[m_ResourcesDown addObjectsFromArray:resourcesName];
}

- (NSMutableArray*) getResourcesLeft {
	return m_ResourcesLeft;
}

- (void) addResourceLeft:(NSString*) resourceName{
	[m_ResourcesLeft addObject:resourceName];
}

- (void) setResourcesLeft:(NSArray*) resourcesName {
	[m_ResourcesLeft addObjectsFromArray:resourcesName];
}


- (NSMutableArray*) getResourcesRight{
	return m_ResourcesRight;
}

- (void) addResourceRight:(NSString*) resourceName{
	[m_ResourcesRight addObject:resourceName];
}

- (void) setResourcesRight:(NSArray*) resourcesName {
	[m_ResourcesRight addObjectsFromArray:resourcesName];
}


- (NSMutableArray*) getResourcesFire{
	return m_ResourcesFire;
}

- (void) addResourceFire:(NSString*) resourceName {
	[m_ResourcesFire addObject:resourceName];
}

- (void) setResourcesFire:(NSArray*) resourcesName {
	[m_ResourcesFire addObjectsFromArray:resourcesName];
}

- (NSMutableArray*) getResourcesMissile{
	return m_ResourcesMissile;
}

- (void) addResourceMissile:(NSString*) resourceName {
	[m_ResourcesMissile addObject:resourceName];
}

- (void) setResourcesMissile:(NSArray*) resourcesName {
	[m_ResourcesMissile addObjectsFromArray:resourcesName];
}

- (NSMutableArray*) getResourcesExplode {
    return m_ResourcesExplode;
}

- (void) addResourceExplode:(NSString*) resourceName {
	[m_ResourcesExplode addObject:resourceName];
}

- (void) setResourcesExplode:(NSArray*) resourcesName {
	[m_ResourcesExplode addObjectsFromArray:resourcesName];
}

- (NSUInteger) getTimeCountPerFrame{
	return m_TimeCountPerFrame;
}

- (void) setTimeCountPerFrame: (NSUInteger) timeCountPerFrame {
    m_TimeCountPerFrame = timeCountPerFrame;
}

- (NSUInteger) getLoopFrameStart {
    return m_LoopFrameStart;
}

- (void) setLoopFrameStart: (NSUInteger) loopFrameStart {
	m_LoopFrameStart = loopFrameStart;
}

- (NSString*) getMoveFile {
    return m_MoveFile;
}

- (NSString*) getSound {
    return m_SoundFile;
}

- (NSString*) getIcon {
    return m_IconFile;
}

- (void) setMoveFile:(NSString*) moveFile {
	if (m_MoveFile != nil) {
	    [m_MoveFile release];
	}
    m_MoveFile = moveFile;
	[m_MoveFile retain];
}

- (void) setSound:(NSString*) sound {
	if (m_SoundFile != nil) {
	    [m_SoundFile release];
	}
    m_SoundFile = sound;
	[m_SoundFile retain];
}

- (void) setIcon:(NSString*) iconFile {
    if (m_IconFile != nil) {
	    [m_IconFile release];
	}
    
    m_IconFile = iconFile;
	[m_IconFile retain];
}

@end