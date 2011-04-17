//
//  BeatnikAlert.m
//  musicGame
//
//  Created by Max Wittek on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BeatnikAlert.h"


@implementation BeatnikAlert
@synthesize message;

- (id) initWithParent: (CCNode*)parent_ text: (NSString*)text;
{
	if( (self = [super init])) {
		self.isTouchEnabled = true;
		
		CCSprite* beatnik = [CCSprite spriteWithFile:@"beatnik.png"];
		CCSprite* speechBubble = [CCSprite spriteWithFile:@"speechbubble.png"];
		beatnik.position = ccp(480.*.75, 320/2);
		speechBubble.position = ccp(480.*.30, 320/2 + 20);
		[self addChild:beatnik];
		[self addChild:speechBubble];
		
		message = 
		[CCLabelBMFont labelWithString:text fntFile:@"pkmn.fnt"];
		message.scaleY = 3.0;
		message.scaleX = 1.5;
		[message setAnchorPoint:ccp(0,1)];
		[message setPosition:ccp(30, 320-80)];
		[message setColor:ccRED];
		[self addChild: message];
		
		self.scale = 0.33;
		
		self.position = ccp(320/2, -400);
		
		parent = parent_;
		[parent addChild:self];
		
		[self runAction: [CCMoveTo actionWithDuration:0.5 position:ccp(320/2, -120)]];
		
		id removeAction = [CCCallBlock actionWithBlock:^{
			[parent removeChild:self cleanup:true];
		}];
		
		[self runAction: [CCSequence actions:[CCDelayTime actionWithDuration:2], [CCMoveTo actionWithDuration:1 position:ccp(320/2, -400)], removeAction, nil] ];
	}
	return self;
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	id removeAction = [CCCallBlock actionWithBlock:^{
		[parent removeChild:self cleanup:true];
	}];
	
	
	[self runAction: [CCSequence actions:[CCMoveTo actionWithDuration:1 position:ccp(320/2, -400)], removeAction, nil] ];
}

@end
