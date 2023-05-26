//
//  LayerManager.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 03/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "Layer.h"

@interface LayerManager : NSObject {
    NSMutableDictionary* m_dictionnary;
	NSMutableDictionary* m_reservedDictionnary;
}

- (void) dealloc;

- (Layer*) getLayer:(NSString*) resourceName: (bool) reserved;

- (Layer*) getLayerWithoutShadow:(NSString*) resourceName: (bool) reserved;

- (void) clearLayerManager;

- (void) clearReservedLayerManager;

- (void) displayPics;

+ (LayerManager*) layerManager;

@end
