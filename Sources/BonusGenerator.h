//
//  BonusGenerator.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 28/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "GameObject.h"
#import "StaticObject.h"
#import "PlayerScore.h"
#import "ObjectTable.h"

@interface BonusGenerator : StaticObject {
    ObjectTable*  m_BonusTable;
	bool m_IsBonusGenerated;
}

- (id) initBonusGenerator : (ObjectInfo*) info;

- (void) actionCollision: (GameObject*) obj: (PlayerScore*) sc;

- (void) setLevelStepDisplayedBonusTable : (ObjectTable*) bonusTable;

@end
