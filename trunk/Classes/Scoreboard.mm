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
		[self setScoreDisplay: [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica" fontSize:24.0]];
		scoreDisplay.position =  ccp(430,300);
		[self setComboDisplay: [CCLabelTTF labelWithString:@"0" fontName:@"Helvetica" fontSize:24.0]];
		comboDisplay.position = ccp (443,267);
		//[self setScoreBackground:[CCSprite spriteWithFile:@"newscorehud.png"]];
		
		//scoreBackground = [CCSprite spriteWithFile:@"newscorehud.png"];
		[self setScoreBackground:[CCSprite spriteWithFile:@"ihateyouscorehud.png"]];
		[self setComboBackground:[CCSprite spriteWithFile:@"newcombohud.png"]];
		scoreBackground.scale = .35;
		comboBackground.scale = .35;
		scoreBackground.position = ccp(415, 295);
		comboBackground.position = ccp(435, 250);
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
	[scoreDisplay setString: [NSString stringWithFormat:@"%d", score]];
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
