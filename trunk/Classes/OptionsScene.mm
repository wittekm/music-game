//
//  OptionsScene.mm
//  musicGame
//
//  Created by Max Kolasinski on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "OptionsScene.h"



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
		CCMenuItemSprite * failred = [CCSprite spriteWithFile:@"failred.png"];
		CCMenuItemSprite * failgreen = [CCSprite spriteWithFile:@"failgreen.png"];
		CCSprite * back1 = [CCSprite spriteWithFile:@"back.png"];
		CCSprite * back2 = [CCSprite spriteWithFile:@"back.png"];
		failred.scale = .5;
		failgreen.scale = .5;
		options.scale = .5;
		//help.scale = .5;
		CCMenuItemToggle * fail = [CCMenuItemToggle itemWithTarget:self selector:@selector(toggleFailure:) items:failred, failgreen, nil];
		CCMenuItemSprite * help = [CCMenuItemSprite itemFromNormalSprite:help1 selectedSprite:help2 target:self selector:@selector(viewHelp:)];
		CCMenuItemSprite * back = [CCMenuItemSprite itemFromNormalSprite:back1 selectedSprite:back2 target:self selector:@selector(backToMain:)];
		options.position = ccp(75, 270);
		help.position = ccp(480/2, 200);
		[self addChild:options];
		[self addChild:help];
		CCMenu * menu = [CCMenu menuWithItems:fail,help,back,nil];
		menu.scale = .5;
		[self addChild:menu];
	}
	return self;
}
								   
-(void) toggleFailure: (id) sender
{
	return;
}

-(void) viewHelp: (id) sender
{
	return;
}

-(void) backToMain:(id)sender
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MenuScene scene]]];

}
@end
