//
//  untitled.mm
//  musicGame
//
//  Created by Max Kolasinski on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelloWorldScene.h"

@implementation Layer1
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Layer2 *layer = [Layer1 node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init])) {
		
		[CCMenuItemFont setFontSize:30];
		[CCMenuItemFont setFontName: @"Courier New"];
		
		CCMenuItem *item1 = [CCMenuItemFont itemFromString: @"Press me to start!!" target: self selector:@selector(menuCallbackStart:)];
		CCMenu *menu = [CCMenu menuWithItems:
						item1, nil];
		[self addChild: menu];
		
	}
	return self;
}
-(void) menuCallbackStart: (id) sender
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[Layer2 scene]]];
	//[(CCMultiplexLayer*)parent_ switchTo:2];
}

@end