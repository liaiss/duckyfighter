//
//  Util.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 19/04/09.
//  Copyright 2009 Creative Infinity. All rights reserved.
//
#import "Util.h"
#import "ScreenInfo.h"

@implementation Util

+ (UIImage*) loadUIImage : (NSString*) name {
	NSString* imagePath = [[NSBundle mainBundle] pathForResource:name ofType:@"png"]; 
	
	UIImage* image = [[UIImage alloc] initWithContentsOfFile:imagePath];

	if (image == nil) {
	    NSLog(@"load UIImage : Image %@ (%@) is nil", name, imagePath);
	}
	
    return image;
}

+ (NSInteger) positiveSubstract: (NSInteger) x: (NSInteger) y {
    if (x > y) {
	    return (x - y);
	} else {
		return (y - x);
	}
}


@end
