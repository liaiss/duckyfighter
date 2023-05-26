//
//  EAGLView.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 28/06/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

#import "EAGLView.h"
#import "Util.h"
#import "ScreenInfo.h"

#define NB_COMPONENT 4

@implementation EAGLView

@synthesize m_Context;

+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

- (void)dealloc
{
	
	if([EAGLContext currentContext] == m_Context) {
		[EAGLContext setCurrentContext:nil];
	}
	
	[m_Context release];
	m_Context = nil;
	
	[super dealloc];
}

- (id)initWithCoder:(NSCoder *)coder
{
	if(nil != (self = [super initWithCoder:coder])) {
		// Get the layer
		CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;
		
		eaglLayer.opaque = YES;
		eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
										[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		
        
		m_Context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if ( (nil == m_Context) || (NO == [EAGLContext setCurrentContext:m_Context]) ) {
			NSLog(@"Failed to create context *****************");
			[self release];
			return nil;
		}
	
        m_AButtonPressed = NO;
        m_BButtonPressed = NO;
        m_IsShaked = NO;
        
        m_ClearRedComponent = 1.0f;
        m_ClearGreenComponent = 1.0f;
        m_ClearBlueComponent = 1.0f;
        m_ClearAlphaComponent = 0.5f;
        
        m_FadeRedComponent = 0.0f;
        m_FadeGreenComponent = 0.0f;
        m_FadeBlueComponent = 0.0f;
        m_FadeAlphaComponent = 0.0f;
        
        m_IsFadeInInProgress = NO;
        m_IsFadeOutInProgress = NO;
        
        super.multipleTouchEnabled = YES;
        
    }    
        
	return self;
}

- (void) setContext {
    [EAGLContext setCurrentContext:m_Context];
}

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)layoutSubviews
{
	[self setContext];
	[self destroyFramebuffer];
	[self createFramebuffer];
	[self drawView];
}

- (void)destroyFramebuffer
{
    glDeleteFramebuffersOES(1, &m_ViewFramebuffer);
	m_ViewFramebuffer = 0;
	
	glDeleteRenderbuffersOES(1, &m_ViewRenderbuffer);
	m_ViewRenderbuffer = 0;
	
	if (m_DepthRenderbuffer) {
		glDeleteRenderbuffersOES(1, &m_DepthRenderbuffer);
		m_DepthRenderbuffer = 0;
	}
}

- (BOOL)createFramebuffer
{
	glGenFramebuffersOES(1, &m_ViewFramebuffer);
	glGenRenderbuffersOES(1, &m_ViewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, m_ViewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, m_ViewRenderbuffer);
	
	[m_Context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
	
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, m_ViewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &m_BackingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &m_BackingHeight);
	
	if(GL_FRAMEBUFFER_COMPLETE_OES != glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES)) {
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	return YES;
}

