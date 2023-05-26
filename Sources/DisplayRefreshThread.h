//
//  DisplayRefreshThread.h
//  Ducky Fighter
//
//  Created by Liaiss Merzougue on 21/05/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface DisplayRefreshThread : NSObject{
    NSThread* m_Thread;
	UIView* m_Display;
	
	bool m_IsStop;
}

- (id) initRefreshThread:(UIView*) display;

- (void) displayRefresh;

- (void) stop;

@end
