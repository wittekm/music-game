//
//  OptionsScene.mm
//  musicGame
//
//  Created by Max Kolasinski on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OptionsScene.h"
#import "Globals.h"
#import "HelpScene.h"

@implementation OptionsScene

+(id) scene
{
	CCScene * scene = [CCScene node];
	OptionsScene * layer = [OptionsScene node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super initWithColor:ccc4(238,232,170,255)])) {
		CCSprite * options = [CCSprite spriteWithFile:@"options.png"];
		/*CCSprite * help1 = [CCSprite spriteWithFile:@"help.png"];
		 CCSprite * help2 = [CCSprite spriteWithFile:@"help.png"];
		 CCMenuItemSprite * failred = [CCSprite spriteWithFile:@"failred.png"];
		 CCMenuItemSprite * failgreen = [CCSprite spriteWithFile:@"failgreen.png"];
		 CCSprite * back1 = [CCSprite spriteWithFile:@"back.png"];
		 CCSprite * back2 = [CCSprite spriteWithFile:@"back.png"];*/
		CCSprite * help1 = [CCSprite spriteWithFile:@"help.png"];
		CCSprite * help2 = [CCSprite spriteWithFile:@"help.png"];
		CCSprite * back1 = [CCSprite spriteWithFile:@"back.png"];
		CCSprite * back2 = [CCSprite spriteWithFile:@"back.png"];
		CCMenuItem *failOnItem = [CCMenuItemImage itemFromNormalImage:@"failgreen.png"
														selectedImage:@"failgreen.png"
															   target:nil
															 selector:nil];
		
		CCMenuItem *failOffItem = [CCMenuItemImage itemFromNormalImage:@"failred.png"
														 selectedImage:@"failred.png"
																target:nil
															  selector:nil];
		CCMenuItemToggle * failToggleItem;
		if( [[Globals sharedInstance] fail] == true){
			failToggleItem = [CCMenuItemToggle itemWithTarget:self
													 selector:@selector(toggleFailure:)
														items:failOnItem, failOffItem, nil];
		}
		else{
			failToggleItem = [CCMenuItemToggle itemWithTarget:self
													 selector:@selector(toggleFailure:)
														items:failOffItem, failOnItem, nil];
		}
		options.scale = .5;
		CCMenuItemSprite * help = [CCMenuItemSprite itemFromNormalSprite:help1 selectedSprite:help2 target:self selector:@selector(viewHelp:)];
		CCMenuItemSprite * back = [CCMenuItemSprite itemFromNormalSprite:back1 selectedSprite:back2 target:self selector:@selector(backToMain:)];
		options.position = ccp(75, 270);
		//help.position = ccp(480/2, 200);
		[self addChild:options];
		//[self addChild:help];
		CCMenu * menu = [CCMenu menuWithItems:failToggleItem,help,back,nil];
		menu.position = ccp(480/2,320/2);
		back.scale = .5;
		back.position = ccp(185,-120);
		help.position = ccp(0,60);
		failToggleItem.position = ccp(0,-50);
		[self addChild:menu];
	}
	return self;
}

-(void) toggleFailure: (id) sender
{
	if( [[Globals sharedInstance] fail] == true){
		[Globals sharedInstance].fail = false;
	}
	else{
		[Globals sharedInstance].fail = true;
	}
	NSLog(@"fail is %d",[Globals sharedInstance].fail);
	return;
}

-(void) viewHelp: (id) sender
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[HelpScene scene]]];
}

-(void) backToMain:(id)sender
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MenuScene scene]]];
}
@end
