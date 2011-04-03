//
//  Scoreboard.mm
//  musicGame
//
//  Created by Max Kolasinski on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Scoreboard.h"

@implementation Scoreboard

@synthesize score;
@synthesize combo;
@synthesize scoreDisplay;
@synthesize scoreBackground;

- (id) init
{
	if (( self = [super init]) )
	{
		[self setScore:0];
		[self setCombo:0];
		[self setScoreDisplay: [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica" fontSize:24.0]];
		scoreDisplay.position =  ccp(450,300);
		[self setScoreBackground:[CCSprite spriteWithFile:@"scorehud.png"]];
		scoreBackground.position = ccp(435, 300);
		scoreBackground.scale = 0.15;
		[self addChild:scoreBackground];
		[self addChild:scoreDisplay];
	}
	return self;
}

- (void) hitFull
{
	NSLog(@"+++++++++++ herro");
	[self setCombo: [self combo] + 1];
	if ([self combo] > 39){
		[self setScore: [self score] + 400];
	}
	if ([self combo] > 29){
		[self setScore: [self score] + 300];
	}
	if ([self combo] > 19){
		[self setScore: [self score] + 200];
	}
	if ([self combo] > 9){
		[self setScore: [self score] + 100];
	}
	[self updateScore];
}

- (void) hitHalf
{
	[self setCombo: [self combo] + 1];
	if ([self combo] > 39){
		[self setScore: [self score] + 200];
	}
	if ([self combo] > 29){
		[self setScore: [self score] + 150];
	}
	if ([self combo] > 19){
		[self setScore: [self score] + 100];
	}
	if ([self combo] > 9){
		[self setScore: [self score] + 50];
	}
}

- (void) hitMiss
{
	[self setCombo:0];
}

- (void) updateScore
{
	//here we'll use clever bitmasking tricks to get each digit individually
	//nah
	//[self setScoreDisplay: [[
	[scoreDisplay setString: [NSString stringWithFormat:@"%d", score]];
}
- (void) dealloc
{
	//[score release];
	[super dealloc];
}

@end
