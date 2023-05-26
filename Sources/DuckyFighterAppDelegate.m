//
//  DuckyFighterAppDelegate.m
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 17/08/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//
#import "DuckyFighterAppDelegate.h"
#import "DuckyFighterViewController.h"
#import "ScreenInfo.h"
#import "Util.h"

@implementation DuckyFighterAppDelegate

@synthesize window;
@synthesize glView;
@synthesize viewController;

//- (BOOL)application:didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {        
    // Override point for customization after app launch    
    // [window addSubview:viewController.view];
    
	
	CGRect bnd = [window bounds];
	
	//TODO: change this workaround better manage iphone flip.
	[[ScreenInfo screenInfo] setWidth:bnd.size.height];
	[[ScreenInfo screenInfo] setHeight:bnd.size.width];
	
	NSLog(@"1 ******************* Screen : %d x %d", [[ScreenInfo screenInfo] getWidth], [[ScreenInfo screenInfo] getHeight]);
	
	[glView setViewController:viewController];
	[viewController setView:glView];
	
	[viewController startGame];
	
    [window makeKeyAndVisible];
    NSLog(@"1 At the end of applicationDidFinishLaunching.");
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [viewController performFinalization];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [viewController performFinalization];
}

- (void)dealloc {
    [viewController release];
	[glView release];
	[window release];
	[super dealloc];
}

@end
