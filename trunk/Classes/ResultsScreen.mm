//
//  ResultsScreen.m
//  musicGame
//
//  Created by Max Wittek on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ResultsScreen.h"
#import "MenuScene.h"


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
		self.isTouchEnabled = YES;
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
		
	double pct = double(scoreboard.hit) / (scoreboard.hit + scoreboard.miss);
	NSLog(@"%f", pct);
	if( pct < 0.50 ) {
		CCLabelBMFont * response1 = 
		[CCLabelBMFont labelWithString:@"TERRIBLE." fntFile:@"pkmn.fnt"];
		response1.scaleY = 3.0;
		response1.scaleX = 1.5;
		[response1 setAnchorPoint:ccp(0,1)];
		[response1 setPosition:ccp(30, 320-130)];
		[response1 setColor:ccRED];
		[self addChild: response1];
	}
	else {
		CCLabelBMFont * response1 = 
		[CCLabelBMFont labelWithString:@"GROOVY!" fntFile:@"pkmn.fnt"];
		response1.scaleY = 3.0;
		response1.scaleX = 1.5;
		[response1 setAnchorPoint:ccp(0,1)];
		[response1 setPosition:ccp(30, 320-130)];
		[response1 setColor:ccRED];
		[self addChild: response1];
	}

	
}
	 
- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MenuScene scene]]];
}
	 
@end
