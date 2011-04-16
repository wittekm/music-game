//
//  CCNodeExtension.h
//  musicGame
//
//  Created by Max Wittek on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"


@interface CCNode (PauseResumeStuff)

- (void)resumeTimersForHierarchy;

- (void)pauseTimersForHierarchy;

@end
