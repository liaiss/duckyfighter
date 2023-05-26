//
//  LayerManager.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 03/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "LayerManager.h"
#import "Util.h"

@implementation LayerManager

- (id) initLayerManager: (NSUInteger) capacity {
    
	if (![super init]) {
		return nil; 
	}
	
    m_dictionnary = [[NSMutableDictionary alloc] initWithCapacity: capacity];
	m_reservedDictionnary = [[NSMutableDictionary alloc] initWithCapacity: capacity];
	
	return self;
}

- (void) dealloc {
	[m_dictionnary removeAllObjects];
	[m_dictionnary release];
	[m_reservedDictionnary removeAllObjects];
	[m_reservedDictionnary release];
    [super dealloc];
}

- (void) clearLayerManager {
	[m_dictionnary removeAllObjects];
}

- (void) clearReservedLayerManager {
	[m_reservedDictionnary removeAllObjects];
}

- (Layer*) getLayer:(NSString*) resourceName: (bool) reserved {
	NSMutableDictionary* selectedDict = nil;
	Layer* layer = nil;
	
	if (reserved) {
		selectedDict = m_reservedDictionnary;
	} else {
		selectedDict = m_dictionnary;
	}

	if ((resourceName != nil) && ([resourceName length] != 0)) {  
		
		layer = (Layer*) [selectedDict objectForKey:resourceName];
	
	    if ( layer == nil) {
		    // We don't find a layer with this key, create new one.
			
	        layer = [[Layer alloc] initLayer:resourceName:YES];	
		    //NSLog(@"Create Layer with shadow: %@ (0x%x)", resourceName, layer);
            [selectedDict setObject:layer forKey:resourceName];
            NSLog(@"Load resource: %@ - 0x%x\n", resourceName, layer);

            [layer release];
	    }
       /* else {
            NSLog(@"Get Layer with shadow: %@ (0x%x)", resourceName, layer);
        }*/
        
	}
	
	return layer;
}

- (Layer*) getLayerWithoutShadow:(NSString*) resourceName: (bool) reserved {
	Layer* layer = nil;
	NSMutableDictionary* selectedDict = nil;
	
	if (reserved) {
		selectedDict = m_reservedDictionnary;
	} else {
		selectedDict = m_dictionnary;
	}
	
	if ((resourceName != nil) && ([resourceName length] != 0)) {  
	    // search for an already existing layer
	    layer = (Layer*) [selectedDict objectForKey:resourceName];
	
	    if ( layer == nil) {
            
		    // We don't find a layer with this key, create new one.
		    layer = [[Layer alloc] initLayer:resourceName:NO];
            NSLog(@"Load resource: %@ - 0x%x\n", resourceName, layer);
           // NSLog(@"Create Layer without shadow: %@ (0x%x)", resourceName, layer);
            [selectedDict setObject:layer forKey:resourceName];
            [layer release];
	    }
        /*else {
            NSLog(@"Get Layer without shadow: %@ (0x%x)", resourceName, layer);
        }*/

	}
	
	return layer;
}

+ (LayerManager*) layerManager {
    static LayerManager *instance = nil;
	
    if (instance == nil) {
        instance = [[LayerManager alloc] initLayerManager:10];
    }
	
    return instance;
}

- (void) displayPics {
    Layer* layer = nil;
    NSArray *keys = [m_dictionnary allKeys];
    NSInteger x = 0;
    NSInteger y = 0;
    
    for (int i = 0; i < [keys count]; ++i) {
        layer = (Layer*) [m_dictionnary objectForKey:[keys objectAtIndex:i]];
        [layer draw:x:y];
        x += [layer getWidth];
        if (x >= 480) {
            x = 0;
            y += [layer getHeight];
        }
    }
    
    
}

@end
