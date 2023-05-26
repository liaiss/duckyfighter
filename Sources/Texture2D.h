//
//  Texture2D.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 28/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <OpenGLES/ES1/gl.h>

typedef enum {
	kTexture2DPixelFormat_Automatic = 0,
	kTexture2DPixelFormat_RGBA8888,
	kTexture2DPixelFormat_RGB565,
	kTexture2DPixelFormat_A8,
} Texture2DPixelFormat;

@interface Texture2D : NSObject {

	GLuint						_name;
	CGSize						_size;
	NSUInteger					_width,
								_height;
	Texture2DPixelFormat		_format;
	GLfloat						_maxS,
								_maxT;
}

@property(readonly) Texture2DPixelFormat pixelFormat;
@property(readonly) NSUInteger pixelsWide;
@property(readonly) NSUInteger pixelsHigh;

@property(readonly) GLuint name;

@property(readonly, nonatomic) CGSize contentSize;
@property(readonly) GLfloat maxS;
@property(readonly) GLfloat maxT;


- (id) initWithData:(const void*)data pixelFormat:(Texture2DPixelFormat)pixelFormat pixelsWide:(NSUInteger)width pixelsHigh:(NSUInteger)height contentSize:(CGSize)size;
- (id) initWithRect:(NSInteger) rectWidth :(NSInteger) rectHeight:(CGFloat) red: (CGFloat)green:(CGFloat) blue: (CGFloat) alpha;

- (id) initWithImage:(UIImage *)uiImage:(BOOL) isShadowEnabled;
- (id) initWithString:(NSString*)string dimensions:(CGSize)dimensions alignment:(UITextAlignment)alignment fontName:(NSString*)name fontSize:(CGFloat)size 
             redColor:(CGFloat) red greenColor:(CGFloat) green blueColor:(CGFloat) blue alphaColor:(CGFloat) alpha stroke:(bool)isStrokeEnabled;

- (void) drawAtPoint:(NSInteger)x:(NSInteger) y;
- (void) drawInRect:(CGRect)rect;

@end
