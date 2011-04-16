//
//  CCNodeExtension.m
//  musicGame
//
//  Created by Max Wittek on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCNodeExtension.h"


@implementation CCNode (PauseResumeStuff)

- (void)resumeTimersForHierarchy
{
	for (CCNode* child in [self children])
	{
		[child resumeTimersForHierarchy];
	}
	@try {
		[self resumeSchedulerAndActions];
	}
	@catch (NSException * e) {}
}

- (void)pauseTimersForHierarchy
{
	@try {
		[self pauseSchedulerAndActions];
	}
	@catch (NSException * e) {}
	
	for (CCNode* child in [self children])
	{
		[child pauseTimersForHierarchy];
	}
}

@end
