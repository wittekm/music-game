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
@synthesize comboDisplay;
@synthesize scoreBackground;
@synthesize comboBackground;
@synthesize hit;
@synthesize miss;

- (id) init
{
	if (( self = [super init]) )
	{
		[self setScore:0];
		[self setCombo:0];
		[self setScoreDisplay: [CCLabelBMFont labelWithString:@"0" fntFile:@"zerofourbee-48.fnt"]];
		scoreDisplay.position =  ccp(465,280);
		[scoreDisplay setAnchorPoint:ccp(1,1)];
		scoreDisplay.scale = .5;
		 [self setComboDisplay: [CCLabelBMFont labelWithString:@"0" fntFile:@"zerofourbee-48.fnt"]];
		comboDisplay.position = ccp(465,215);
		 [comboDisplay setAnchorPoint:ccp(1,1)];
		comboDisplay.scale = .5;
		//[self setScoreBackground:[CCSprite spriteWithFile:@"newscorehud.png"]];
		
		//scoreBackground = [CCSprite spriteWithFile:@"newscorehud.png"];
		[self setScoreBackground:[CCSprite spriteWithFile:@"finalscorehud.png"]];
		[self setComboBackground:[CCSprite spriteWithFile:@"finalcombohud.png"]];
		scoreBackground.scale = .40;
		comboBackground.scale = .40;
		scoreBackground.position = ccp(415, 275);
		comboBackground.position = ccp(435, 210);
		[self addChild:scoreBackground];
		[self addChild:comboBackground];
		[self addChild:scoreDisplay];
		[self addChild:comboDisplay];
	}
	return self;
}

- (void) hitWith : (int) points{
	if (points == 0){
		[self setCombo: 0];
		miss++;
	}
	else{
		[self setCombo: [self combo] + 1];
		hit++;
	}
	[self setScore: [self score] + [self combo] * points];
	[self updateScore];
}


- (void) updateScore
{
	//here we'll use clever bitmasking tricks to get each digit individually
	//nah
	//[self setScoreDisplay: [[
	[scoreDisplay setString: [NSString stringWithFormat:@"%d", score/10]];
	[comboDisplay setString: [NSString stringWithFormat:@"%d", combo]];
}

- (void) resetCombo {
	combo = 0;
}

- (void) dealloc
{
	//[score release];
	[super dealloc];
}

@end
