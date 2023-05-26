//
//  Layer.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 03/06/09.
//  Copyright 2009 Liaiss Merzougue. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "Texture2D.h"

@interface Layer : NSObject {
	Texture2D* m_Layer;
	
	NSUInteger m_Width;
	NSUInteger m_Height;
}

- (id) initLayer: (NSString*) resourceName : (bool) useShadow;

- (void) dealloc;

- (void) draw:(NSInteger)x : (NSInteger) y;

- (NSUInteger) getWidth;

- (NSUInteger) getHeight;

@end
