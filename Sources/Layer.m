//
//  Layer.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 03/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import "Layer.h"
#import "Util.h"

@implementation Layer

- (id) initLayer: (NSString*) resourceName : (bool) useShadow {
    
	if ([super init] == nil) {
	    return nil;
	}
    
    UIImage* image = [Util loadUIImage:resourceName];
    
	m_Layer = [[Texture2D alloc]initWithImage:image:useShadow];
	    
	CGSize size = m_Layer.contentSize;
	
	m_Width = size.width;
	m_Height = size.height;
	
    [image release];
    
	return self;
}

- (void) dealloc {
	[m_Layer release];
	
	[super dealloc];
}

- (void) draw:(NSInteger)x : (NSInteger) y {

	if (m_Layer != nil) {
		[m_Layer drawAtPoint:x:y];
	}
}

- (NSUInteger) getWidth {
	return m_Width;
}

- (NSUInteger) getHeight {
	return m_Height;
}

@end