- (void)setupView
{	
	glMatrixMode(GL_PROJECTION);
	
	// Sets up matrices and transforms for OpenGL ES
	glViewport(0, 0, m_BackingWidth, m_BackingHeight);
	
	glLoadIdentity();
	
	glOrthof (0.0f, m_BackingWidth*1.0f, m_BackingHeight*1.0f, 0.0f, 0.0f, 1.0f);
	
	glDisable(GL_DEPTH_TEST);
	glMatrixMode (GL_MODELVIEW);
	
	// Clears the view with selected color.
 	glClearColor(m_ClearRedComponent, m_ClearGreenComponent, m_ClearBlueComponent, m_ClearAlphaComponent);
	
	// enables option and states needed for using vertex arrays and textures
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
	glEnable (GL_BLEND);
	glBlendFunc (GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	
}

- (void) setClearColor : (CGFloat) red: (CGFloat) green: (CGFloat) blue: (CGFloat) alpha {
    m_ClearRedComponent = red;
    m_ClearGreenComponent = green;
    m_ClearBlueComponent = blue;
    m_ClearAlphaComponent = alpha;
}

- (void) drawFadingMask
{
    NSInteger width;
    NSInteger height;
    
    if (m_IsFadeInInProgress || m_IsFadeOutInProgress) {
        
        width = [[ScreenInfo screenInfo] getWidth];
        height = [[ScreenInfo screenInfo] getHeight];
        
        // Clears the view with selected color.
        Texture2D* fadeTex = [[Texture2D alloc] initWithRect:width:height:m_FadeRedComponent:m_FadeGreenComponent:m_FadeBlueComponent:m_FadeAlphaComponent];
        
        [fadeTex drawAtPoint:0 :0];
        
        [fadeTex release];
    }
}

// Updates the OpenGL view when the timer fires
- (void)drawView
{	
	// Make sure that you are drawing to the current context
	[EAGLContext setCurrentContext:m_Context];
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, m_ViewFramebuffer);

	glClear(GL_COLOR_BUFFER_BIT);
	
    [self setupView];
	
	[self refresh];
	
    [self drawFadingMask];
    
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, m_ViewRenderbuffer);
	[m_Context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (bool) fadeOut {
    bool result = YES;
    
    if (!m_IsFadeInInProgress) {
        m_IsFadeOutInProgress = YES;
        
        if (m_FadeAlphaComponent <= 0.8f)
        {    
            m_FadeAlphaComponent += 0.2f;
            result = NO;
        } else {
            m_FadeAlphaComponent = 1.0f;
            m_IsFadeOutInProgress = NO;
        }
    }
    
    return result;
}

- (bool) fadeIn {
    bool result = YES;
    
    if (!m_IsFadeOutInProgress) {
        
        m_IsFadeInInProgress = YES;
        
        if (m_FadeAlphaComponent >= 0.2f)
        {    
            m_FadeAlphaComponent -= 0.2f;
            result = NO;
        } else {
            m_FadeAlphaComponent = 0.0f;
            m_IsFadeInInProgress = NO;
        }
    }
    
    return result;    
}

- (void) resetFade {
    m_FadeRedComponent = 0.0f;
    m_FadeGreenComponent = 0.0f;
    m_FadeBlueComponent = 0.0f;
    m_FadeAlphaComponent = 0.0f;
}

- (BOOL) isAButtonPressed {
	return m_AButtonPressed; 
}
- (BOOL) isBButtonPressed {
    BOOL result = m_BButtonPressed;
    
    m_BButtonPressed = NO;
    
    return result;
}

- (BOOL) isTouchValidate {
    return m_TouchValidate;
}

- (BOOL) isShaked {
    BOOL returnValue = m_IsShaked;
    
    m_IsShaked = NO;
    
    return returnValue;
}

- (NSInteger) getX {
    return m_SelectedX;
}

- (NSInteger) getY {
	return m_SelectedY;
}

- (NSInteger) getMovedX {
    return m_MovedX;
}

- (NSInteger) getMovedY {
    return m_MovedY;
}

- (void) setMovedX: (NSInteger) newX {
    m_MovedX = newX;
}

- (void) setMovedY: (NSInteger) newY {
    m_MovedY = newY;
}

- (void) resetButton {
    m_AButtonPressed = NO;
	m_BButtonPressed = NO;
	m_TouchValidate = NO;
    m_IsShaked = NO;
	m_SelectedX = 0;
	m_SelectedY = 0;
    m_MovedX = [[ScreenInfo screenInfo] getWidth] / 2;
    m_MovedY = [[ScreenInfo screenInfo] getHeight] / 2;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    CGPoint location = [[touches anyObject] locationInView:self];	
	
	m_SelectedX = location.y;
	m_SelectedY = location.x;
	m_TouchValidate = NO;
	
    m_AButtonPressed = YES;
	
    if ((m_SelectedX > 240) && (m_SelectedY < 110)) {
        m_BButtonPressed = YES;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];	
	
	m_SelectedX = location.y;
	m_SelectedY = location.x;
	m_TouchValidate = YES;
    
    m_AButtonPressed = NO;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    m_MovedX = location.y;
	m_MovedY = location.x;    
}

- (void) refresh {
	[m_ViewController update];
	[m_ViewController draw];
    
}

- (void) updateLevel {
    [m_ViewController update];
}

- (BOOL)isOpaque { 
    return YES; 
}

- (void) setViewController:(DuckyFighterViewController*) viewController {
    m_ViewController = viewController;
}



@end