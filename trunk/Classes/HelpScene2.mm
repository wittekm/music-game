//
//  HelpScene2.mm
//  musicGame
//
//  Created by Max Kolasinski on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelpScene2.h"
#import "HODCircle.h"


@implementation HelpScene2

+(id) scene
{
	CCScene * scene = [CCScene node];
	HelpScene2 * layer = [HelpScene2 node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	
	if( (self=[super initWithColor:ccc4(238,232,170,255)])) {
		self.isTouchEnabled = YES;
		CCSprite * help = [CCSprite spriteWithFile:@"help.png"];
		help.position = ccp(50,285);
		help.scale = .5;
		[self addChild:help];
		
		CCLabelTTF * circleex = [CCLabelTTF labelWithString:@"Hit me when the outer circle closes!" fontName:@"Hellovetica" fontSize:12];
		CCLabelTTF * sliderex = [CCLabelTTF labelWithString:@"Slide your finger along this!" fontName:@"Hellovetica" fontSize:12];
		CCLabelTTF * spinnerex = [CCLabelTTF labelWithString:@"Spin me around!" fontName:@"Hellovetica" fontSize:12];
		
		CCSprite * twirl = [CCSprite spriteWithFile:@"twirl.png"];
		
		//CCSprite * circle = [CCSprite spriteWithFile:@"Help_Circle.png"];
		//CCSprite *ring = [CCSprite spriteWithFile:@"ring.png"];
		HitObject * exCircle = new HitObject(75, 245, 0, 1, 1);
		circle = [[HODCircle alloc] initWithHitObject:exCircle red:200 green:0 blue:0];
		[circle justDisplay];
		circle.scale = 0.75;
		
		CCSprite * slider = [CCSprite spriteWithFile:@"Help_Slider.png"];
		//circle.scale = .75;
		slider.scale = .4;
		//circle.position = ccp(100,230);
		slider.position = ccp(100, 140);
		
		twirl.scale = .2;
		twirl.position = ccp(100,50);
		circleex.color = (ccColor3B){0,0,0};
		sliderex.color = (ccColor3B){0,0,0};
		spinnerex.color = (ccColor3B){0,0,0};
		circleex.position = ccp(325,230);
		sliderex.position = ccp(325,135);
		spinnerex.position = ccp(325,50);
		[self addChild:circleex];
		[self addChild:sliderex];
		[self addChild:spinnerex];
		
		[self addChild:twirl];
		[self addChild:circle];
		[self addChild:slider];
	}
	return self;
}

bool didCircle = false;

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//MPMusicPlayerController * musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
	//[musicPlayer pause];
	if(!didCircle) {
		didCircle = true;
		[circle appearWithDuration:1];
	} else {
		didCircle = false;
		NSLog(@"Umm..... hello?");
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MenuScene scene]]];
	}
}
@end
