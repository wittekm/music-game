//
//  HelpScene2.mm
//  musicGame
//
//  Created by Max Kolasinski on 4/18/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HelpScene2.h"


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
		
		CCLabelTTF * circleex = [CCLabelTTF labelWithString:@"Hit me before the circle closes!" fontName:@"Hellovetica" fontSize:12];
		CCLabelTTF * sliderex = [CCLabelTTF labelWithString:@"Slide your finger with the circle!" fontName:@"Hellovetica" fontSize:12];
		CCLabelTTF * spinnerex = [CCLabelTTF labelWithString:@"Spin me right round baby!" fontName:@"Hellovetica" fontSize:12];
		
		CCSprite * twirl = [CCSprite spriteWithFile:@"twirl.png"];
		twirl.scale = .2;
		twirl.position = ccp(100,50);
		circleex.color = (ccColor3B){0,0,0};
		sliderex.color = (ccColor3B){0,0,0};
		spinnerex.color = (ccColor3B){0,0,0};
		circleex.position = ccp(325,200);
		sliderex.position = ccp(325,125);
		spinnerex.position = ccp(325,50);
		[self addChild:circleex];
		[self addChild:sliderex];
		[self addChild:spinnerex];
		[self addChild:twirl];
	}
	return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	//MPMusicPlayerController * musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
	//[musicPlayer pause];
	NSLog(@"Umm..... hello?");
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MenuScene scene]]];
}
@end
