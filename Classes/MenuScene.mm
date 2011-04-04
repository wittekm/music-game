//
//  untitled.mm
//  musicGame
//
//  Created by Max Kolasinski on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import <sqlite3.h>
#import <iostream>
#import "SqlHandler.h"
#import "GameScene.h"
#import "osu-import.h.mm"

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
		
		CCSprite * background = [CCSprite spriteWithFile:@"titlebackground.png"];
		background.position = ccp(480/2, 320/2);
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
			//iPhone 4
			[background setScale:0.5];
		}
		[self addChild:background];
		CCSprite * welcome = [CCSprite spriteWithFile:@"welcome.png"];
		welcome.position = ccp(480/2, 200);
		[self addChild: welcome];
		CCSprite* startdemo = [CCSprite spriteWithFile:@"startdemo.png"];
		CCSprite* startdemo2 = [CCSprite spriteWithFile:@"startdemo.png"];
		//startdemo.position = ccp(480/2, 100);
		//startdemo2.position = ccp(480/2, 100);
		//[CCMenuItemFont setFontSize:30];
		//[CCMenuItemFont setFontName: @"Courier New"];
		
		//CCMenuItem *item1 = [CCMenuItemFont itemFromString: @"Press me to start!!" target: self selector:@selector(menuCallbackStart:)];
		CCMenuItemSprite * item2 = [CCMenuItemSprite itemFromNormalSprite:startdemo selectedSprite:startdemo2 target: self selector:@selector(menuCallbackStart:)];
		CCMenu *menu = [CCMenu menuWithItems:
						item2, nil];
		menu.position = ccp(480/2, 100);
		[self addChild: menu];
		
	}
	return self;
}
-(void) menuCallbackStart: (id) sender
{
	SqlHandler * handler = [[SqlHandler alloc] init];
	// lists all the beatmaps
	for(SqlRow * row in [handler beatmaps]) {
		NSLog(@"%@ - %@", [row artist], [row title]);
	}
	Beatmap * beatmap = [[[handler beatmaps] objectAtIndex:1] getBeatmap];
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameScene sceneWithBeatmap:beatmap]]];
	//[(CCMultiplexLayer*)parent_ switchTo:2];
}

@end