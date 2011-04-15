//
//  HelpScene.mm
//  musicGame
//
//  Created by Max Kolasinski on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelpScene.h"


@implementation HelpScene

+(id) scene
{
	CCScene * scene = [CCScene node];
	HelpScene * layer = [HelpScene node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	
if( (self=[super initWithColor:ccc4(238,232,170,255)])) {

	CCLabelTTF * derp = [CCLabelTTF labelWithString:@"derp derp" fontName:@"hellovetica" fontSize:40];
	derp.position = ccp(480/2,320/2);
	CCSprite * back1 = [CCSprite spriteWithFile:@"back.png"];
	CCSprite * back2 = [CCSprite spriteWithFile:@"back.png"];
	CCMenuItemSprite * back = [CCMenuItemSprite itemFromNormalSprite:back1 selectedSprite:back2 target:self selector:@selector(backToOptions:)];
	CCMenu * menu = [CCMenu menuWithItems:back,nil];
	menu.position = ccp(480/2,320/2);
	back.scale = .5;
	back.position = ccp(185,-120);
	[self addChild:derp];
	[self addChild:menu];
	}
	return self;
}
-(void) backToOptions:(id)sender
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[OptionsScene scene]]];
	return;
}
@end
