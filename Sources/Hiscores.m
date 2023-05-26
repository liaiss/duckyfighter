//
//  Hiscores.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "Hiscores.h"
#import "TextManager.h"

@implementation Hiscores

#define MAX_ENTRY_COUNT 5
#define INIT_MIN_SCORE 100000

#define SELECTED_FONT_SIZE 36
#define UNSELECTED_FONT_SIZE 30

- (id) initHiScore {
    
    if (![super init]) {
        return nil;
    }
    
    m_NameList = [[NSMutableArray alloc] initWithCapacity:MAX_ENTRY_COUNT];
    m_ScoreList = [[NSMutableArray alloc] initWithCapacity:MAX_ENTRY_COUNT];
     
    for (NSInteger i = MAX_ENTRY_COUNT - 1; i >= 0; --i) {
        [m_NameList addObject:@"AAA"];
        NSNumber* score = [NSNumber numberWithUnsignedInt:((i+1)*INIT_MIN_SCORE)];
        [m_ScoreList addObject:score];
    }
    
    m_LowScore = INIT_MIN_SCORE;
    
    return self;
}

- (void) dealloc {

    [m_NameList removeAllObjects];
    [m_NameList release];
    [m_ScoreList removeAllObjects];
    [m_ScoreList release];
    [super dealloc];
}

- (void) addScore : (NSString*) name : (NSInteger) value {

    if (value > m_LowScore) {
  
        for (NSInteger i = [m_ScoreList count] - 1; i >= 0; --i) {
            if (value < [(NSNumber*)[m_ScoreList objectAtIndex:i] unsignedIntValue]) {
                if (i == [m_ScoreList count] - 2) {
                    m_LowScore = value;
                }
                
                [m_NameList insertObject:name atIndex:i+1];
                
                NSNumber* score = [NSNumber numberWithInt:value];
                [m_ScoreList insertObject:score atIndex:i+1];
                
                [m_NameList removeLastObject];
                [m_ScoreList removeLastObject];
                break;
            }
        }
    }
}

- (void) loadHiScore {
   
    NSData *data;
    NSString *error;
    NSPropertyListFormat format;
    NSDictionary* propertyList;
    
    NSArray* nameList;
    NSArray* scoreList;
    NSNumber* lowScore;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"Hiscore.plist"];
    data = [[NSData alloc] initWithContentsOfFile:appFile];
    
    if (!data) {
        NSLog(@"Data file not returned.");
    } else {
        propertyList = (NSDictionary*) [NSPropertyListSerialization propertyListFromData:data  mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
        
        if (!propertyList){
            NSLog(@"Plist not returned, error: %@", error);
        } else {
            // Get field read from settings.plist file
            
            nameList = (NSArray*) [propertyList objectForKey:@"NameList"];
            [m_NameList removeAllObjects];
            [m_NameList addObjectsFromArray:nameList];
            
            scoreList = (NSArray*) [propertyList objectForKey:@"ScoreList"]; 
            [m_ScoreList removeAllObjects];
            [m_ScoreList addObjectsFromArray:scoreList];
            
            if ([m_ScoreList count] > 0) {
                lowScore = (NSNumber*) [m_ScoreList objectAtIndex:[m_ScoreList count] - 1];
                m_LowScore = [lowScore unsignedIntValue];
            } else {
                m_LowScore = 0;
            }
        }
        
        [data release];
    }
}

- (void) saveHiScore {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"Hiscore.plist"];
    NSString *error;
    NSMutableDictionary* propertyList = (NSMutableDictionary*) [[NSMutableDictionary alloc] initWithCapacity:2];
    
    if (!propertyList){
        NSLog(@"Plist not returned, error.");
    } else {
        
        // Get field read from settings.plist file
        [propertyList setValue:m_NameList forKey:@"NameList"];
        [propertyList setValue:m_ScoreList forKey:@"ScoreList"];
    
        NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:propertyList
                                                                       format:NSPropertyListXMLFormat_v1_0
                                                             errorDescription:&error];
        if (plistData) {
            [plistData writeToFile:appFile atomically:YES];
        } else {
            NSLog(@"%@", error);
           [error release];
        }
        
        [propertyList release];
    }
    
}

- (void) draw : (NSInteger) x : (NSInteger) y {

    NSInteger newX = x;
	NSInteger newY = y;
    CGSize dimension;
    
    dimension.width = 80;
	dimension.height = 40;
    
    [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
    [[TextManager textManager] drawText:@"Name":dimension:SELECTED_FONT_SIZE :newX: newY];
    
    newX += dimension.width * 2 ;
    
    [[TextManager textManager] setColor:0.7:0.2:0.2:1.0];
    [[TextManager textManager] drawText:@"Score":dimension:SELECTED_FONT_SIZE :newX: newY];
    
    [[TextManager textManager] setColor:0.0:0.0:0.0:1.0];
    newY -= dimension.height; 
    dimension.height = 40;
    for (NSInteger i = 0; i < [m_NameList count]; ++i) {
       
        dimension.width = 80;
        newX = x;

        [[TextManager textManager] drawText:[m_NameList objectAtIndex:i]:dimension:UNSELECTED_FONT_SIZE :newX: newY];
    
        newX += dimension.width + (dimension.width / 2) + 10 ;
        dimension.width = 150;
        NSString* scoreText = [[NSString alloc] initWithFormat:@"%@", [m_ScoreList objectAtIndex:i]];
        [[TextManager textManager] drawText:scoreText:dimension:UNSELECTED_FONT_SIZE :newX: newY];
        [scoreText release]; 
        newY -= dimension.height; 
    }
}

- (NSInteger) getLowScore {
    return m_LowScore;
}

+ (Hiscores*) hiscores {
    static Hiscores *instance = nil;
	
    if (instance == nil) {
        instance = [[Hiscores alloc] initHiScore];
    }
	
    return instance;
}


@end
