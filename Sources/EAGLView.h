//
//  EAGLView.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 28/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/CAEAGLLayer.h>

#import "DuckyFighterViewController.h"


@interface EAGLView : UIView
{
    
@private
    DuckyFighterViewController* m_ViewController;
    
	EAGLContext *m_Context;
	/* OpenGL names for the renderbuffer and framebuffers used to render to this view */
	GLuint m_ViewRenderbuffer;
	GLuint m_ViewFramebuffer;
	
	/* OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist) */
	GLuint m_DepthRenderbuffer;
	
	/* The pixel dimensions of the backbuffer */
	GLint m_BackingWidth;
	GLint m_BackingHeight;
	
	NSInteger m_SelectedX;
	NSInteger m_SelectedY;
    
    NSInteger m_MovedX;
    NSInteger m_MovedY;
	
    CGFloat m_ClearRedComponent;
    CGFloat m_ClearGreenComponent;
    CGFloat m_ClearBlueComponent;
    CGFloat m_ClearAlphaComponent;
    
    CGFloat m_FadeRedComponent;
    CGFloat m_FadeGreenComponent;
    CGFloat m_FadeBlueComponent;
    CGFloat m_FadeAlphaComponent;
    
    bool m_IsFadeInInProgress;
    bool m_IsFadeOutInProgress;
    
	bool m_AButtonPressed;
	bool m_BButtonPressed;
	bool m_TouchValidate;
    bool m_IsShaked;
}

/* Declare EAGL context as property. */
@property  (nonatomic, retain) EAGLContext *m_Context;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;
- (void) drawView;
- (void) setContext;

- (BOOL) isAButtonPressed;
- (BOOL) isBButtonPressed;
- (BOOL) isTouchValidate;
- (BOOL) isShaked;

- (void) resetButton;

- (NSInteger) getX;
- (NSInteger) getY;
- (NSInteger) getMovedX;
- (NSInteger) getMovedY;

- (void) setMovedX: (NSInteger) newX;
- (void) setMovedY: (NSInteger) newY;

- (bool) fadeOut;

- (bool) fadeIn;

- (void) resetFade;

- (void) setClearColor : (CGFloat) red: (CGFloat) green: (CGFloat) blue: (CGFloat) alpha;

- (void) setViewController:(DuckyFighterViewController*) viewController;

- (void) updateLevel; 

- (void) refresh; 

@end
