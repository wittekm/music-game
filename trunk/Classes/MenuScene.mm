//
//  untitled.mm
//  musicGame
//
//  Created by Max Kolasinski on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import <sqlite3.h>
#import <iostream>
#import "SqlHandler.h"

@implementation MenuScene
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [MenuScene node];
	
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
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameScene scene]]];
	//[(CCMultiplexLayer*)parent_ switchTo:2];
}

@end