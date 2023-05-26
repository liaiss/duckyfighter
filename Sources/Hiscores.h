//
//  Hiscores.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface Hiscores : NSObject {
	NSMutableArray* m_NameList;
    NSMutableArray* m_ScoreList;
    
	NSInteger m_LowScore;
}

- (id) initHiScore;
	
- (void) dealloc;

- (void) addScore : (NSString*) name : (NSInteger) value;

- (void) loadHiScore;

- (void) saveHiScore;

- (void) draw : (NSInteger) x : (NSInteger) y;

- (NSInteger) getLowScore;

+ (Hiscores*) hiscores;

@end
