//
//  WeaponFactory.m
//  DuckyFighter
//
//  Created by Liaiss Merzougue on 24/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WeaponFactory.h"
#import "Level.h"
#import "Weapon.h"

#define MAX_WEAPON_DIRECTION 10
#define MAX_WEAPON_ID 8

NSString* m_MoveFiles[MAX_WEAPON_DIRECTION][MAX_WEAPON_ID] = 
{
    {     @"Move-Down", @"Move-Down",      @"Move-DownLeft", @"Move-DownRight", @"",             @"",         @"",          @""},
    {       @"Move-Up", @"Move-Up",        @"Move-UpLeft",   @"Move-UpRight",   @"",             @"",         @"",          @""},
    {     @"Move-Left", @"Move-Left",      @"Move-UpLeft",   @"Move-DownLeft",  @"",             @"",         @"",          @""},
    {    @"Move-Right", @"Move-Right",     @"Move-UpRight",  @"Move-DownRight", @"",             @"",         @"",          @""},
    {  @"Move-UpRight", @"Move-UpRight",   @"Move-Up",       @"Move-Right",     @"",             @"",         @"",          @""},
    {   @"Move-UpLeft", @"Move-UpLeft",    @"Move-Up",       @"Move-Left",      @"",             @"",         @"",          @""},
    {@"Move-DownRight", @"Move-DownRight", @"Move-Down",     @"Move-Right",     @"",             @"",         @"",          @""},
    { @"Move-DownLeft", @"Move-DownLeft",  @"Move-Down",     @"Move-Left",      @"",             @"",         @"",          @""},
    {       @"Move-Up", @"Move-Down",      @"Move-UpLeft",   @"Move-DownLeft",  @"Move-UpRight", @"Move-DownRight", @"Move-Left", @"Move-Right"},
};

@implementation WeaponFactory


+ (void) createWeapon : (WeaponTable*) weaponTable: (NSInteger) weaponId: (NSInteger) weaponType: (NSInteger) firePower : (NSInteger) direction :(NSInteger) x: (NSInteger) y {

    if (direction < MAX_WEAPON_DIRECTION)
    {
        Weapon* weapon1;
        Weapon* weapon11 = nil;
        Weapon* weapon2 = nil;
        Weapon* weapon3 = nil;
        Weapon* weapon4 = nil;
    
        if (firePower > 0)
        {
            weapon1 = [[Level level] createWeapon:weaponId:weaponType:x:y];
    
            if (firePower >= 3) {
                weapon4 = [[Level level] createWeapon:weaponId:weaponType:x: y +  ([weapon1 getHeight] / 2)]; 
                [weapon4 loadMoveFile:m_MoveFiles[direction][3]];
                [weaponTable addWeapon : weapon4];
                [weapon4 release];
        
                weapon3 = [[Level level] createWeapon:weaponId:weaponType:x: y - ([weapon1 getHeight] / 2)]; 
               [weapon3 loadMoveFile:m_MoveFiles[direction][2]];
               [weaponTable addWeapon : weapon3];
               [weapon3 release];
            }
    
            if (firePower >= 2) {
                weapon2 = [[Level level] createWeapon:weaponId:weaponType:x:(y + ([weapon1 getHeight] / 2))];
                [weapon2 loadMoveFile:m_MoveFiles[direction][1]];
                [weaponTable addWeapon : weapon2];
                [weapon2 release];
            }
    
            if (firePower >= 1) {
                weapon11 = [[Level level] createWeapon:weaponId:weaponType:x:(y - ([weapon1 getHeight] / 2))];
                [weapon11 loadMoveFile:m_MoveFiles[direction][0]];
                [weaponTable addWeapon :weapon11];
                [weapon11 release];
            }
    
            [weapon1 release];
	    }
    }
}


@end
