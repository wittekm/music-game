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
	self.isTouchEnabled = YES;
	id toRed = [CCTintTo actionWithDuration: 0.5 red:255 green: 0 blue: 0];
	id fromRed = [CCTintTo actionWithDuration:0.5 red:255 green:255 blue:255];
	id toBlue = [CCTintTo actionWithDuration: 0.4 red: 0 green: 0 blue: 255];
	id toGreen = [CCTintTo actionWithDuration: 0.8 red: 0 green: 255 blue: 0];
	/*
	 id redSequence = [CCSequence actions: toRed, fromBlue, nil];
	 id blueSequence = [CCSequence actions: toBlue, fromGreen, nil];
	 id greenSequence = [CCSequence actions: toGreen, fromRed, nil];
	 */
	id redSequence = [CCSequence actions: fromRed, toRed, fromRed, toBlue, fromRed, toGreen, nil];
	CCSprite * help = [CCSprite spriteWithFile:@"help.png"];
	help.position = ccp(50,285);
	help.scale = .5;
	CCSprite * play = [CCSprite spriteWithFile:@"play.png"];
	play.scale = .20;
	CCSprite * create = [CCSprite spriteWithFile:@"create.png"];
	create.scale = .4;
	CCSprite * share = [CCSprite spriteWithFile:@"share.png"];
	share.scale = .4;
	
	CCLabelTTF * playex = [CCLabelTTF labelWithString:@"Hit me to play the game!" fontName:@"Hellovetica" fontSize:12];
	CCLabelTTF * createex = [CCLabelTTF labelWithString:@"Hit me to create new beatmaps!" fontName:@"Hellovetica" fontSize:12];
	CCLabelTTF * shareex = [CCLabelTTF labelWithString:@"Hit me to upload and download" fontName:@"Hellovetica" fontSize:12];
	CCLabelTTF * shareex2 = [CCLabelTTF labelWithString:@"new beatmaps!" fontName:@"Hellovetica" fontSize : 12];

	playex.color = (ccColor3B){0,0,0};
	createex.color = (ccColor3B){0,0,0};
	shareex.color = (ccColor3B){0,0,0};
	shareex2.color = (ccColor3B){0,0,0};
	playex.position = ccp(325,200);
	createex.position = ccp(325,125);
	shareex.position = ccp(325,50);
	shareex2.position = ccp(325,25);
	
	play.position = ccp(100, 200);
	create.position = ccp(100, 125);
	share.position = ccp(100, 50);
	
	[play runAction: [CCRepeatForever actionWithAction: redSequence]];

	
	//CCSprite * back1 = [CCSprite spriteWithFile:@"back.png"];
	//CCMenuItemSprite * back = [CCMenuItemSprite itemFromNormalSprite:back1 selectedSprite:nil target:self selector:@selector(backToOptions:)];
	//CCMenu * menu = [CCMenu menuWithItems:back,nil];
	//menu.position = ccp(480/2,320/2);
	//back.scale = .5;
	//back.position = ccp(185,-120);
	[self addChild:help];
	//[self addChild:menu];
	[self addChild:play];
	[self addChild:create];
	[self addChild:share];
	[self addChild:playex];
	[self addChild:createex];
	[self addChild:shareex];
	[self addChild:shareex2];
	}
	return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//MPMusicPlayerController * musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
	//[musicPlayer pause];
	NSLog(@"Umm..... hello?");
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[HelpScene2 scene]]];
}

@end
