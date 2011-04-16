//
//  ShareScene.mm
//  musicGame
//
//  Created by Max Kolasinski on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareScene.h"


@implementation ShareScene

+(id) scene
{
	CCScene * scene = [CCScene node];
	ShareScene * layer = [ShareScene node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super initWithColor:ccc4(238,232,170,255)])) {
		CCSprite * share = [CCSprite spriteWithFile:@"sharemenu.png"];
		CCSprite * back1 = [CCSprite spriteWithFile:@"back.png"];
		CCSprite * back2 = [CCSprite spriteWithFile:@"back.png"];
		share.scale = .5;
		CCMenuItemSprite * back = [CCMenuItemSprite itemFromNormalSprite:back1 selectedSprite:back2 target:self selector:@selector(backToMain:)];
		share.position = ccp(65, 275);
		[self addChild:share];
		CCMenu * menu = [CCMenu menuWithItems:back,nil];
		menu.position = ccp(480/2,320/2);
		back.scale = .5;
		back.position = ccp(185,-120);
		[self addChild:menu];
	}
	return self;
}

-(void) backToMain:(id)sender
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MenuScene scene]]];
	return;
}
@end
