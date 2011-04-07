//
//  ResultsScreen.m
//  musicGame
//
//  Created by Max Wittek on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultsScreen.h"


@implementation ResultsScreen
@synthesize beatmap;
@synthesize scoreboard;

+(id) sceneWithBeatmap: (Beatmap*)beatmap_ scoreboard: (Scoreboard*)scoreboard_
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ResultsScreen *layer = [ResultsScreen node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	layer.beatmap = beatmap_;
	layer.scoreboard = scoreboard_;
	
	[layer begin];
	
	// return the scene
	return scene;
}

-(id) init {

	if( (self = [super init]) ) {
		beatnik = [CCSprite spriteWithFile:@"beatnik.png"];
		speechBubble = [CCSprite spriteWithFile:@"speechbubble.png"];
		beatnik.position = ccp(480.*.75, 320/2);
		speechBubble.position = ccp(480.*.30, 320/2 + 20);
		[self addChild:beatnik];
		[self addChild:speechBubble];
	}
	return self;
}

-(void) begin {
	double beatLength = beatmap->beatLength / 1000.;
	id moveBeatnikRight = [CCMoveBy actionWithDuration:beatLength position:ccp(20,0)];
	id moveBeatnikLeft = [CCMoveBy actionWithDuration:beatLength position:ccp(-20,0)];

	[beatnik runAction:[CCRepeatForever actionWithAction: [CCSequence actionOne:moveBeatnikRight two:moveBeatnikLeft ] ] ];
	NSString * pctString = [NSString stringWithFormat:@"%d outta %d?!", [scoreboard hit], [scoreboard miss] + [scoreboard hit]];
	
	//CCLabelTTF * percentage = [CCLabelTTF labelWithString:pctString fontName:@"Helvetica" fontSize:72];
	CCLabelBMFont * percentage = [CCLabelBMFont labelWithString:pctString fntFile:@"pkmn.fnt" ];
	[percentage setAnchorPoint:ccp(0,0)];
	[percentage setColor:(ccColor3B){0, 0, 0}];
	[percentage setScale: 1.0];
	[percentage setPosition:ccp(30, 320-90)];
	[self addChild: percentage];
}
	 
	 
@end
